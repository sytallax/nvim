return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
        { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Telescope Live Grep" },
        { "<leader>tb", "<cmd>Telescope buffers initial_mode=normal<cr>", desc = "Telescope Buffers" }, -- Opens initally in normal mode for ease of previewing buffers
    },
}

