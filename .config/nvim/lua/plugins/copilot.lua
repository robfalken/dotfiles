-- GitHub Copilot as inline ghost text. Deliberately *not* wired into the
-- blink menu: a Copilot completion is frequently several lines long, and a
-- menu row truncates it to the first one. Ghost text renders the whole thing
-- in place, which is the only way to judge a multi-line suggestion before
-- taking it. The trade-off is a second accept key (see keymap below) -- blink
-- keeps <Tab>/<C-i>, Copilot gets <C-l>.
return {
  src = "https://github.com/zbirenbaum/copilot.lua",

  setup = function()
    require("copilot").setup({
      -- The panel is the "show me ten alternatives in a split" UI. Off: it is
      -- a different workflow from inline suggestions, and leaving it enabled
      -- claims [[ and ]] (section motions) the moment it opens.
      panel = { enabled = false },

      suggestion = {
        enabled = true,

        -- Suggest without being asked. Off, every suggestion needs an
        -- explicit <M-\>, which defeats the point of ghost text.
        auto_trigger = true,

        -- Blank the ghost text while the blink menu is open. Both draw at the
        -- cursor, and without this the suggestion renders underneath the
        -- popup and shifts the lines below it as the menu filters.
        hide_during_completion = true,

        -- Upstream default is 15ms, which fires a request on very nearly
        -- every keystroke. 75ms is still under the round-trip time to the
        -- Copilot backend, so it costs no perceptible latency while cutting
        -- most of the in-flight requests that get cancelled a keystroke later.
        debounce = 75,

        -- Every key here is a plain ASCII control code or a CSI-u sequence,
        -- and none uses Alt. On macOS, Option only arrives as Alt when
        -- Ghostty's `macos-option-as-alt` is set, and it is not set in
        -- ~/.config/ghostty/config -- so upstream's <M-]>/<M-[> defaults for
        -- next/prev would be dead keys here. <C-.>/<C-,> instead: they reach
        -- nvim over the same extended-keys path that makes <C-i> distinct
        -- from <Tab> in the blink spec.
        keymap = {
          -- <C-l> is free in insert mode: the built-in <C-l> (redraw) is
          -- normal mode only.
          accept = "<C-l>",

          -- Take the suggestion one word at a time when only its opening is
          -- right. No accept_line: between a word and the whole suggestion
          -- there is not much left for a third key to do.
          accept_word = "<C-;>",
          accept_line = false,

          next = "<C-.>",
          prev = "<C-,>",

          -- Upstream default. Shadows insert-mode <C-]> (expand abbreviation)
          -- -- no loss unless this config grows :iabbrev entries.
          dismiss = "<C-]>",

          -- Bound in normal mode below instead; an insert-mode toggle is
          -- another key to lose track of mid-typing.
          toggle_auto_trigger = false,
        },
      },

      -- Which buffers Copilot attaches to. Upstream disables markdown and
      -- yaml wholesale; both are re-enabled here because prose and CI/compose
      -- files are exactly where the boilerplate is. The rest stay off: a
      -- commit message wants your own words, and `.` is the unnamed-filetype
      -- catch-all, which is where scratch and credential buffers land.
      filetypes = {
        markdown = true,
        yaml = true,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        help = false,
        ["."] = false,
      },

      -- server.type defaults to "binary": copilot.lua fetches a native
      -- copilot-language-server (~100MB, cached under stdpath("data")) rather
      -- than running the Node one. Left alone on purpose -- node v22 is
      -- installed and would work via type = "nodejs", but the binary keeps
      -- Copilot working across a node version bump.
    })

    local suggestion = require("copilot.suggestion")

    -- Silence the suggestion for the current session without unloading the
    -- plugin -- for pairing, screen-sharing, or any stretch where the ghost
    -- text is more distracting than useful. <C-l> still pulls one manually.
    -- With auto-trigger off, <C-.> is the way back to a suggestion: next()
    -- requests one when nothing is showing, so it doubles as the manual
    -- trigger and upstream's <M-\> needs no equivalent here.
    -- <leader>cp, not <leader>ca: the lspconfig spec binds <leader>ca to
    -- code_action per-buffer on LspAttach, and a buffer-local mapping beats a
    -- global one -- so a toggle there would be dead in every buffer with a
    -- language server, which is every buffer worth toggling it in.
    vim.keymap.set("n", "<leader>cp", suggestion.toggle_auto_trigger, {
      desc = "Toggle Copilot auto-suggestions",
    })
  end,
}
