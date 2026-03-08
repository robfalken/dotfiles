return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Register tsx parser for typescriptreact filetype *before* setup so it's
    -- available when buffers are attached (avoids race with other plugins).
    vim.treesitter.language.register("tsx", "typescriptreact")

    require("nvim-treesitter").setup({
      ensure_installed = {
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "json",
        "jsonc",
        "lua",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })

    -- Force treesitter highlight on for TSX buffers (fixes timing/attach issues).
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "typescriptreact",
      callback = function()
        vim.schedule(function()
          pcall(vim.cmd, "TSBufEnable highlight")
        end)
      end,
    })

    -- If the buffer that triggered loading is TSX, enable highlight now.
    if vim.bo.filetype == "typescriptreact" then
      vim.schedule(function()
        pcall(vim.cmd, "TSBufEnable highlight")
      end)
    end
  end,
}
