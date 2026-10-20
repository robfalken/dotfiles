return {
  src = "https://github.com/catppuccin/nvim",
  -- The repo is catppuccin/nvim, so the directory needs an explicit name.
  name = "catppuccin",

  setup = function()
    require("catppuccin").setup({
      flavour = "macchiato",

      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },

      -- Pick up highlight groups for whichever supported plugins are
      -- installed (gitsigns, blink, snacks, noice, flash, which-key, ...)
      -- instead of listing them here.
      auto_integrations = true,

      custom_highlights = function(c)
        return {
          -- Dim the 'listchars' glyphs. Whitespace otherwise links to
          -- NonText, which is loud enough to compete with the code.
          Whitespace = { fg = c.surface1 },

          -- Staged work is settled work: give every staged hunk one muted
          -- colour and let the hollow glyph (see the gitsigns spec) say
          -- which kind of change it was.
          GitSignsStagedAdd = { fg = c.overlay1 },
          GitSignsStagedChange = { fg = c.overlay1 },
          GitSignsStagedDelete = { fg = c.overlay1 },
          GitSignsStagedChangedelete = { fg = c.overlay1 },
          GitSignsStagedTopdelete = { fg = c.overlay1 },

          -- The post-yank flash (see config.autocmds). Dark text on the
          -- pink so it reads as a highlight for the 150ms it is up.
          YankFlash = { bg = c.pink, fg = c.base },
        }
      end,
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
