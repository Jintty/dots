return {
  -- Config by gemini3pro
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help", "terminal" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,

      on_highlights = function(hl, c)
        -- 1. 修复 CursorLine (当前行)
        -- 之前用的 c.bg_highlight 在透明下太淡了
        -- 这里使用硬编码的 #2e3c64 (深靛蓝)，对比度更高，一眼就能找到光标
        hl.CursorLine = { bg = "#2e3c64" }

        -- 保持行号高亮，辅助定位
        hl.CursorLineNr = { fg = c.orange, bold = true }

        -- 2. 修复 Lualine 底部黑带
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }

        -- 3. 去除 WinBar 背景
        hl.WinBar = { bg = "NONE" }
        hl.WinBarNC = { bg = "NONE" }
        -- hl.Comment = { fg = "#9aa5ce", italic = true }
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  { "akinsho/bufferline.nvim", enabled = false },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.globalstatus = true

      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "->", right = "<-" }

      local function generate_transparent_theme()
        local theme = require("lualine.themes.auto")

        for _, mode in pairs(theme) do
          -- 保持两端模式指示器的颜色 (Normal=蓝, Insert=绿...)
          -- 但去掉了圆角和花哨的装饰，回归纯粹的矩形色块
          if mode.a then
            mode.a.gui = "bold"
          end
          if mode.z then
            mode.z.gui = "bold"
          end

          -- 中间区域透明化
          local parts = { "b", "c", "x", "y" }
          for _, part in ipairs(parts) do
            if mode[part] then
              mode[part].bg = "NONE"
            end
          end
        end
        return theme
      end

      opts.options.theme = generate_transparent_theme()
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        backdrop = false,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
      },
      explorer = {},
      indent = { enabled = false },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠿⢿⣶⡄⠀⠀⠀⠀⠀⢀⣴⣾⠿⢿⣶⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣰⣿⠏⠀⠀⠀⠻⣿⣆⠀⠀⠀⢠⣿⡟⠁⠀⠀⠙⣿⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣰⣿⠋⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠈⢿⣧⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣰⣿⠇⠀⠀⠀⠀⠀⠀⠀⢧⠿⣧⠿⣴⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⠀⠀⠀⠀
⢰⣿⣿⣿⣿⣧⣤⠀⠀⠀⢀⣀⠀⠀⠀⠀⣤⡀⠀⠀⠀⣀⡀⠀⠀⠀⣤⣼⣿⣿⣿⣿⡆
⢀⣤⣿⣿⣯⣭⣭⠀⠀⠀⢿⣿⡇⠀⢀⣤⣿⣧⡄⠀⢸⣿⣿⠀⠀⠀⣭⣭⣽⣿⣯⣤⡀
⠘⢻⣿⠏⠉⠉⠉⠀⠀⠀⠈⠉⠀⠀⠀⠉⠉⠉⠁⠀⠀⠉⠁⠀⠀⠀⠉⠉⠉⠙⣿⣿⠃
⢀⣿⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣿⡄
          ]],
        },
        sections = {
          { section = "header", padding = 1, color = "SnacksPickerDir" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },

    config = function(_, opts)
      require("snacks").setup(opts)

      local function set_highlights()
        vim.api.nvim_set_hl(0, "SnacksPickerMatch", { link = "Search", underline = true, bold = true })
        vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { link = "CursorLine", bold = true })
        vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Directory", bold = true })

        local groups = {
          "SnacksPicker",
          "SnacksPickerInput",
          "SnacksPickerBorder",
          "SnacksPickerPreview",
          "SnacksPickerList",
          "SnacksNormal",
          "SnacksPickerPreviewBorder",
        }
        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end
      end

      set_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_highlights,
      })
    end,
  },
}
