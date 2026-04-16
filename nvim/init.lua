vim.treesitter.language.register("yaml", "yaml.docker-compose")
vim.loader.enable()

-- options

local o = vim.opt
local g = vim.g

g.mapleader = " "
o.undofile = true
o.backup = false
o.confirm = true
o.iskeyword = "@,48-57,_,192-255,-"
o.termguicolors = true
o.cmdheight = 1
o.showcmd = false

-- o.winborder = 'rounded'
-- o.pumborder = 'rounded'
o.cursorline = true
o.number = true
o.relativenumber = true
o.signcolumn = "yes"

o.wrap = false

o.list = true
o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> ,trail:·"
o.fillchars = "eob: ,fold:┄,foldclose:,foldopen:"

o.laststatus = 0
o.ruler = false
o.showmode = false

o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"

o.scrolloff = 15

o.updatetime = 200
o.timeoutlen = 250
o.inccommand = "split"

o.expandtab = true
o.shiftwidth = 4
o.softtabstop = 4
o.tabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = true

o.foldmethod = "marker"
o.foldmarker = "{{{,}}}"
o.foldlevel = 0
o.foldlevelstart = 0

vim.schedule(function()
	o.clipboard = "unnamedplus"
end)

-- mappings

vim.keymap.set("n", "<C-c>", ":close<CR>", { desc = "[C]lose" })

vim.keymap.set("n", "H", ":bprev<CR>", { desc = "Prev buffer", noremap = false })
vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Next buffer", noremap = false })

vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

vim.keymap.set("i", "<C-u>", "<Esc>viwUea", { desc = "Turn into upper case" })
vim.keymap.set("i", "<C-t>", "<Esc>b~lea", { desc = "Turn into title case" })

vim.keymap.set("n", "|", "<C-w>v", { desc = "Split vertically" })
vim.keymap.set("n", "\\", "<C-w>s", { desc = "Split horizontally" })

vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })

vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set("n", "cc", '"_cc')
vim.keymap.set("x", "c", '"_c')

vim.keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Don't copy replaced text" })

vim.keymap.set("n", "gco", "o<esc>Vcx<esc>:normal gcc<CR>fxa<bs>", { desc = "Add comment below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc>:normal gcc<CR>fxa<bs>", { desc = "Add comment above" })

-- autocmd
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text, cycle numbered registers",
	group = vim.api.nvim_create_augroup("highlight_yanked_text", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 300 })
		-- yank ring
		-- credit: https://github.com/justinmk/config/blob/be345533e05db933baa587f901e08061de5579fa/.config/nvim/init.lua#L676
		if vim.v.event.operator == "y" then
			for i = 9, 1, -1 do -- Shift all numbered registers.
				vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
			end
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Restore cursor to last edit position",
	group = vim.api.nvim_create_augroup("restore_cursor_position", { clear = true }),
	callback = function(ev)
		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(ev.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	desc = "Syntax highlight for env files",
	group = vim.api.nvim_create_augroup("dotenv", { clear = true }),
	pattern = { ".env", ".env.*", ".secrets" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	desc = "No cusorline in INSERT or inactive",
	group = vim.api.nvim_create_augroup("CursorLineToggle", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	desc = "Cusorline when not in INSERT and active",
	group = "CursorLineToggle",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp.git", version = vim.version.range("*") },
	"https://github.com/stevearc/conform.nvim.git",
	"https://github.com/nvim-mini/mini.nvim.git",
	"https://github.com/nvim-treesitter/nvim-treesitter.git",
	"https://github.com/mason-org/mason.nvim.git",
	"https://github.com/smjonas/inc-rename.nvim.git",
	"https://github.com/j-hui/fidget.nvim.git",
	"https://github.com/folke/persistence.nvim.git",
	"https://github.com/lewis6991/gitsigns.nvim.git",
	"https://github.com/nvim-lualine/lualine.nvim.git",
	"https://github.com/brenoprata10/nvim-highlight-colors.git",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nyoom-engineering/oxocarbon.nvim",
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
		},
	},
	virtual_text = {
		virt_text_pos = "eol_right_align",
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		header = "",
	},
})

local servers = {
	"cssls",
	"lua_ls",
	"gopls",
	"docker_compose_language_service",
	"dockerls",
	"qmlls",
}

require("mini.icons").setup()
require("nvim-autopairs").setup({
	check_ts = true,
	enable_check_bracket_line = false,
})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})
require("lazydev").setup()
require("blink.cmp").setup({
	keymap = { preset = "default" },
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "gofumpt" },
		yaml = { "prettierd" },
	},
})
require("oxocarbon")
require("fidget").setup({
	notification = {
		override_vim_notify = true,
	},
})

-- nvim-treesitter
local ensure_installed_ts = {
	"c",
	"lua",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
	-- NOTE: the above are natively installed since neovim 0.12
	"bash",
	"diff",
	"dockerfile",
	"gitignore",
	"git_config",
	"luadoc",
	"regex",
	"toml",
	"yaml",
	"csv",
	"java",
	"python",
	"html",
	"css",
	"javascript",
	"typescript",
	"json",
	"go",
	"make",
	"sql",
	"qmljs",
	"qmldir",
}

local isnt_installed = function(lang)
	return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed_ts)
if #to_install > 0 then
	require("nvim-treesitter").install(to_install)
end

-- Ensure tree-sitter enabled after opening a file for target language
local filetypes = {}
for _, lang in ipairs(ensure_installed_ts) do
	for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
		table.insert(filetypes, ft)
	end
end
local ts_start = function(ev)
	vim.treesitter.start(ev.buf)
end

-- WARN: Do not use "*" here - snacks.nvim is buggy and vim.notify triggers FileType events internally causing infinite callback loops
vim.api.nvim_create_autocmd("FileType", {
	desc = "Start treesitter",
	group = vim.api.nvim_create_augroup("start_treesitter", { clear = true }),
	pattern = filetypes,
	callback = ts_start,
})

require("nvim-treesitter.config").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})
-- lualine

local colors = {
	blue = "#80a0ff",
	cyan = "#79dac8",
	black = "#080808",
	white = "#c6c6c6",
	red = "#ff5189",
	violet = "#d183e8",
	grey = "#303030",
}

local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white },
	},

	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}

require("lualine").setup({
	options = {
		theme = bubbles_theme,
		component_separators = "",
	},
	sections = {
		lualine_a = { { "mode" } },
		lualine_b = { "filename", "branch" },
		lualine_c = {
			"%=", --[[ add your center components here in place of this comment ]]
		},
		lualine_x = {},
		lualine_y = { "filetype", "progress" },
		lualine_z = {
			{ "location" },
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
})

vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Fix SQL indentation for nvim-autopairs",
	group = vim.api.nvim_create_augroup("fix_sql_indent", { clear = true }),
	pattern = "sql",
	callback = function()
		vim.bo.indentexpr = ""
		vim.bo.cindent = true

		vim.bo.cinoptions = "j1,(0,W4,m1"

		vim.bo.smartindent = false
	end,
})
