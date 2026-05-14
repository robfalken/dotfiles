require("which-key").setup()

require("which-key").add({
  { "<leader>s", group = "Search" },
  { "<leader>g", group = "Git" },
  { "<leader>b", group = "Buffer" },
})
