return {
    "tpope/vim-fugitive",
    keys = { -- load the plugin only when using it's keybinding:
        { "<leader>gs", vim.cmd.Git, desc = "Vim Fugitive" },
    },
}
