require("nvchad.options")

-- add yours here!

local o = vim.o

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- vim.diagnostic.config({
--     virtual_text = false,
--     virtual_lines = {
--         only_current_line = true, -- Only show diagnostics on the current line
--     },
-- })

vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- Custom symbol before message
        format = function(diagnostic)
            return diagnostic.message
        end,
    },
    -- virtual_lines = {
    --     current_line = true, -- Show on current line only
    --     only_current_line = true, -- Stricter: only show when line is current
    -- },
    signs = true, -- Show E/W icons in left gutter
    underline = true, -- Underline problematic code
    update_in_insert = false, -- Don't update diagnostics while typing
    severity_sort = true, -- Sort by severity (errors first)
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.textwidth = 72

        -- Create a custom highlight group
        vim.api.nvim_set_hl(0, "CommitOverflow", { fg = "#FF6B6B", bg = "NONE" })

        -- Highlight characters beyond column 72
        vim.cmd("match CommitOverflow /\\%>72v.\\+/")
    end,
})

vim.filetype.add({
    extension = {
        tf = "terraform",
        tfvars = "terraform-vars",
    },
})
