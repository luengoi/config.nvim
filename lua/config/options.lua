-- config.options
-- Neovim options, this options are loaded before the plugins.	

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.autoformat = true             -- enable format-on-save (when formatter available)
vim.g.linting = true                -- enable linting

local opt = vim.o

opt.cursorline = true               -- highlight line under cursor
opt.expandtab = true                -- expand tabs into spaces
opt.ignorecase = true               -- ignore case in patterns
opt.inccommand = "split"            -- show effects of certain commands incrementally
opt.list = true                     -- show blank characters (see listchars)
opt.listchars = table.concat({"tab:» ", "trail:·", "nbsp:␣"}, ",")
opt.mouse = ""                      -- disable mouse support
opt.mousescroll = "ver:0,hor:0"     -- disable mouse scrolling
opt.number = true                   -- show line numbers
opt.relativenumber = true           -- enable relative line number
opt.scrolloff = 15                  -- scroll offset
opt.sidescrolloff = 15                  -- scroll offset
opt.shiftwidth = 4
opt.showmode = false                -- don't show mode (will be shown in status line)
opt.signcolumn = "yes"              -- always show signcolumn
opt.smartcase = true                -- ignore case in patterns if pattern doesn't contain upper case
opt.softtabstop = 4
opt.splitright = true               -- vertical splits position new window on right
opt.splitbelow = true               -- horizontal splits position new window below
opt.tabstop = 4
opt.timeoutlen = 300                -- timeout to wait for a mapped sequence to end
opt.undofile = true                 -- save file's undo history
opt.updatetime = 250                -- timeout to save swap file to disk
opt.wrap = false                    -- disable line wrap
