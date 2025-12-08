vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape to Normal mode", remap = true })
vim.keymap.set("n", ";", ":", { desc = "Cmd (alias for :)", remap = true })
