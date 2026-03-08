return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TSInstall",
    "TSInstallFromGrammar",
    "TSUpdate",
    "TSUninstall",
    "TSBufEnable",
    "TSBufDisable",
  },
  config = function()
    local languages = {
      "typescript",
      "tsx",
      "javascript",
      "html",
      "css",
      "json",
      "lua",
      "rust",
    }

    -- Register tsx parser for typescriptreact filetype *before* setup so it's
    -- available when buffers are attached (avoids race with other plugins).
    vim.treesitter.language.register("tsx", "typescriptreact")

    -- Support both legacy and current nvim-treesitter APIs.
    local ok_configs, ts_configs = pcall(require, "nvim-treesitter.configs")
    if ok_configs and type(ts_configs.setup) == "function" then
      ts_configs.setup({
        ensure_installed = languages,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    else
      local ok_ts, ts = pcall(require, "nvim-treesitter")
      if ok_ts and type(ts.setup) == "function" then
        ts.setup({})
      end
      if ok_ts and type(ts.install) == "function" then
        pcall(ts.install, languages, { summary = true })
      end
    end

    -- Force treesitter highlight on for buffers that can miss initial attach.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typescriptreact", "lua", "rust" },
      callback = function()
        if vim.bo.filetype == "rust" and not vim.uv.fs_stat(vim.fn.stdpath("data") .. "/site/parser/rust.so") then
          pcall(vim.cmd, "TSInstall rust")
        end

        vim.schedule(function()
          pcall(vim.treesitter.start, 0)
          pcall(vim.cmd, "TSBufEnable highlight")
        end)
      end,
    })

    -- If the buffer that triggered loading matches one of these, enable now.
    if vim.tbl_contains({ "typescriptreact", "lua", "rust" }, vim.bo.filetype) then
      vim.schedule(function()
        pcall(vim.treesitter.start, 0)
        pcall(vim.cmd, "TSBufEnable highlight")
      end)
    end
  end,
}
