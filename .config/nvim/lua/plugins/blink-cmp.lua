return {
  "Saghen/blink.cmp",
  opts = function(_, opts)
    -- 1. Explicitly clear presets to dictate exact tab scrolling actions
    opts.keymap = {
      preset = "none",

      -- Tab strictly moves the highlight down. If a snippet field is active and menu is closed, it jumps forward.
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      -- Shift-Tab strictly moves the highlight up.
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

      -- Lock in your selection using Enter
      ["<CR>"] = { "accept", "fallback" },

      -- Standard blink window helpers
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    }

    -- 2. Switch to manual selection mode so text doesn't swap until you press Enter
    opts.completion = {
      list = {
        selection = {
          preselect = false, -- Keeps the menu open without locking the first option instantly
          auto_insert = false, -- Disables the text autofilling side-effect while scrolling
        },
      },
    }

    return opts
  end,
}
