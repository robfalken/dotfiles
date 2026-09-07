-- General keymaps. Plugin-specific mappings live in that plugin's spec under
-- lua/plugins/ so they sit next to the setup that makes them work.

-- ; for : -- one less modifier on every command. In visual mode this opens
-- the cmdline prefilled with the '<,'> range. Shadows the built-in "repeat
-- f/t motion forward"; , still repeats one backwards.
vim.keymap.set({ "n", "x" }, ";", ":", { desc = "Cmd (alias for :)" })

-- kj leaves insert mode without reaching for Esc.
vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape to Normal mode" })

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>cs", "<cmd>noh<cr>", { desc = "Clear search" })

-- <leader><leader> rather than <C-Space>: many terminals send NUL for
-- <C-Space>, indistinguishable from <C-@>, so it never arrives as its own key.
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle previous file" })

-- Keep the selection after indenting so the shift can be repeated. Mode "x",
-- not "v": "v" also covers Select mode, where these keys must stay literal.
vim.keymap.set("x", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set("x", "<", "<gv", { desc = "Outdent and reselect" })
