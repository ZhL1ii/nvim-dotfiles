local opt = vim.opt

-- 基本显示
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

-- 缩进
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- 分屏行为
opt.splitright = true
opt.splitbelow = true

-- 交互
opt.scrolloff = 12
opt.sidescrolloff = 30
opt.mouse = "a"
opt.clipboard = "unnamedplus"
