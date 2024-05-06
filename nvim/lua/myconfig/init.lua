-- MAPPINGS AND RC CONFS --

-- keymappings
local keymap = vim.keymap
local opts = { silent = true, noremap = true }

vim.g.mapleader = ' '

-- navigation keymaps
keymap.set("n", "<C-k>", "<C-w>k", opts, { desc = "Move to above window" })
keymap.set("n", "<C-j>", "<C-w>j", opts, { desc = "Move to below window" })
keymap.set("n", "<C-h>", "<C-w>h", opts, { desc = "Move to window to the left" })
keymap.set("n", "<C-l>", "<C-w>l", opts, { desc = "Move to window to the right" })
keymap.set("n", "<C-m>", ":Neotree toggle<CR>", opts, { desc = "Toggle fileTree" })

-- formatting keymaps
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts, { desc = "Move code snippet up" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts, { desc = "Move code snippet down" })
keymap.set("x", "<C-p>", "\"_dP", opts, { desc = "Don't lose a word when pasting" })

-- utils keymaps
keymap.set("n", "<leader>m", vim.cmd.make, opts, { desc = "Run make on curr dir" })
keymap.set("n", "<Leader>h", ":DocsViewToggle<CR>", opts, { desc = "Toggle documentation" })
keymap.set("n", "<leader>d", function() require("trouble").toggle() end, { desc = "Diagnostics (trouble)" })
keymap.set("n", "<leader>t", ":botright split | term<cr>i", { desc = "Open terminal below" })
keymap.set("v", "<leader>p", ":CodeSnapSave<cr>", { desc = "Print code to ~/codeSnapshots" })

-- genereal vim configs
vim.opt.nu = true            --			line numbers
vim.opt.tabstop = 4          --			tab
vim.opt.shiftwidth = 4       --		shift
vim.opt.smartindent = true   --	self-explanatory
vim.opt.swapfile = false     --		disable swapfiles
vim.opt.backup = false       --		dunno
vim.opt.termguicolors = true --	dunno
vim.opt.scrolloff = 8        --		ammount of lines before scroll
vim.opt.hlsearch = false     --		disable highlight for searches on all results
vim.opt.incsearch = true     --		will highlight while you write the search
vim.opt.updatetime = 50      --		dunno
vim.opt.colorcolumn = "80"   --	A colored column on column 80
vim.o.background = "dark"    --	dark mode

-- PLUGIN SECTION --

