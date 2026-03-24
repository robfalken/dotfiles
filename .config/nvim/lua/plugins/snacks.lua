return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    require("snacks").setup(opts)
    require("snacks.picker").setup()
  end,
  opts = {
    lazygit = { enabled = true },
    toggle = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        projects = {
          patterns = { ".git", "Makefile", "package.json", "Cargo.toml" },
        },
      },
    },
    indent = { enabled = true },
    gh = { enabled = true },
  },
  keys = {
    {
      "<leader>lg",
      function()
        Snacks.lazygit()
      end,
      desc = "Open Lazygit",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>\\",
      function()
        Snacks.picker.explorer({
          hidden = false,
          layout = { layout = { position = "right" } },
        })
      end,
      desc = "Browse files",
    },
    {
      "<C-p>",
      function()
        Snacks.picker.files({ hidden = false })
      end,
      desc = "Find files",
    },
    {
      "<C-f>",
      function()
        Snacks.picker.lines()
      end,
      desc = "Search current buffer",
    },
    {
      "<leader>ss",
      function()
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
      end,
      desc = "Search symbols in current file",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Search grep in project",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      mode = { "n", "x" },
      desc = "Search word under cursor in project",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Search marks",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Search projects",
    },
  },
}
