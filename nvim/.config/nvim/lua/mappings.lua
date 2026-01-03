require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Unset keymappings
nomap("n", "<Tab>")
nomap("n", "<S-Tab>")
nomap("n", "<leader>e")
nomap("n", "<leader>v")
nomap("n", "<C-n>")

-- Set new keymappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- Change mapping from Tab to Shift+l to go to next tab
map("n", "<S-l>", function()
    require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })
-- Change mapping from Shift+Tab to Shift+h to go to previous tab
map("n", "<S-h>", function()
    require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })
-- Change mapping to toggle NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
-- Add mapping to save and quit from file
map("n", "<leader>wq", "<cmd>wqall<CR>", { desc = "save and quit all" })
-- Add mapping to quit from file
map("n", "<leader>q", "<cmd>quitall<CR>", { desc = "quit all" })
-- Show formatters in this buffer
vim.keymap.set("n", "<leader>lf", function()
    print(table.concat(
        vim.tbl_map(function(f)
            return f.name
        end, require("conform").list_formatters()),
        ", "
    ))
end, { noremap = true, silent = false, desc = "Show formatters for current buffer" })
-- Show linters in this buffer
vim.keymap.set("n", "<leader>ll", function()
    print(table.concat(require("lint").linters_by_ft[vim.bo.filetype] or {}, ", "))
end, { noremap = true, silent = false, desc = "Show linters for current buffer" })
