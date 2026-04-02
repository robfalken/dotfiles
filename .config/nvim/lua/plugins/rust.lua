-- crates.nvim setup (Cargo.toml dependency management)
local crates = require("crates")
crates.setup({
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
  popup = {
    border = "rounded",
  },
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "Cargo.toml",
  callback = function(ev)
    local buf_opts = { buffer = ev.buf }
    vim.keymap.set("n", "<leader>ct", function() crates.toggle() end,
      vim.tbl_extend("force", buf_opts, { desc = "Toggle crate info" }))
    vim.keymap.set("n", "<leader>cr", function() crates.reload() end,
      vim.tbl_extend("force", buf_opts, { desc = "Reload crate info" }))
    vim.keymap.set("n", "<leader>cv", function() crates.show_versions_popup() end,
      vim.tbl_extend("force", buf_opts, { desc = "Show crate versions" }))
    vim.keymap.set("n", "<leader>cf", function() crates.show_features_popup() end,
      vim.tbl_extend("force", buf_opts, { desc = "Show crate features" }))
    vim.keymap.set("n", "<leader>cd", function() crates.show_dependencies_popup() end,
      vim.tbl_extend("force", buf_opts, { desc = "Show crate dependencies" }))
    vim.keymap.set("n", "<leader>cu", function() crates.update_crate() end,
      vim.tbl_extend("force", buf_opts, { desc = "Update crate" }))
    vim.keymap.set("n", "<leader>cU", function() crates.upgrade_crate() end,
      vim.tbl_extend("force", buf_opts, { desc = "Upgrade crate" }))
    vim.keymap.set("n", "<leader>cA", function() crates.upgrade_all_crates() end,
      vim.tbl_extend("force", buf_opts, { desc = "Upgrade all crates" }))
    vim.keymap.set("n", "<leader>cH", function() crates.open_homepage() end,
      vim.tbl_extend("force", buf_opts, { desc = "Open crate homepage" }))
    vim.keymap.set("n", "<leader>cR", function() crates.open_repository() end,
      vim.tbl_extend("force", buf_opts, { desc = "Open crate repository" }))
    vim.keymap.set("n", "<leader>cD", function() crates.open_documentation() end,
      vim.tbl_extend("force", buf_opts, { desc = "Open crate docs.rs" }))
    vim.keymap.set("n", "<leader>cC", function() crates.open_crates_io() end,
      vim.tbl_extend("force", buf_opts, { desc = "Open crates.io" }))
  end,
})
