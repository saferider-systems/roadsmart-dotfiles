local palette = {
    bg = "#011627",
    fg = "#c3ccdc",
    blue = "#82aaff",
    green = "#63f2f1",
    purple = "#c792ea",
    red = "#fc514e",
    yellow = "#82aaff",
    dull_green = "#98c379",
}

return {
    normal = {
        a = { bg = palette.blue, fg = palette.bg, gui = "bold" },
        b = { bg = palette.bg, fg = palette.fg },
        c = { bg = palette.bg, fg = palette.fg },
    },
    insert = {
        a = { bg = palette.green, fg = palette.bg, gui = "bold" },
        b = { bg = palette.bg, fg = palette.fg },
        c = { bg = palette.bg, fg = palette.fg },
    },
    visual = {
        a = { bg = palette.purple, fg = palette.bg, gui = "bold" },
        b = { bg = palette.bg, fg = palette.fg },
        c = { bg = palette.bg, fg = palette.fg },
    },
    replace = {
        a = { bg = palette.red, fg = palette.bg, gui = "bold" },
        b = { bg = palette.bg, fg = palette.fg },
        c = { bg = palette.bg, fg = palette.fg },
    },
    command = {
        a = { bg = palette.yellow, fg = palette.bg, gui = "bold" },
        b = { bg = palette.bg, fg = palette.fg },
        c = { bg = palette.bg, fg = palette.fg },
    },
    inactive = {
        a = { bg = palette.bg, fg = palette.fg, gui = "bold" },
        b = { bg = palette.bg, fg = palette.fg },
        c = { bg = palette.bg, fg = palette.fg },
    },
    diff = {
        add = { bg = palette.bg, fg = "#63f2f1", gui = "bold" }, -- Cyan for added
        modified = { bg = palette.bg, fg = "#ffd900", gui = "bold" }, -- Yellow for modified
        remove = { bg = palette.bg, fg = "#fc514e", gui = "bold" }, -- Red for removed
    },
}
