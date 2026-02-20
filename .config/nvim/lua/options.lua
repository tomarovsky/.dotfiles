vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt
local api = vim.api
local keymap = vim.keymap

opt.buftype = ""
-- opt.mouse = ""
opt.relativenumber = false
opt.number = true

-- Russian language
vim.cmd("set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz")
keymap.set("i", "<C-с>", "<C-c>")

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.smarttab = true
opt.softtabstop = 4
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.confirm = true

opt.wrap = true

opt.scrolloff = 8 -- minimum number of lines to keep above and below the cursor
opt.sidescrolloff = 8 --minimum number of columns to keep above and below the cursor

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- opt.guicursor = ""
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- highlight on search
opt.hlsearch = true

-- save undo history
opt.undofile = true

-- turn off swapfile
opt.swapfile = false

-- disable status line
opt.laststatus = 0

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- -- backspace
-- opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
-- opt.ruler = true
--
-- folding
opt.foldmethod = "indent"
opt.foldlevel = 99
api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})
api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})

-- completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- decrease update time
opt.updatetime = 250

-- tab/space/indent settings for each filetype
api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" },
	{ pattern = "Snakefile,*.smk", command = "set filetype=snakemake" }
)
api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{ pattern = "*.py,*.smk", command = "match BadWhitespace /\\s\\+$/" }
)
