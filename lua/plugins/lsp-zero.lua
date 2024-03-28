return {

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },

    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format({details = true}),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-8),
                    ['<C-d>'] = cmp.mapping.scroll_docs(8),
                    -- ['<C-f>'] = cmp.mapping.luasnip_jump_forward(),
                    -- ['<C-b>'] = cmp.mapping.luasnip_jump_backward(),
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = {'LspInfo', 'LspInstall', 'LspStart'},
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            -- if you want to know more about lsp-zero and mason.nvim
            -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp_zero_keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({buffer = bufnr})
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'pyright',
                    'ruff_lsp',
                    'tsserver',
                    'lua_ls',
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- (Optional) Configure lua langauge server for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                },
            })
        end,
    },

    -- Lint
    {
        "mfussenegger/nvim-lint",
        cond = not vim.g.vscode,
        dependencies = {
            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        },
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        opts = {
            autocmd = {
                events = { "BufEnter", "BufWritePost" },
                pattern = { "*.py", "*.lua", "*.js", "*.ts", },
                linters_by_ft = {
                    python = { "mypy" },
                },
            },
            on_demand = {
                linters_by_ft = {
                    python = { "mypy", "pylint" },
                },
            },
        },
        config = function(_, opts)
            local lint = require("lint")
            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
            }

            local function lint_autocmd()
                local filetype = vim.bo.filetype
                local linter_names = opts.autocmd.linters_by_ft[filetype] or {}
                require("lint").try_lint(linter_names)
            end

            local function lint_on_demand()
                local filetype = vim.bo.filetype
                local linter_names = opts.on_demand.linters_by_ft[filetype] or {}
                require("lint").try_lint(linter_names)
            end

            local lint_augroup = vim.api.nvim_create_augroup("user-nvim-lint", { clear = true })
            vim.api.nvim_create_autocmd(opts.autocmd.events, {
                group = lint_augroup,
                pattern = opts.autocmd.pattern,
                callback = lint_autocmd,
            })

            vim.keymap.set("n", "<leader>cl", lint_on_demand, { desc = "[C]ode [l]int" })

            -- Hate to remove this because I was pretty proud of it, but I'm removing
            -- Pylint altogether. Since this is just my code, I'm leaving it here
            -- as a reference if I want to mess with it again later.
            -- -- I use Pylint consistently, and I have some projects that enforce
            -- -- that Pylint must be passing. However, I don't always want to see
            -- -- low-severity Pylint warnings like "missing docstring" for things
            -- -- I'm still actively writing. They can be distracting.
            -- --
            -- -- Build out a simple behavior that switches the Pylint arguments
            -- -- to include or exclude Pylint's complexity (C) and conventions (R)
            -- -- messages.
            -- --
            -- -- I intentionally make this a global user command instead of a
            -- -- buffer-specific one.
            --
            -- local default_pylint_args = vim.deepcopy(lint.linters.pylint.args)
            -- local simple_pylint_args = vim.deepcopy(lint.linters.pylint.args)
            -- table.insert(simple_pylint_args, "--disable=C,R")
            --
            -- local disable_pylint_low_severity = false
            -- local function toggle_pylint_severity_mode()
            --     disable_pylint_low_severity = not disable_pylint_low_severity
            --     if disable_pylint_low_severity then
            --         lint.linters.pylint.args = simple_pylint_args
            --         print("Pylint mode changed to error/warning only")
            --     else
            --         lint.linters.pylint.args = default_pylint_args
            --         print("Pylint mode reset to default")
            --     end
            --     -- Run the linter again to remove leftover messages or restore
            --     -- newly added ones
            --     lint.try_lint()
            -- end
            --
            -- vim.api.nvim_create_user_command("PylintSeverityToggle", toggle_pylint_severity_mode, {})
        end,
    }
}
