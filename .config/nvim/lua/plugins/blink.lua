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

        -- Accept on <C-i> instead of <C-y>.
        --
        -- Terminals send the same byte (0x09) for <C-i> and <Tab>, and only
        -- distinguish them with the kitty keyboard protocol. This tmux does
        -- not pass it through, so both keys land here -- which is why <Tab>
        -- is given the same command list rather than left on snippet_forward.
        -- Commands run in order until one succeeds: accept an open menu,
        -- otherwise jump a snippet, otherwise insert a literal tab.
        ["<C-i>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<C-y>"] = false,
      },

      appearance = { nerd_font_variant = "mono" },

      sources = { default = { "lsp", "path", "snippets", "buffer" } },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },

      -- Warn instead of silently degrading if the Rust matcher is unavailable.
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })

    -- blink does not register these itself. Servers must be told the client
    -- supports snippets, resolve, etc., or they send back thinner completions.
    -- This runs before mason-lspconfig enables anything, which is why the
    -- blink spec is ordered ahead of the LSP specs in init.lua.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
    })
  end,
}
