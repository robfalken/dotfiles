return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
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

    vim.treesitter.language.register("tsx", "typescriptreact")

    local ok_ts, ts = pcall(require, "nvim-treesitter")
    if ok_ts and type(ts.setup) == "function" then
      ts.setup({})
    end
    if ok_ts and type(ts.install) == "function" then
      pcall(ts.install, languages, { summary = true })
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(ev)
        local buf = ev.buf
        if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
          return
        end

        local ft = vim.bo[buf].filetype
        if ft == "" then
          return
        end

        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not pcall(vim.treesitter.language.inspect, lang) then
          return
        end

        vim.treesitter.start(buf, lang)
      end,
    })
  end,
}
