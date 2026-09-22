-- Neovim config entry point (Neovim 0.12+, native vim.pack plugin manager)

-- Leader keys (must be set before plugin loading)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.filetypes")

-- Plugins. Each module in lua/plugins/ returns { src, name?, setup } so a
-- plugin is described in exactly one file. Order here is load order: an
-- icon provider or colorscheme goes before whatever consumes it.
local plugins = {
  "rose-pine",
  "devicons",
  "oil",
  "snacks",
  "gitsigns",
  "flash",
  "which-key",
  "nui",
  "noice",
  "mason",
  "blink",
  "lazydev",
  "lspconfig",
  "mason-lspconfig",
  "conform",
  "lint",
  "treesitter",
  "autotag",
}

local specs = {}
for _, module in ipairs(plugins) do
  specs[#specs + 1] = require("plugins." .. module)
end

-- One install pass for every plugin; clones what is missing, then puts all
-- of them on the runtimepath so the setups below can require them.
vim.pack.add(vim.tbl_map(function(spec)
  return { src = spec.src, name = spec.name, version = spec.version }
end, specs))

for i, spec in ipairs(specs) do
  if spec.setup then
    local ok, err = pcall(spec.setup)
    if not ok then
      vim.notify(("plugin setup failed: %s\n%s"):format(plugins[i], err), vim.log.levels.ERROR)
    end
  end
end

require("config.keymaps")
require("config.autocmds")
