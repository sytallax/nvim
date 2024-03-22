return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Mark file with Harpoon" },
    { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Open Harpoon menu" },
    { "<leader>j", function() require("harpoon.ui").nav_file(1) end, desc = "Open Harpoon file 1" },
    { "<leader>k", function() require("harpoon.ui").nav_file(2) end, desc = "Open Harpoon file 2" },
    { "<leader>l", function() require("harpoon.ui").nav_file(3) end, desc = "Open Harpoon file 3" },
    { "<leader>;", function() require("harpoon.ui").nav_file(4) end, desc = "Open Harpoon file 4" },
  },
  config = true
}
