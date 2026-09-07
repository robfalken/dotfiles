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
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
