vim.g.mapleader = " "

local keymap = vim.keymap

-- -- clipboard
vim.opt.clipboard = "unnamedplus"
-- keymap.set({"n", "v", "x"}, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
-- keymap.set({"n"}, '<leader>yy', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })

-- folding with the spacebar
keymap.set("n", "<Space><Space>", "za")

-- tabs
keymap.set("n",    "<Tab>",         ">>",  { noremap = true, silent = true })
keymap.set("n",    "<S-Tab>",       "<<",  { noremap = true, silent = true })
keymap.set("v",    "<Tab>",         ">gv", { noremap = true, silent = true })
keymap.set("v",    "<S-Tab>",       "<gv", { noremap = true, silent = true })

-- keys for split navigation
keymap.set("n", "<C-J>", "<C-W><C-J>")
keymap.set("n", "<C-K>", "<C-W><C-K>")
keymap.set("n", "<C-L>", "<C-W><C-L>")
keymap.set("n", "<C-H>", "<C-W><C-H>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<S-l>", "<cmd>bn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<S-h>", "<cmd>bp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<C-S-x>", "<cmd>bd<CR>", { desc = "Close tab" })


-- auto formaters
keymap.set("n", "<leader>is", ":w | !snakefmt -l 150 %", { desc = "Apply Snakefmt" })
keymap.set("n", "<leader>ii", ":w | !isort --profile black %", { desc = "Apply isort" })
keymap.set("n", "<leader>ib", ":w | !black -l 150 %", { desc = "Apply black" })
keymap.set("n", "<leader>ir", ":w | !ruff format --line-length 150 %", { desc = "Apply ruff" })
