return {
  "github/copilot.vim",
  init = function()
    vim.g.copilot_no_tab_map = true
  end,
  keys = {
    { "<C-J>", 'copilot#Accept("")', mode = "i", expr = true, replace_keycodes = false, desc = "Copilot accept" },
  },
}
