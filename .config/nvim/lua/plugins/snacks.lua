require("snacks").setup({
  lazygit = { enabled = true },
  toggle = { enabled = true },
  picker = {
    enabled = true,
    ui_select = true,
    formatters = {
      file = {
        truncate = 60,
        filename_first = true,
      },
    },
    sources = {
      projects = {
        patterns = { ".git", "Makefile", "package.json", "Cargo.toml" },
      },
    },
  },
  indent = { enabled = true },
  gh = { enabled = true },
})
require("snacks.picker").setup()

vim.keymap.set("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "Open Lazygit" })

vim.keymap.set("n", "<leader>gp", function()
  Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })

vim.keymap.set("n", "<leader>\\", function()
  Snacks.picker.explorer({
    hidden = false,
    layout = { layout = { position = "right" } },
  })
end, { desc = "Browse files" })

vim.keymap.set("n", "<C-p>", function()
  Snacks.picker.files({ hidden = false })
end, { desc = "Find files" })

vim.keymap.set("n", "<C-f>", function()
  Snacks.picker.lines()
end, { desc = "Search current buffer" })

vim.keymap.set("n", "<leader>ss", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local has_symbol_support = vim.iter(clients):any(function(c)
    return c.supports_method("textDocument/documentSymbol")
  end)
  if has_symbol_support then
    Snacks.picker.lsp_symbols({
      filter = { typescript = true, typescriptreact = true },
    })
  else
    Snacks.picker.treesitter()
  end
end, { desc = "Search symbols in current file" })

vim.keymap.set("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Search grep in project" })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Search word under cursor in project" })

vim.keymap.set("n", "<leader>sb", function()
  Snacks.picker.buffers()
end, { desc = "Search buffers" })

vim.keymap.set("n", "<leader>sm", function()
  Snacks.picker.marks()
end, { desc = "Search marks" })

vim.keymap.set("n", "<leader>sp", function()
  Snacks.picker.projects()
end, { desc = "Search projects" })
