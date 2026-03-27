return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = { "nvimtools/hydra.nvim" },
  opts = {},
  cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  keys = {
    { "<Leader>m", "<cmd>MCstart<cr>", mode = { "v", "n" }, desc = "Multi cursor" },
  },
}
