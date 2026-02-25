return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = function()
      -- 纯 Lua blend：不依赖任何主题 util，避免 undefined 这类坑
      local function blend(fg, bg, alpha)
        local function hex_to_rgb(hex)
          hex = hex:gsub("#", "")
          return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
        end
        local function rgb_to_hex(r, g, b)
          return string.format("#%02x%02x%02x", r, g, b)
        end
        local fr, fg2, fb = hex_to_rgb(fg)
        local br, bg2, bb = hex_to_rgb(bg)
        local r = math.floor(fr * (1 - alpha) + br * alpha + 0.5)
        local g = math.floor(fg2 * (1 - alpha) + bg2 * alpha + 0.5)
        local b = math.floor(fb * (1 - alpha) + bb * alpha + 0.5)
        return rgb_to_hex(r, g, b)
      end

      return {
        -- 紫色壁纸：macchiato 通常更“紫得舒服”；想更深就改 mocha
        flavour = "mocha",
        transparent_background = true,
        term_colors = true,

        integrations = {
          treesitter = true,
          native_lsp = { enabled = true },
          telescope = true,
          cmp = true,
          gitsigns = true,
          which_key = true,
          notify = true,
          noice = true,
          mini = true,
        },

        custom_highlights = function(c)
          -- 注释：把 subtext0 往 text 方向推一点点
          -- 0.14 ~ 0.25 之间微调：数值越大越接近正文色（更清楚但更“显”）
          local comment_fg = blend(c.subtext0, c.text, 0.1)

          return {
            -- 透明兜底：有些 UI 组不完全吃 transparent_background
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            SignColumn = { bg = "NONE" },
            EndOfBuffer = { bg = "NONE" },

            NormalFloat = { bg = "NONE" },
            FloatBorder = { bg = "NONE" },

            StatusLine = { bg = "NONE" },
            StatusLineNC = { bg = "NONE" },
            WinBar = { bg = "NONE" },
            WinBarNC = { bg = "NONE" },
            -- CursorLine 更清晰（mocha 推荐）
            CursorLine = { bg = c.surface1 }, -- 不够就 surface1；觉得抢就换 surface0
            CursorLineNr = { fg = c.lavender, bold = true },

            Comment = { fg = comment_fg, italic = true },
            ["@comment"] = { fg = comment_fg, italic = true },
            ["@comment.documentation"] = { fg = comment_fg, italic = true },

            -- 色弱友好强化：形状线索 > 纯颜色
            Search = { bg = blend(c.yellow, c.base, 0.85), fg = c.text, underline = true },
            IncSearch = { bg = blend(c.peach, c.base, 0.82), fg = c.text, bold = true },

            DiagnosticUnderlineError = { undercurl = true, sp = c.peach },
            DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
            DiagnosticUnderlineInfo = { undercurl = true, sp = c.sky },
            DiagnosticUnderlineHint = { undercurl = true, sp = c.lavender },
          }
        end,
      }
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
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
          -- 保留两端 mode 色块，但让中间透明
          if mode.a then
            mode.a.gui = "bold"
          end
          if mode.z then
            mode.z.gui = "bold"
          end

          for _, part in ipairs({ "b", "c", "x", "y" }) do
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
        -- 强调匹配、目录、选中行
        vim.api.nvim_set_hl(0, "SnacksPickerMatch", { link = "Search", underline = true, bold = true })
        vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Directory", bold = true })
        vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { link = "CursorLine", bold = true })

        -- Snacks 透明：单独维护，不依赖主题的 transparent/floats 配置
        -- 组名可能随版本变化，宁可多列一点：没这个组也不会报错
        local groups = {
          "SnacksNormal",
          "SnacksWin",
          "SnacksBackdrop",

          "SnacksPicker",
          "SnacksPickerInput",
          "SnacksPickerList",
          "SnacksPickerPreview",

          "SnacksPickerBorder",
          "SnacksPickerInputBorder",
          "SnacksPickerListBorder",
          "SnacksPickerPreviewBorder",
          "SnacksPickerBoxBorder",

          "SnacksPickerTitle",
          "SnacksPickerFooter",
        }

        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end

        -- 边框也透明（有些主题会给 FloatBorder 上色，这里强行清掉）
        vim.api.nvim_set_hl(0, "SnacksPickerBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { bg = "NONE" })
      end

      set_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_highlights,
      })
    end,
  },
}
