return {
  src = "https://github.com/folke/which-key.nvim",

  setup = function()
    local wk = require("which-key")

    wk.setup({
      -- Popup delay in ms after an incomplete mapping (independent of 'timeoutlen').
      delay = 300,
    })

    -- Names for the prefixes used by the mappings in this config.
    wk.add({
      { "gr", group = "lsp" },
      { "grr", icon = "󰈇 " },
      { "gra", icon = " " },
      { "grn", icon = " " },
      { "gri", icon = " " },
      { "grt", icon = " " },
      { "grx", icon = " " },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>cp", icon = " " },
      { "<leader>g", group = "Git", icon = " " },
      { "<leader>l", group = "LazyGit" },
      { "<leader>m", group = "Multicursor" },
      { "<leader>s", group = "Search" },
      -- Hunk motions from the gitsigns spec; the mappings themselves are
      -- buffer-local, these just name the keys in the popup.
      { "]h", desc = "Next hunk", icon = " " },
      { "[h", desc = "Previous hunk", icon = " " },
    })
  end,
}
