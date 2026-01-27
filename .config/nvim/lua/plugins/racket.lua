return {
  -- 1. Conjure: 让你在 Neovim 里通过 <localleader>ee 直接运行代码
  -- 它是目前 Neovim 下最好的 Lisp 交互插件
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python", "racket", "scheme" }, -- 开启 Racket 支持
    lazy = true,
  },

  -- 2. Parinfer: 自动管理括号（SICP 学习者的救星）
  -- 或者，如果你不想编译 Rust，可以使用纯 Lua 版本 nvim-parinfer
  { "gpanders/nvim-parinfer", ft = { "racket", "scheme" } },
}
