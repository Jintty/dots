-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.list = false

if vim.g.neovide then
  vim.g.neovide_opacity = 0.9
  vim.g.neovide_normal_opacity = 0.9
  vim.g.neovide_theme = "auto"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_fullscreen = true
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_title_background_color =
    string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

  vim.g.neovide_title_text_color = "pink"
end
