return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
      },
      cmdline = {
        view = "cmdline",
      },
      lsp = {
        progress = {
          enabled = true,
        },
      },
      views = {
        notify = {
          backend = "notify",
          fallback = "mini",
          merge = true,
          replace = true,
        },
        hover = {
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "Normal",
            },
          },
        },
      },
    },
  },
}
