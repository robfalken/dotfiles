-- Completion. Pinned to the 1.x release line rather than the default branch:
-- blink downloads a prebuilt Rust fuzzy matcher for tagged releases, and only
-- falls back to building with cargo (or a slower pure-Lua matcher) otherwise.
return {
  src = "https://github.com/Saghen/blink.cmp",
  version = vim.version.range("1"),

  setup = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",

        -- <C-i> accepts instead of <C-y>, but it is mapped below, not here:
        -- blink compares keys after nvim_replace_termcodes(), where <C-i> and
        -- <Tab> are both "\t", so a <C-i> entry here silently overwrites the
        -- <Tab> one (or vice versa) and only a <Tab> mapping gets created.
        -- Commands run in order until one succeeds: accept an open menu,
        -- otherwise jump a snippet, otherwise insert a literal tab.
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<C-y>"] = false,
      },

      appearance = { nerd_font_variant = "mono" },

      sources = {
        -- lazydev ahead of lsp: it completes module names inside require(),
        -- which lua_ls cannot do for a plugin it has not loaded yet. The
        -- score offset keeps those above the buffer-word matches.
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },

      -- Warn instead of silently degrading if the Rust matcher is unavailable.
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })

    -- <C-i> is a separate key from <Tab> here: tmux (extended-keys on, with
    -- Ghostty's extkeys) sends it as CSI 27;5;105~ to panes that ask, and nvim
    -- does. Unlike <Tab> it has no fallback, so with nothing to accept it does
    -- nothing rather than inserting a tab.
    --
    -- The "blink.cmp: " desc prefix is load-bearing. <Tab>'s "fallback" runs
    -- the first mapping whose lhs termcodes to "\t" -- which includes <C-i> --
    -- unless its desc has that prefix. Without it <Tab> would fall back to
    -- this no-op instead of nvim's built-in <Tab>.
    vim.keymap.set("i", "<C-i>", function()
      local cmp = require("blink.cmp")
      if not cmp.select_and_accept() then cmp.snippet_forward() end
    end, { desc = "blink.cmp: Accept completion or jump snippet (never a tab)" })

    -- blink does not register these itself. Servers must be told the client
    -- supports snippets, resolve, etc., or they send back thinner completions.
    -- This runs before mason-lspconfig enables anything, which is why the
    -- blink spec is ordered ahead of the LSP specs in init.lua.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
    })
  end,
}
