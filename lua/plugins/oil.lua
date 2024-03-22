return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "g-", function() require("oil").open() end, desc = "Open Oil fil browser" },
    },
    lazy = false,
    opts = {
        keymaps = {
            -- Disabling because I want Telescope to use this
            ["<C-p>"] = false
        }
    }
}
