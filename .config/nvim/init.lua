-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.fn.has("wsl") == 1 then
  local cwd = vim.fn.getcwd()
  if string.find(cwd, "^/mnt/") and vim.fn.argc() == 0 then
    vim.api.nvim_set_current_dir(os.getenv("HOME"))
  end
end
