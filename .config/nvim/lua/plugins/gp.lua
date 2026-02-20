return {
  'robitx/gp.nvim',
  config = function()
    local conf = {
      providers = {
        openai = {disable = true},
        googleai = {
          disable = false,
          secret = os.getenv("GEMINI_API_KEY"),
          endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:streamGenerateContent?key={{secret}}',
        },
      },
    }
    require('gp').setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}



