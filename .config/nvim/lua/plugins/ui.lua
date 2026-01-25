return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
    },
  },

  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      term_colors = true,
      no_italic = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
      -- colorscheme = "tokyonight",
    },
  },

  { "akinsho/bufferline.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.section_separators = { left = "", right = "" }
    end,
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        backdrop = false,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },
      },
      explorer = {},
      indent = { enabled = false },
      terminal = {
        win = { wo = { winhighlight = "Normal:Normal,FloatBorder:Normal" } },
      },
      dashboard = {
        enabled = true,
        preset = {
          -- stylua: ignore
          header = 
[[
___ _____ _   _   _    ___ ___   ___  _    ___ ___ _  _
  / __|_   _/ \ | \ / |  | __/ _ \ / _ \| |  |_ _/ __| || |
  \__ \ | |/ _ \| |V| |  | _| (_) | (_) | |__ | |\__ \ __ |
  |___/ |_/_/ \_\_| |_|  |_| \___/ \___/|____|___|___/_||_|
]],
          --[[ 
           /\_/\
          ( o.o )
           > ^ <
          ]]
        },
        sections = {
          { section = "header", padding = 1, color = "SnacksPickerDir" }, -- 使用文件夹的蓝色
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },

    config = function(_, opts)
      require("snacks").setup(opts)

      -- Catppuccin Mocha 调色
      local colors = {
        text = "#cdd6f4", -- 柔和文本
        subtext = "#a6adc8", -- 次要文本
        blue = "#89b4fa", -- 蓝色
        mauve = "#cba6f7", -- 紫色

        -- 关键修改：使用 Surface1 而不是 Surface0
        -- Surface1 (#45475a) 比背景稍亮，对比度更清晰，但依然柔和
        selection_bg = "#45475a",
      }

      local overrides = {
        -- 1. 主体文字：保持柔和
        SnacksPicker = { bg = "NONE", fg = colors.text },
        SnacksPickerInput = { bg = "NONE", fg = colors.text, bold = true },

        -- 2. 搜索匹配字符：【核心修改】增加下划线
        -- 即使你分不清紫色和白色，下划线会直接告诉你匹配在哪里
        SnacksPickerMatch = { fg = colors.mauve, bold = true, underline = true },

        -- 3. 文件夹：保持加粗
        -- 通过"字很厚"来判断这是文件夹，而不是靠颜色
        SnacksPickerDir = { fg = colors.blue, bold = true },
        SnacksPickerFile = { fg = colors.text },

        -- 4. 选中行：【核心修改】
        -- bg: 使用对比度稍高的灰色，形成明显的"光带"
        -- bold: 选中行文字加粗，进一步强化视觉
        SnacksPickerListCursorLine = { bg = colors.selection_bg, fg = colors.text, bold = true },

        -- 5. 边框：保持原样，作为界限
        SnacksPickerBorder = { bg = "NONE", fg = colors.mauve },
        SnacksPickerPreviewBorder = { bg = "NONE", fg = colors.mauve },

        -- 6. 兜底设置
        SnacksNormal = { bg = "NONE" },
        SnacksPickerPreview = { bg = "NONE" },
        SnacksPickerList = { bg = "NONE" },
      }

      for group, styles in pairs(overrides) do
        if styles.bg == nil then
          styles.bg = "NONE"
        end
        styles.ctermbg = "NONE"
        vim.api.nvim_set_hl(0, group, styles)
      end
    end,
  },
}
