vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/nvim-mini/mini.nvim",
    'https://github.com/nyoom-engineering/oxocarbon.nvim',
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
})

-- mini notify --
require("mini.notify").setup({
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

-- mini cmdline completion --
require("mini.cmdline").setup({
    autocorrent = { enable = false }
})

-- mini surround --
require("mini.surround").setup()

-- mini picker --
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")

MiniPick.setup()
MiniExtra.setup()

vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files() end)
vim.keymap.set("n", "<leader>fw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end)
vim.keymap.set("n", "<leader>fh", function() MiniPick.builtin.help() end)

vim.keymap.set("n", "<leader>fd", function() MiniExtra.pickers.diagnostic() end)
vim.keymap.set("n", "<leader>fk", function() MiniExtra.pickers.keymaps() end)


-- mini completions --
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true
    }
})

-- mini snippets --
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang()
    },
})
MiniSnippets.start_lsp_server({ match = false })


-- treesitter --
require("treesitter")

-- lsp --
require("lsp")

-- autopairs --
require("nvim-autopairs").setup()

-- yazi.nvim --
require("yazi").setup({
    open_for_directories = true
})

vim.keymap.set({ "n", "v" }, "<leader>fe", "<cmd>Yazi<cr>")
