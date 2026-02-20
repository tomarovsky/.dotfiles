return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      PATH = "append"
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "pyright",
        "bashls"
        -- "ruff_lsp"
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "isort", -- python formatter
        "black", -- python formatter
        "snakefmt", -- snakemake formatter
      },
    })
  end,
}
