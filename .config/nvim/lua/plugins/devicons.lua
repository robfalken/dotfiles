-- Icon provider used by oil.nvim and which-key.nvim. Requires a Nerd Font
-- in the terminal; set `color_icons = false` for a plainer look.
return {
  src = "https://github.com/nvim-tree/nvim-web-devicons",

  setup = function()
    require("nvim-web-devicons").setup({
      color_icons = true,
    })
  end,
}
