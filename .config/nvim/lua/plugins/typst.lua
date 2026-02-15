return {
  {
    "chomosuke/typst-preview.nvim",
    opts = {
      -- 这里是关键：强制使用 zen-browser 的新窗口模式打开
      -- %s 会自动被替换为预览地址 (http://127.0.0.1:xxxx)
      open_cmd = "zen --new-window %s",
    },
  },
}
