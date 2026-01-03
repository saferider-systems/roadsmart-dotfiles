local options = {
    formatters_by_ft = {
        css = { "prettierd" },
        -- dockerfile = { "dockerfmt" },
        -- hcl = { "terraform_fmt" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        lua = { "stylua" },
        -- make = { "mbake" },
        markdown = { "prettierd" },
        python = { "black" },
        scss = { "prettierd" },
        sh = { "shfmt" },
        -- terraform = { "terraform_fmt" },
        -- ["terraform-vars"] = { "terraform_fmt" },
        -- tex = { "tex-fmt" },
        -- tf = { "terraform_fmt" },
        yaml = { "yamlfmt" },
    },
    formatters = {
        black = {
            prepend_args = {
                "--fast",
                "--line-length",
                "150",
            },
        },
        -- dockerfmt = {
        --     command = "dockerfmt",
        --     prepend_args = {
        --         "-i",
        --         "4",
        --     },
        --     stdin = true,
        -- },
        -- mbake = {
        --     command = "mbake",
        --     args = { "format", "$FILENAME" },
        --     stdin = false,
        -- },
        shfmt = {
            prepend_args = {
                "-i",
                "2",
                "-bn",
                "-ci",
            },
        },
        -- ["tex-fmt"] = {
        --     prepend_args = {
        --         "--wraplen",
        --         "150",
        --         "--tabsize",
        --         "4",
        --     },
        --     stdin = true,
        -- },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 5000,
        lsp_fallback = false,
    },
}

return options
