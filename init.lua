-- Setting the leader key just in case
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Sourcing regular nvim settings/keybindings
require("ibrahim.set")
require("ibrahim.keys")

-- Bootstrap Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Keymap to open Lazy
vim.keymap.set("n", "<leader>o", vim.cmd.Lazy)
