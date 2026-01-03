local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require("nvchad.configs.lspconfig") -- nvim 0.11

-- List of all servers configured
lspconfig.servers = {
    "bashls",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "gopls",
    "html",
    "lua_ls",
    "marksman",
    "nginx_language_server",
    "pylsp",
    "terraformls",
    "texlab",
    "ts_ls",
    "yamlls",
}

-- List of servers configured with default config
local default_servers = {
    "cssls",
    "marksman",
    "nginx_language_server",
    "pylsp",
    "terraformls",
    "tflint",
    "texlab",
    "ts_ls",
}

-- LSPs with default config
for _, lsp in ipairs(default_servers) do
    vim.lsp.config(lsp, {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

vim.lsp.config("bashls", {
    on_attach = on_attach, -- your on_attach function
    on_init = on_init, -- your on_init function
    capabilities = capabilities, -- your capabilities
    filetypes = { "sh", "bash", "make" },
    settings = {
        bashIde = {
            backgroundAnalysisMaxFiles = 500,
            enableSourceErrorDiagnostics = false,
            explainshellEndpoint = "",
            globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)",
            includeAllWorkspaceSymbols = false,
            logLevel = "info",
            shellcheckArguments = "",
            shellcheckPath = "",
            shfmt = {
                binaryNextLine = false,
                caseIndent = false,
                funcNextLine = false,
                ignoreEditorconfig = false,
                keepPadding = false,
                languageDialect = "auto",
                path = "shfmt",
                simplifyCode = false,
                spaceRedirects = false,
            },
        },
    },
})

vim.lsp.config("denols", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    root_markers = { "deno.json", "deno.jsonc" },

    settings = {
        deno = {
            enable = true,
            lint = true,
            unstable = false, -- Set true if you use unstable APIs
            suggest = {
                completeFunctionCalls = true,
                imports = {
                    autoDiscover = true,
                },
            },
            codeLens = {
                implementations = true,
                references = true,
                referencesAllFunctions = true,
                test = true,
            },
            inlayHints = {
                enumMemberValues = true,
                functionLikeReturnTypes = true,
                parameterNames = true,
                parameterTypes = true,
                propertyDeclarationTypes = true,
                variableTypes = true,
            },
        },
    },
})

vim.lsp.config("docker_compose_language_service", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = { "yaml.docker-compose" },
    root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
})

vim.lsp.config("dockerls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        docker = {
            languageserver = {
                diagnostics = {
                    deprecatedMaintainer = "warning",
                    directiveCasing = "warning",
                    emptyContinuationLine = "warning",
                    instructionCasing = "warning",
                    instructionCmdMultiple = "warning",
                    instructionEntrypointMultiple = "warning",
                    instructionHealthcheckMultiple = "warning",
                    instructionJSONInSingleQuotes = "warning",
                },
                formatter = {
                    ignoreMultilineInstructions = false,
                },
            },
        },
    },
    filetypes = { "dockerfile" },
    root_markers = { "Dockerfile" },
})

vim.lsp.config("gopls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            },
        },
    },
})

vim.lsp.enable("gopls")

vim.lsp.config("html", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        html = {
            -- Auto-closing and quotes
            autoClosingTags = true,
            autoCreateQuotes = true,

            -- Completion
            completion = {
                attributeDefaultValue = "doublequotes",
            },

            -- Formatting (most important)
            format = {
                enable = true,
                contentUnformatted = "pre,code,textarea",
                extraLiners = "head, body, /html",
                indentHandlebars = false,
                indentInnerHtml = false,
                preserveNewLines = true,
                templating = false,
                unformatted = "wbr",
                unformattedContentDelimiter = "",
                wrapAttributes = "auto",
                wrapLineLength = 150,
            },

            -- Hover and suggestions
            hover = {
                documentation = true,
                references = true,
            },
            suggest = {
                html5 = true,
                hideEndTagSuggestions = false,
            },

            -- Validation
            validate = {
                scripts = true,
                styles = true,
            },

            -- Mirror cursor on matching tags
            mirrorCursorOnMatchingTag = true,
        },
    },
})

-- Lua LSP custom setup
vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

-- Python LSP (Pylsp) custom setup
-- vim.lsp.config("pylsp", {
--     on_attach = on_attach,
--     on_init = on_init,
--     capabilities = capabilities,
--     settings = {
--         pylsp = {
--             plugins = {
--                 jedi_completion = {
--                     enabled = true,
--                     fuzzy = true,
--                     eager = true,
--                 },
--                 pylsp_docs = {
--                     enabled = true,
--                     eager = true,
--                 },
--             },
--         },
--     },
-- })

-- Python LSP (Pyright) custom setup
-- vim.lsp.config("pyright", {
--     on_attach = on_attach,
--     on_init = on_init,
--     capabilities = capabilities,
--     settings = {
--         python = {
--             analysis = {
--                 autoImportCompletions = true,
--                 autoSearchPaths = true,
--                 typeCheckingMode = "strict",
--                 useLibraryCodeForTypes = true,
--             },
--         },
--     },
-- })

-- Terraform LSP (terraformls) custom setup
vim.lsp.config("terraformls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars", "tf", "tfvars" },
    root_markers = { ".terraform", ".git" },
})

vim.lsp.enable("terraformls")

-- Yaml LSP (Yamlls) custom setup
vim.lsp.config("yamlls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        yaml = {
            completion = true,
            disableAdditionalProperties = false,
            format = {
                enable = true,
                printWidth = 120,
                proseWrap = "preserve",
                singleQuote = false,
            },
            hover = true,
            maxItemsComputed = 5000,
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
                "https://raw.githubusercontent.com/compose-spec/compose-go/master/schema/compose-spec.json",
                "https://www.schemastore.org/hugo.json",
                "https://www.schemastore.org/hugo-theme.json",
            },
        },
    },
})

-- Python LSP (Ruff) custom setup
-- vim.lsp.config("ruff", {
--     on_attach = on_attach,
--     on_init = on_init,
--     capabilities = capabilities,
--     init_options = {
--         settings = {
--             lineLength = 50,
--             targetVersion = "py310",
--             select = { "E", "W", "F", "I" },
--             ignore = {},
--             fixAll = true,
--             showSyntaxErrors = true,
--         },
--     },
-- })
--
-- vim.lsp.enable("ruff")

-- Config LSP setup
local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

-- Register config_lsp if it doesn't exist
if not configs.config_lsp then
    configs.config_lsp = {
        default_config = {
            cmd = { "config-lsp", "--stdio", "--no-undetectable-errors" },
            filetypes = { "sshconfig", "sshdconfig", "fstab", "aliases", "conf", "gitconfig", "hosts", "wireguard" },
            root_dir = util.root_pattern(".git", vim.fn.getcwd()),
            single_file_support = true,
        },
    }
end

require("lspconfig").config_lsp.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
})
