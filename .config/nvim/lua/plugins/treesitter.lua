-- ensure these language parsers are installed
local ensure_installed = {
  "bash",
  "python",
  "snakemake",
  "r",
  "yaml",
  "json",
  "toml",
  "markdown",
  "markdown_inline",
  "dockerfile",
  "gitignore",
  "lua",
  "vim",
  "vimdoc",
}

-- incremental selection was dropped in nvim-treesitter `main`, so keep a
-- minimal implementation here: a per-buffer stack of the selected nodes
local stacks = {}

local function select_node(node)
  local srow, scol, erow, ecol = node:range()
  if ecol == 0 then
    erow = erow - 1
    ecol = #(vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or "")
  end
  vim.fn.setpos("'<", { 0, srow + 1, scol + 1, 0 })
  vim.fn.setpos("'>", { 0, erow + 1, ecol, 0 })
  vim.cmd("normal! gv")
end

local function init_selection()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  stacks[vim.api.nvim_get_current_buf()] = { node }
  select_node(node)
end

local function node_incremental()
  local stack = stacks[vim.api.nvim_get_current_buf()]
  if not stack or #stack == 0 then
    return init_selection()
  end

  local node = stack[#stack]
  local parent = node:parent()
  -- skip parents that cover exactly the same region
  while parent and vim.deep_equal({ node:range() }, { parent:range() }) do
    parent = parent:parent()
  end
  if not parent then
    return select_node(node)
  end

  table.insert(stack, parent)
  select_node(parent)
end

local function node_decremental()
  local stack = stacks[vim.api.nvim_get_current_buf()]
  if not stack or #stack < 2 then
    return
  end
  table.remove(stack)
  select_node(stack[#stack])
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").install(ensure_installed)
    require("nvim-ts-autotag").setup()

    -- enable syntax highlighting and indentation per buffer
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
          return
        end
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function(args)
        stacks[args.buf] = nil
      end,
    })

    vim.keymap.set("n", "<C-space>", init_selection, { desc = "Init selection" })
    vim.keymap.set("x", "<C-space>", node_incremental, { desc = "Increment selection" })
    vim.keymap.set("x", "<bs>", node_decremental, { desc = "Decrement selection" })
  end,
}