-- cecks if lazy.nvim is available. If not, installs it.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- add plugins here
local plugins = {
	{ -- gruvbox
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
	},
	{                 -- completion
		"hrsh7th/nvim-cmp", -- main utocomplete engine
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",    -- autocomplete for names in the file
			"hrsh7th/cmp-path",      -- autocomplete to filepath
			{
				"L3MON4D3/LuaSnip",  -- the main snippet window plugin
				dependencies = {
					"saadparwaiz1/cmp_luasnip", -- passes to autocomplete the things expanded from the selected snippet
					"rafamadriz/friendly-snippets", -- common snippets (for, func, main, etc)
				},
				build = (function()
					-- Build Step is needed for regex support in snippets
					-- This step is not supported in many windows environments
					-- Remove the below condition to re-enable on windows
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)()
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- loads vscode style snippets from installed plugins (e.g: friendly-snippets)
			require("luasnip.loaders.from_vscode").lazy_load()
			cmp.setup({
				snippet = { -- configure how nvim-cmp interacts with snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone,noinsert' },

				-- insert mappings here
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- prev. suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-p>"] = cmp.mapping.scroll_docs(-4),
					["<C-n>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion sugg
					["<C-e>"] = cmp.mapping.abort(),    -- abort completion
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm completion
					["<C-t>"] = function()
						if cmp.visible_docs() then
							cmp.close_docs()
						else
							cmp.open_docs()
						end
					end
				}),         -- toggle docs window
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- lsp
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" }, -- file system paths
				}),
			})
		end
	},
	{                        -- mason for lsp
		"williamboman/mason.nvim", -- lsp manager
		lazy = false,
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim", -- bridges the LSPs installed by mason and the nvim lsp
				lazy = false,
			},
			{
				"neovim/nvim-lspconfig", -- configuration of the native nvim lsp
				lazy = false,
				event = { "BufReadPre", "BufNewFile" },
				-- We don't have to setup each lsp server because of the
				-- autoconfig done in the mason configuration.
				-- If you have to mannualy set up a config for a server
				-- please refference the how to do so on Mason
			},
			"hrsh7th/cmp-nvim-lsp", -- bridges the LSP suggestions and the completion nvim-cmp
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			-- mason and mason-lspconfig have to be set in this order
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "->",
						package_uninstalled = "X",
					}
				},
			})
			-- add ensure installed LSPs here
			mason_lspconfig.setup({
				ensure_installed = {
					"clangd",
					"gopls",
					"lua_ls",
				},
				-- auto install configured servers
				automatic_installation = true,
			})

			-- lsp autoconfig.
			-- Because of this we don't have to set up all servers manually
			--
			-- takes the info from the lsp and feeds it to the nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			mason_lspconfig.setup_handlers({
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities
					})
				end,
				-- Next, you can provide a dedicated handler for
				-- specific servers. Like so for lua:
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" }
								}
							}
						}
					}
				end,
			}) -- lsp autoconfig
		end
	},
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
		opts = {
			position = "bottom",
			icons = true, -- set web-devicons
		},
		action_keys = { -- keymap inside trouble
			close = "q",
		},
	},
	{
		'stevearc/conform.nvim',
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters_by_ft = { -- add new formatters here
					c = { "clang-format" },
					h = { "clang-format" },
					cpp = { "clang-format" },
					hpp = { "clang-format" },
					ipp = { "clang-format" },
					tpp = { "clang-format" },
				}
			})
		end
	},
	{ -- which-Key, keymaps preview menu
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
		config = function()
			local wk = require("which-key")

			-- Which-Key keymappings
			wk.register({
				["<leader>m"] = { "Run makefile in curr dir" },
				["<leader><C-k>"] = { "Move to window above" },
				["<leader><C-j>"] = { "Move to window below" },
				["<leader><C-h>"] = { "Move to right window" },
				["<leader><C-l>"] = { "Move to left window" },
				["<leader><C-m>"] = { "Toogle file tree" },
				["<leader><C-p>"] = { "Paste without substituing buffer" },
				["<leader>h"] = { "open documentation" },
			})
			wk.setup()
		end,
	},
	{ -- docs toggle
		"amrbashir/nvim-docs-view",
		lazy = true,
		cmd = "DocsViewToggle",
		opts = {
			position = "bottom",
			width = 60
		},
		config = function()
			require("docs-view").setup({
				position = "bottom",
				update_mode = "auto",
				height = 10,
			})
		end
	},
	{ -- file tree navigator
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				mappings = {
					["s"] = "open_vsplit",
					["<cr>"] = "open",
					["q"] = "cancel"
				}
			})
		end
	},
	--[[
	{ -- tree navigator
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup()
		end
	},
	--]]
	{ -- pair ([{'" etc
		'echasnovski/mini.pairs',
		version = '*',
		config = function()
			require('mini.pairs').setup()
		end,
	},
	{ -- interactions with surrounding chars ('"[{ etc
		'echasnovski/mini.surround',
		version = '*',
		config = function()
			require('mini.surround').setup({
				mappings = {
					add = 'sa', -- Add surrounding in Normal and Visual modes
					delete = 'sd', -- Delete surrounding
					find = 'sf', -- Find surrounding (to the right)
					find_left = 'sF', -- Find surrounding (to the left)
					highlight = 'sh', -- Highlight surrounding
					replace = 'sr', -- Replace surrounding
					update_n_lines = 'sn', -- Update `n_lines`
				}
			})
		end,
	},
	{
		"mistricky/codesnap.nvim",
		build = "make",
		config = function()
			require("codesnap").setup({
				title = "",
				bg_color = "#535c68",
				watermark = "github.com/Grsaiago",
				code_font_family = "CaskaydiaCove Nerd Font",
				watermark_font_family = "CaskaydiaCove Nerd Font",
				save_path = "~/codeSnapshots/"
			})
		end

	}
}

-- add options for said plugins here
local opts = {}

-- START OF REQUIRE DIRECTIVES
require("lazy").setup(plugins, opts)

vim.cmd([[colorscheme gruvbox]]) --	gruvbox
