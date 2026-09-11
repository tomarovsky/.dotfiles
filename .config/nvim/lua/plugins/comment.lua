return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("Comment").setup({
            pre_hook = function()
                if vim.bo.commentstring == "" then
                    return "#%s"
                end
            end,
        })
    end,
}
