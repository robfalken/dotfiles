-- Server definitions consumed by vim.lsp.enable(); nvim-lspconfig ships them
-- as lsp/<name>.lua on the runtimepath, so there is no setup() call here.
-- This spec owns the shared LSP behaviour instead.

-- Directories that cannot hold a project stylesheet but can hold thousands of
-- files. Used to prune the Tailwind v4 config search below.
local PRUNED_DIRS = {
  [".git"] = true,
  ["node_modules"] = true,
  [".next"] = true,
  ["dist"] = true,
  ["build"] = true,
  ["out"] = true,
  ["target"] = true,
  ["vendor"] = true,
  ["coverage"] = true,
}

-- The first stylesheet under `root` that imports Tailwind, or nil. Reads only
-- the head of each candidate: css requires @import before any rule, so the
-- directive is always near the top. Bounded on both depth and file count so a
-- monorepo cannot turn LSP startup into a filesystem crawl.
local function find_tailwind_stylesheet(root)
  local budget = 300
  for name, kind in
    vim.fs.dir(root, {
      depth = 6,
      skip = function(dir)
        return not PRUNED_DIRS[dir]
      end,
    })
  do
    if kind == "file" and name:match("%.[sp]?css$") then
      budget = budget - 1
      if budget < 0 then
        return nil
      end
      local path = root .. "/" .. name
      local fd = io.open(path, "r")
      if fd then
        local head = fd:read(2048) or ""
        fd:close()
        if head:match("@import%s+[\"']tailwindcss") then
          return path
        end
      end
    end
  end
end

