require("multicursors").setup({})

vim.keymap.set({ "v", "n" }, "<Leader>m", "<cmd>MCstart<cr>", { desc = "Multi cursor" })
