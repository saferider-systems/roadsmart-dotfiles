local M = {}

-- List LSP clients for current buffer (modern API)
local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local names = {}

    for _, client in ipairs(clients) do
        -- skip null-ls if installed
        if client.name ~= "null-ls" then
            table.insert(names, client.name)
        end
    end

    return " : " .. (#names > 0 and table.concat(names, ", ") or "none")
end

-- Formatters from Conform.nvim
-- local function conform_formatters()
--     local ok, conform = pcall(require, "conform")
--     if not ok then
--         return " : none"
--     end
--
--     local available = conform.list_formatters()
--     if not available or #available == 0 then
--         return " : none"
--     end
--
--     local names = {}
--     for _, f in ipairs(available) do
--         table.insert(names, f.name)
--     end
--
--     return " : " .. table.concat(names, ",")
-- end

-- Formatters from Conform.nvim + null-ls
local function all_formatters()
    local ft = vim.bo.filetype
    local formatters = {}

    -- -------------------------
    -- Conform formatters
    -- -------------------------
    local ok_conform, conform = pcall(require, "conform")
    if ok_conform then
        local available = conform.list_formatters()
        for _, f in ipairs(available or {}) do
            table.insert(formatters, f.name)
        end
    end

    -- -------------------------
    -- null-ls formatters
    -- -------------------------
    local ok_null_ls, null_ls = pcall(require, "null-ls")
    if ok_null_ls then
        local builtins = null_ls.builtins.formatting
        for name, formatter in pairs(builtins) do
            if formatter.filetypes and vim.tbl_contains(formatter.filetypes, ft) then
                table.insert(formatters, name)
            end
        end
    end

    -- Deduplicate
    local unique = {}
    local seen = {}
    for _, name in ipairs(formatters) do
        if not seen[name] then
            seen[name] = true
            table.insert(unique, name)
        end
    end

    if #unique == 0 then
        return " : none"
    end

    return " : " .. table.concat(unique, ", ")
end

-- Linters from nvim-lint
-- local function lint_linters()
--     local ok, lint = pcall(require, "lint")
--     if not ok then
--         return " : none"
--     end
--
--     local ft = vim.bo.filetype
--     local linters = lint.linters_by_ft[ft] or {}
--
--     if #linters == 0 then
--         return " : none"
--     end
--
--     return " : " .. table.concat(linters, ",")
-- end

-- Linters from nvim-lint and diagnostics from None-LS combined
local function all_linters()
    local ft = vim.bo.filetype
    local linters = {}

    -- Get linters from nvim-lint
    local ok_lint, lint = pcall(require, "lint")
    if ok_lint then
        local lint_list = lint.linters_by_ft[ft] or {}
        for _, linter in ipairs(lint_list) do
            table.insert(linters, linter)
        end
    end

    -- Get diagnostics from None-LS
    local ok_null_ls, null_ls = pcall(require, "null-ls")
    if ok_null_ls then
        -- Get available diagnostics for current filetype
        local diagnostics = null_ls.builtins.diagnostics
        for name, diagnostic in pairs(diagnostics) do
            -- Check if this diagnostic supports current filetype
            if diagnostic.filetypes and vim.tbl_contains(diagnostic.filetypes, ft) then
                table.insert(linters, name)
            end
        end
    end

    if #linters == 0 then
        return " : none"
    end
    return " : " .. table.concat(linters, ",")
end

-- Python environment detector
local function python_env()
    local ft = vim.bo.filetype
    if ft ~= "python" then
        return ""
    end

    -- Check for virtual environment
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        local env_name = venv:match("([^/]+)$")
        return " : " .. env_name
    end

    -- Check for conda environment
    local conda_env = os.getenv("CONDA_DEFAULT_ENV")
    if conda_env then
        return " : " .. conda_env
    end

    return " : system"
end

function M.setup()
    -- import your custom theme
    local custom_nightfly = require("themes.nightfly_custom")

    require("lualine").setup({
        options = {
            theme = custom_nightfly,
            icons_enabled = true,
            component_separators = { left = "", right = "│" },
            -- component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            -- section_separators = { left = "", right = "" },
        },

        sections = {
            lualine_a = {
                { "mode", icon = "" },
            },
            lualine_b = {
                { "branch", icon = "", color = { fg = "#32CD32" } },
                {
                    "diff",
                    colored = true,
                    symbols = { added = "+", modified = "~", removed = "-" },
                    diff_color = {
                        added = { fg = "#63f2f1", bg = "#011627" }, -- Cyan
                        modified = { fg = "#ffd900", bg = "#011627" }, -- Yellow
                        removed = { fg = "#fc514e", bg = "#011627" }, -- Red
                    },
                    "diagnostics",
                },
            },
            lualine_c = { { "filename", path = 0 } },

            -- 👇 Updated LSP + formatter + linter components
            lualine_x = {
                {
                    lsp_clients,
                    color = { fg = "#82aaff", bg = "#011627" }, -- Blue LSP
                },
                {
                    all_formatters,
                    color = { fg = "#63f2f1", bg = "#011627" }, -- Cyan Formatter
                },
                {
                    -- lint_linters,
                    all_linters,
                    color = { fg = "#ffd900", bg = "#011627" }, -- Yellow Linter
                },
                {
                    python_env,
                    color = { fg = "#c792ea", bg = "#011627" }, -- Purple Python env
                    cond = function()
                        return vim.bo.filetype == "python"
                    end,
                },
                "filetype",
            },
            lualine_y = { { "progress", separator = { left = "│", right = "" } } },
            lualine_z = { "location" },
        },
    })
end

return M
