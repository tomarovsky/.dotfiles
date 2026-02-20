return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local lualine = require "lualine"
    lualine.setup {
      options = {
        icons_enabled = false,
        component_separators = "|",
        section_separators = "",
      },
    }
  end,
}
