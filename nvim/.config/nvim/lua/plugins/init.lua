return {
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.none-ls")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- uncomment for format on save
        opts = require("configs.conform"),
    },
    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("configs.lspconfig")
        end,
    },
    {
        "folke/which-key.nvim",
        lazy = false,
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "NvChad/ui", -- load after nvchad ui
        },
        config = function()
            require("configs.lualine").setup()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        config = function(_, opts)
            local cmp = require("cmp")
            local mymappings = {
                ["<Up>"] = cmp.mapping.select_prev_item(),
                ["<Down>"] = cmp.mapping.select_next_item(),
                ["<C-Up>"] = cmp.mapping.scroll_docs(-4),
                ["<C-Down>"] = cmp.mapping.scroll_docs(4),
            }
            opts.mapping = vim.tbl_deep_extend("force", opts.mapping, mymappings)
            cmp.setup(opts)
        end,
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
        },
        ft = "python", -- Load when opening Python files
        keys = {
            { "<leader>v", "<cmd>VenvSelect<cr>", desc = "Select Python venv" }, -- Open picker on <leader>v
        },
        opts = { -- this can be an empty lua table - just showing below for clarity.
            search = {}, -- if you add your own searches, they go here.
            options = {}, -- if you add plugin options, they go here.
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 30,
                },
                renderer = {
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                        },
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true, -- Close tree after opening a file
                    },
                },
                filters = {
                    dotfiles = false,
                    custom = { "^.git$" }, -- Optional: still hide .git folder
                },
                view = {
                    width = 30,
                },
                filesystem_watchers = {
                    enable = true,
                    debounce_delay = 50,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
            })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    { -- This plugin
        "Zeioth/makeit.nvim",
        cmd = { "MakeitOpen", "MakeitToggleResults", "MakeitRedo" },
        dependencies = { "stevearc/overseer.nvim" },
        opts = {},
    },
    { -- The task runner we use
        "stevearc/overseer.nvim",
        commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
        cmd = { "MakeitOpen", "MakeitToggleResults", "MakeitRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
    },
    {
        "https://git.myzel394.app/Myzel394/config-lsp.nvim",
        opts = {
            executable = {
                path = nil, -- Change "nill" to "nil"
                args = {
                    "--no-undetectable-errors",
                },
                download_folder = vim.fn.stdpath("data") .. "/config-lsp/bin",
            },
            inject_lsp = false, -- Set to false since we're doing manual setup
            add_filetypes = true,
        },
    },
}
