return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {},
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },
      },
      indent = {
        enabled = false,
      },
      terminal = {
        win = {
          style = "float",
          border = "rounded",
          backdrop = 60,
          height = 0.9,
          width = 0.9,
          zindex = 50,
        },
      },
    },
  },
}
