return {
  src = "https://github.com/rose-pine/neovim",
  -- The repo is rose-pine/neovim, so the directory needs an explicit name.
  name = "rose-pine",

  setup = function()
    require("rose-pine").setup({
      variant = "dawn",

      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },

      -- Dim the 'listchars' glyphs. Whitespace otherwise links to NonText,
      -- which is loud enough to compete with the code. The palette role name
      -- resolves per variant (#dfdad9 in dawn) instead of pinning one hex.
      highlight_groups = {
        Whitespace = { fg = "highlight_high" },

        -- gitsigns derives its "staged hunk" colours by blending the unstaged
        -- ones toward the background. On a light variant that lands around
        -- 1.5:1 contrast -- invisible. Staged work is settled work, so give it
        -- one muted-but-legible colour and let the hollow glyph (see the
        -- gitsigns spec) say which kind of change it was.
        GitSignsStagedAdd = { fg = "subtle" },
        GitSignsStagedChange = { fg = "subtle" },
        GitSignsStagedDelete = { fg = "subtle" },
        GitSignsStagedChangedelete = { fg = "subtle" },
        GitSignsStagedTopdelete = { fg = "subtle" },

        -- The post-yank flash (see config.autocmds). "rose" is the pink in
        -- this palette; "love" is redder. The foreground stays "text" rather
        -- than inverting to the light "base", so the flash reads as a
        -- highlight over the code instead of a block that swaps colours --
        -- 3.34:1 against the pink, legible for the 150ms it is up.
        YankFlash = { bg = "rose", fg = "text" },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
