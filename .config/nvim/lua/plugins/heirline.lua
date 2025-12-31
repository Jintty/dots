return {
  -- 1. 禁用 LazyVim 默认的 lualine
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },

  -- 2. 配置 Heirline
  {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "UiEnter",
    config = function()
      local heirline = require("heirline")
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      -- Catppuccin Mocha Palette
      local colors = {
        base = "#1e1e2e",
        mantle = "#181825",
        surface0 = "#313244",
        text = "#cdd6f4",
        subtext1 = "#bac2de",
        blue = "#89b4fa",
        red = "#f38ba8",
        green = "#a6e3a1",
        yellow = "#f9e2af",
        peach = "#fab387",
        mauve = "#cba6f7",
        sapphire = "#74c7ec",
        overlay0 = "#6c7086",
      }

      local function setup_colors()
        local final_colors = vim.deepcopy(colors)
        final_colors.bright_bg = colors.surface0
        final_colors.bright_fg = colors.text
        final_colors.diag_warn = colors.yellow
        final_colors.diag_error = colors.red
        final_colors.diag_hint = colors.sapphire
        final_colors.diag_info = colors.text
        final_colors.git_del = colors.red
        final_colors.git_add = colors.green
        final_colors.git_change = colors.yellow
        return final_colors
      end

      -- Niri 风格圆角字符
      local Sep = {
        left = "",
        right = "",
      }

      -- 辅助组件
      local Spacer = { provider = " " }
      local Align = { provider = "%=" }

      -- === 组件定义 === --

      -- 1. 模式显示 (Mode)
      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        static = {
          mode_names = {
            n = "NORMAL",
            no = "NORMAL",
            nov = "NORMAL",
            noV = "NORMAL",
            ["no\22"] = "NORMAL",
            niI = "NORMAL",
            niR = "NORMAL",
            niV = "NORMAL",
            nt = "NORMAL",
            v = "VISUAL",
            vs = "VISUAL",
            V = "V-LINE",
            Vs = "V-LINE",
            ["\22"] = "V-BLOCK",
            ["\22s"] = "V-BLOCK",
            s = "SELECT",
            S = "S-LINE",
            ["\19"] = "S-BLOCK",
            i = "INSERT",
            ic = "INSERT",
            ix = "INSERT",
            R = "REPLACE",
            Rc = "REPLACE",
            Rx = "REPLACE",
            Rv = "REPLACE",
            Rvc = "REPLACE",
            Rvx = "REPLACE",
            c = "COMMAND",
            cv = "EX",
            r = "ENTER",
            rm = "MORE",
            ["r?"] = "CONFIRM",
            ["!"] = "SHELL",
            t = "TERMINAL",
          },
          mode_colors = {
            n = "blue",
            i = "green",
            v = "mauve",
            V = "mauve",
            ["\22"] = "mauve",
            c = "peach",
            s = "mauve",
            S = "mauve",
            ["\19"] = "mauve",
            R = "red",
            r = "red",
            ["!"] = "red",
            t = "green",
          },
        },
        {
          provider = Sep.left,
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = self.mode_colors[mode], bg = "NONE" }
          end,
        },
        {
          provider = function(self)
            return "  " .. (self.mode_names[self.mode] or "UNK") .. " "
          end,
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = "base", bg = self.mode_colors[mode], bold = true }
          end,
        },
        {
          provider = Sep.right,
          hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = self.mode_colors[mode], bg = "NONE" }
          end,
        },
      }

      -- 2. Git 分支信息
      local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,
        {
          provider = Sep.left,
          hl = { fg = "surface0", bg = "NONE" },
        },
        {
          provider = function(self)
            return " " .. (self.status_dict.head or "") .. " "
          end,
          hl = { fg = "mauve", bg = "surface0", bold = true },
        },
        {
          provider = Sep.right,
          hl = { fg = "surface0", bg = "NONE" },
        },
      }

      -- 3. 文件名模块 (包含图标、文件名、修改标记)
      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          -- 获取图标和颜色
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color, bg = "surface0" }
        end,
      }

      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then
            return "[No Name]"
          end
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename .. " "
        end,
        hl = { fg = "text", bg = "surface0" },
      }

      local FileFlags = {
        condition = function()
          return vim.bo.modified
        end,
        provider = "● ",
        hl = { fg = "red", bg = "surface0" },
      }

      -- 修复点：FileNameMod 是一个容器，init 必须放在这里，
      -- 这样它的子组件 (FileIcon, FileName) 才能共享 self.filename
      local FileNameMod = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
        -- 左圆角
        {
          provider = Sep.left,
          hl = { fg = "surface0", bg = "NONE" },
        },
        -- 内容区域
        FileIcon,
        FileName,
        FileFlags,
        -- 右圆角
        {
          provider = Sep.right,
          hl = { fg = "surface0", bg = "NONE" },
        },
      }

      -- 4. 诊断信息
      local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          error_icon = " ",
          warn_icon = " ",
          info_icon = " ",
          hint_icon = " ",
        },
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        {
          provider = Sep.left,
          hl = { fg = "surface0", bg = "NONE" },
        },
        {
          provider = function(self)
            local parts = {}
            if self.errors > 0 then
              table.insert(parts, self.error_icon .. self.errors)
            end
            if self.warnings > 0 then
              table.insert(parts, self.warn_icon .. self.warnings)
            end
            if self.info > 0 then
              table.insert(parts, self.info_icon .. self.info)
            end
            if self.hints > 0 then
              table.insert(parts, self.hint_icon .. self.hints)
            end
            return " " .. table.concat(parts, " ") .. " "
          end,
          hl = { fg = "text", bg = "surface0" },
        },
        {
          provider = Sep.right,
          hl = { fg = "surface0", bg = "NONE" },
        },
      }

      -- 5. 坐标 (Ruler)
      local Ruler = {
        {
          provider = Sep.left,
          hl = { fg = "sapphire", bg = "NONE" },
        },
        {
          provider = " %7(%l/%3L%):%2c %P ",
          hl = { fg = "base", bg = "sapphire", bold = true },
        },
        {
          provider = Sep.right,
          hl = { fg = "sapphire", bg = "NONE" },
        },
      }

      local StatusLine = {
        ViMode,
        Spacer,
        Git,
        Spacer,
        Diagnostics,
        Align,
        FileNameMod,
        Align,
        Ruler,
      }

      heirline.setup({
        statusline = StatusLine,
        opts = {
          colors = setup_colors,
        },
      })
    end,
  },
}
