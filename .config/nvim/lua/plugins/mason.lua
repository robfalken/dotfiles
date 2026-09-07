-- Installs LSP servers only. Formatters and linters come from Homebrew so the
-- same binaries are available to the shell, pre-commit hooks, and other tools.
return {
  src = "https://github.com/mason-org/mason.nvim",

  setup = function()
    require("mason").setup()
  end,
}
