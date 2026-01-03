local lint = require("lint")

lint.linters_by_ft = {
    -- dockerfile = { "hadolint" },
    html = { "htmlhint" },
    javascript = { "eslint_d" },
    lua = { "luacheck" },
    -- make = { "checkmake" },
    markdown = { "proselint" },
    python = { "flake8" },
    sh = { "shellcheck" },
    scss = { "stylelint" },
    -- terraform = { "terraform_validate" },
    -- tex = { "vale" },
    -- tf = { "terraform_validate" },
}

lint.linters.luacheck.args = {
    unpack(lint.linters.luacheck.args),
    "--globals",
    "love",
    "vim",
}

-- lint.linters.hadolint.args = {
--     unpack(lint.linters.hadolint.args),
--     "--format=gcc",
--     "--failure-threshold=warning",
--     "--ignore=DL3008,DL3009", -- ignore specific rules
-- }

lint.linters.flake8.args = {
    unpack(lint.linters.flake8.args),
    "--max-line-length=150",
    "--ignore=E203,W503,E501",
    "--statistics",
}

lint.linters.shellcheck.args = {
    unpack(lint.linters.shellcheck.args),
    "--severity=style",
    "--enable=all",
}

-- Wrap terraform_validate to use terraform command
-- local original_tf_validate = lint.linters.terraform_validate
-- lint.linters.terraform_validate = function()
--     local linter_config = original_tf_validate()
--     linter_config.cmd = "terraform"
--     return linter_config
-- end

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--     callback = function()
--         lint.try_lint()
--     end,
-- })
