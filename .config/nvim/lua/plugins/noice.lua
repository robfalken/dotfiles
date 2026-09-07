return {
  src = "https://github.com/folke/noice.nvim",

  setup = function()
    require("noice").setup({
      cmdline = { enabled = true, view = "cmdline_popup" },

      -- Leave the rest of the message UI native. These keep noice off
      -- ext_messages entirely, which is where most of its surprising
      -- interactions with other plugins come from.
      messages = { enabled = false },
      popupmenu = { enabled = false },
      notify = { enabled = false },
      lsp = { progress = { enabled = false } },
    })
  end,
}
