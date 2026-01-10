return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:BlinkCmpMenuSelection,Search:None",
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:BlinkCmpDocCursorLine,Search:None",
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = false,
        },
      },
    },
  },
}
