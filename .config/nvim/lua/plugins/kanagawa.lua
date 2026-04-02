require("kanagawa").setup({
  overrides = function(colors)
    local theme = colors.theme
    return {
      NormalFloat = { bg = theme.ui.bg },
      FloatBorder = { bg = theme.ui.bg },
      FloatTitle = { bg = theme.ui.bg },
      FloatFooter = { bg = theme.ui.bg },
      LineNr = { fg = theme.ui.nontext, bg = theme.ui.bg },
      CursorLineNr = { fg = theme.diag.warning, bg = theme.ui.bg, bold = true },
      SignColumn = { fg = theme.ui.special, bg = theme.ui.bg },
      FoldColumn = { fg = theme.ui.nontext, bg = theme.ui.bg },
      SnacksPickerTree = { fg = theme.ui.nontext },
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
    }
  end,
})
vim.cmd("colorscheme kanagawa")