return {
  src = "https://github.com/neovim/nvim-lspconfig",

  setup = function()
    vim.diagnostic.config({
      virtual_text = { spacing = 2 },
      severity_sort = true,
    })

    -- Colour swatches for anything a server reports as a colour -- in practice
    -- Tailwind, which resolves bg-sky-500 to its hex. Neovim turns this on by
    -- default with style = "background", which repaints the class name itself
    -- and turns a busy className into a rainbow; "virtual" puts a small swatch
    -- in front of the class instead and leaves the code alone.
    vim.lsp.document_color.enable(true, nil, { style = "virtual" })

    -- Per-server overrides go through vim.lsp.config() rather than a local
    -- lsp/<name>.lua. Neovim merges every lsp/ file on the runtimepath in
    -- runtimepath order, and ~/.config/nvim comes *before* the plugins -- so
    -- a file here would lose to nvim-lspconfig's on any shared key. Calls to
    -- vim.lsp.config() outrank all of them.
    --
    -- The workspace library is left to lazydev, which adds plugin sources on
    -- demand; only the settings it does not touch are set here.
    vim.lsp.config("lua_ls", {
      -- A flat marker list is a priority order, not a search order: the first
      -- name that matches *anywhere* up the tree wins. nvim-lspconfig ranks
      -- .luarc.json above stylua.toml above .git, so the stray
      -- ~/.config/.luarc.json (sketchybar's) outranked this directory's own
      -- markers and rooted the workspace at ~/.config -- putting every Lua
      -- file under it, nvim.bak included, in one workspace. The extra nesting
      -- makes these a single priority group, where the nearest ancestor
      -- holding any of them wins instead.
      root_markers = {
        {
          ".luarc.json",
          ".luarc.jsonc",
          ".emmyrc.json",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "selene.yml",
          ".git",
        },
      },

      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            -- How Neovim itself resolves require("config.options"), which
            -- LuaLS does not assume from the workspace root.
            path = { "lua/?.lua", "lua/?/init.lua" },
          },
          -- The library holds read-only Neovim and plugin sources; without
          -- this LuaLS prompts about every one of them on attach.
          workspace = { checkThirdParty = false },
          -- Leading underscore is the convention for private in this config.
          diagnostics = { unusedLocalExclude = { "_*" } },
          -- stylua owns Lua formatting (see the conform spec); leaving the
          -- server's formatter on means <leader>f can produce two styles.
          format = { enable = false },
        },
      },
    })

    -- Tailwind. The upstream config covers every filetype the VS Code
    -- extension does; narrowing it to the two in use here keeps the server
    -- out of plain CSS and JS buffers, where it has nothing to say. Add
    -- "javascriptreact" or "css" to this list as those come up -- css is
    -- what makes @apply and @theme stop reading as unknown at-rules.
    vim.lsp.config("tailwindcss", {
      filetypes = { "html", "typescriptreact" },

      -- Upstream also lists ".git" last, which makes this server start in
      -- *every* git repo holding an html or tsx file, Tailwind or not --
      -- workspace_required cannot filter that, because .git always matches.
      -- Dropping it means attaching needs real evidence: a tailwind/postcss
      -- config, or a package.json that mentions tailwindcss (how a v4
      -- project, which no longer needs tailwind.config.*, is recognised).
      -- A project with no manifest at all -- Tailwind straight from the CDN
      -- in a lone .html -- will not attach; give it a package.json or a
      -- tailwind.config.js, or put ".git" back at the end of this list.
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root_files = {
          "tailwind.config.js",
          "tailwind.config.cjs",
          "tailwind.config.mjs",
          "tailwind.config.ts",
          "postcss.config.js",
          "postcss.config.cjs",
          "postcss.config.mjs",
          "postcss.config.ts",
        }
        root_files = require("lspconfig.util").insert_package_json(root_files, "tailwindcss", fname)
        on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
      end,

      settings = {
        tailwindCSS = {
          -- Class names that never appear in a class attribute. Each entry is
          -- a JavaScript regex run by the server: the first captures the call
          -- to look inside, the second the string literals within it. Without
          -- this, cn("flex ...") in a tsx file gets no completion, no hover
          -- and no conflict warning.
          experimental = {
            classRegex = {
              { "(?:cn|cva|clsx|cx|twMerge|twJoin)\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "tw`([^`]*)" },
            },
          },
        },
      },

      -- Tailwind v4 dropped tailwind.config.*: the stylesheet that pulls the
      -- framework in *is* the config, so the server has to be pointed at it.
      -- Upstream's detector for that walks the entire project with an
      -- unbounded vim.fs.find -- node_modules included, reading every css it
      -- meets -- and then matches only @import 'tailwindcss'; with single
      -- quotes, which the Tailwind docs do not use. So it pays for the walk
      -- and still finds nothing. This one prunes the directories that cannot
      -- hold project css, reads only the head of each file (css requires
      -- @import before any rule), and accepts either quote style.
      before_init = function(params, config)
        config.settings = config.settings or {}
        config.settings.editor = config.settings.editor or {}
        config.settings.editor.tabSize = config.settings.editor.tabSize
          or vim.lsp.util.get_effective_tabstop()

        local tw = config.settings.tailwindCSS or {}
        config.settings.tailwindCSS = tw
        tw.experimental = tw.experimental or {}
        if tw.experimental.configFile then
          return
        end

        local root = config.root_dir or params.rootPath
        if not root then
          return
        end

        -- A v3 project has a real config file; pointing configFile at a
        -- stylesheet there would override it with something the server
        -- cannot read as a config. Only v4 projects need this.
        if
          vim.fs.find(function(name)
            return name:match("^tailwind%.config%.[cm]?[jt]s$")
          end, { path = root, type = "file", limit = 1 })[1]
        then
          return
        end

        tw.experimental.configFile = find_tailwind_stylesheet(root)
      end,
    })

    -- terraform-ls handles completion, hover and schema validation on its own,
    -- but shells out to a Terraform binary for `validate` and module
    -- installation. It only ever looks for `terraform`, so point it at
    -- OpenTofu when that is the one installed. terraform-ls ignores
    -- `settings` (no didChangeConfiguration support); it has to be
    -- init_options.
    if vim.fn.executable("terraform") == 0 and vim.fn.executable("tofu") == 1 then
      vim.lsp.config("terraformls", {
        init_options = { terraform = { path = vim.fn.exepath("tofu") } },
      })
    end

    -- Neovim maps the gr* family itself, but labels them with the function
    -- name ("vim.lsp.buf.rename()"), which is what which-key then displays.
    -- Re-set them with the same calls and readable descriptions. The core
    -- definitions are plain wrappers, so nothing behavioural is lost.
    local lsp_maps = {
      { "n", "grn", vim.lsp.buf.rename, "Rename symbol" },
      { { "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action" },
      { "n", "grr", vim.lsp.buf.references, "References" },
      { "n", "gri", vim.lsp.buf.implementation, "Implementation" },
      { "n", "grt", vim.lsp.buf.type_definition, "Type definition" },
      { "n", "grx", vim.lsp.codelens.run, "Run codelens" },
      { "n", "gO", vim.lsp.buf.document_symbol, "Document symbols" },
      { { "i", "s" }, "<C-S>", vim.lsp.buf.signature_help, "Signature help" },
    }
    for _, m in ipairs(lsp_maps) do
      vim.keymap.set(m[1], m[2], m[3], { desc = m[4] })
    end

    -- Only the gaps in that set are mapped below.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        vim.keymap.set(
          "n",
          "gd",
          vim.lsp.buf.definition,
          vim.tbl_extend("force", opts, { desc = "Go to definition" })
        )
        vim.keymap.set(
          "n",
          "gy",
          vim.lsp.buf.type_definition,
          vim.tbl_extend("force", opts, { desc = "Go to type definition" })
        )

        -- Same action as the built-in gra, under the leader namespace. Bound
        -- in visual mode too, so a selection can drive range code actions.
        vim.keymap.set(
          { "n", "x" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code action" })
        )
      end,
    })
  end,
}
