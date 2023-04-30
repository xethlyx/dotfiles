" ---------------------------------------
" Vim Configuration
" ---------------------------------------

" {{{ Plugins
call plug#begin()

if has('nvim')
	" Dependencies
	Plug 'nvim-lua/plenary.nvim'

	" LSP Stuff
	Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'jose-elias-alvarez/null-ls.nvim'
	Plug 'jay-babu/mason-null-ls.nvim'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'onsails/lspkind.nvim'
	Plug 'xethlyx/luau-lsp.nvim'

	" Lualine
	Plug 'nvim-lua/lsp-status.nvim'
	Plug 'nvim-lualine/lualine.nvim'

	Plug 'rcarriga/nvim-notify'
	Plug 'MunifTanjim/nui.nvim'
	Plug 'folke/noice.nvim'
	
	" Other stuff
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/playground'
	Plug 'nmac427/guess-indent.nvim'
	Plug 'windwp/nvim-autopairs'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'lewis6991/gitsigns.nvim'

	Plug 'kevinhwang91/promise-async'
	Plug 'kevinhwang91/nvim-ufo'

	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
	Plug 'Wansmer/treesj'
	Plug 'rust-lang/rust.vim'
endif

if !has('nvim')
	Plug 'itchyny/lightline.vim'
endif

Plug 'moll/vim-bbye'
Plug 'tyrannicaltoucan/vim-deep-space', {'as': 'vim-deep-space'}
Plug 'tpope/vim-commentary' " gc to comment selection, gcc to comment current line
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

call plug#end()
" }}}

" {{{ Patches
" Fix alt keys in Windows Terminal, but only if not in nvim because it doesn't
" respect this
if !has('nvim')
	let c='a'
	while c <= 'z'
		exec "set <A-".c.">=\e".c
		exec "imap \e".c." <A-".c.">"
		let c = nr2char(1+char2nr(c))
	endw

	" Note that sometimes syntax highlighting breaks in files with multiline
	" comments. Can be fixed using :syn sync fromstart. Doesn't occur with
	" treesitter.
	autocmd BufEnter :syn sync fromstart
endif

if has('mouse')
	if &term =~ 'xterm'
		set mouse=a
	else
		set mouse=nvi
	endif
endif

autocmd FileType luau setlocal commentstring=--\ %s
autocmd FileType c setlocal commentstring=//\ %s

" }}}

" {{{ Functions

function! TermExec(cmd)
	let b:term_insert = 1
	execute a:cmd
endfunction

function! HostnameMatches(hostname)
	return match(hostname(), a:hostname) >= 0
endfunction

" }}}

" {{{ Basic Configuration
set cursorline
set shiftwidth=4
set tabstop=4
set scrolloff=5
set ignorecase
set smartcase
set showcmd
set hlsearch
set background=dark
set termguicolors
set backspace=indent,eol,start
set history=200
set ruler
set wildmenu
set display=truncate
set noexpandtab
set autoindent
set smarttab
set belloff=cursor,backspace

set updatetime=300
set signcolumn=yes

set number
set noshowmode
set rnu
set laststatus=2

set ttimeout
set ttimeoutlen=25

set foldnestmax=1
set foldminlines=1
set backupcopy=yes

" Hide ./ directory in :E
" For some reason this shows?
let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 75
let g:netrw_preview = 1

augroup netrw_setup | au!
	au FileType netrw nmap <buffer> l <CR>
augroup END

" }}}

" {{{ Basic Keybindings

inoremap <C-U> <C-G>u<C-U>
nnoremap <silent><C-L> :let @/ = ""<CR><C-L>

nnoremap <silent><A-j> :m .+1<CR>==
nnoremap <silent><A-k> :m .-2<CR>==
inoremap <silent><A-j> <Esc>:m .+1<CR>==gi
inoremap <silent><A-k> <Esc>:m .-2<CR>==gi
vnoremap <silent><A-j> :m '>+1<CR>gv=gv
vnoremap <silent><A-k> :m '<-2<CR>gv=gv

imap <c-j> <down>
imap <c-k> <up>

nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

nmap <leader>l :set invlist<cr>

nnoremap <silent><leader>t :below split +term<cr>
nnoremap <silent><leader>T :tabnew +term<cr>
nnoremap <F3> :below split +term<cr>
nnoremap <S-F3> :tabnew +term<cr>

" Remapped caps lock keybindings

function! RegisterGlobalKeybind(input, neovideInput, action, terminalAction)
	let l:keymap = exists('g:neovide') ? '<A-S-' . a:neovideInput . '>' : '<A-' . a:input . '>'

	execute 'nnoremap' l:keymap a:action
	execute 'inoremap' l:keymap '<Esc>' . a:action
	execute 'vnoremap' l:keymap a:action

	if has('nvim')
		execute 'tnoremap' '<silent>' . l:keymap '<cmd> call TermExec(''' a:terminalAction ''')<CR>'
	endif
endfunction

call RegisterGlobalKeybind('Left', 'h', '<C-W>h', 'wincmd h')
call RegisterGlobalKeybind('Down', 'j', '<C-W>j', 'wincmd j')
call RegisterGlobalKeybind('Up', 'k', '<C-W>k', 'wincmd k')
call RegisterGlobalKeybind('Right', 'l', '<C-W>l', 'wincmd l')
call RegisterGlobalKeybind('i', 'i', 'gT', 'tabN')
call RegisterGlobalKeybind('o', 'o', 'gt', 'tabn')
call RegisterGlobalKeybind('u', 'u', '<C-W>q', 'bd!')

" }}}

" {{{ Appearance

colorscheme deep-space

let g:coc_default_semantic_highlight_groups = 1
" there's room for improvement..
highlight! link CocSemVariable Identifier
highlight! link CocSemParameter Identifier
highlight! link CocSemProperty Identifier
highlight! link CocSemClass Type
highlight! link CocSemInterface Type
highlight! link CocSemType Type
highlight! link Special Keyword

highlight! link typescriptVariable Keyword
highlight! link typescriptInterfaceName Type
highlight! link typescriptObjectLabel Identifier
highlight! link typescriptMember Identifier

highlight! link Conceal Comment

if has('nvim')
	highlight! link NvimTreeSpecialFile Operator
	highlight! link NvimTreeGitNew SignifySignAdd
	highlight! link NvimTreeGitDirty SignifySignChange
	highlight! link NvimTreeGitDeleted SignifySignDelete

	highlight! link @type.qualifier Keyword
	highlight! link @include Keyword
	highlight! link @namespace Type
	highlight! link @variable.builtin Keyword
endif

highlight! link DiffAdd SignifySignAdd
highlight! link DiffChange SignifySignChange
highlight! link DiffDelete SignifySignDelete

set list listchars=tab:\ \ ,trail:·,extends:»,precedes:«,nbsp:×
" set list listchars=tab:→\⠀,trail:·,extends:»,precedes:«,nbsp:×

set fillchars+=vert:\ ,fold:\ 
hi! link VertSplit CursorLine
hi! link netrwTreeBar Comment
hi! EndOfBuffer guifg=bg

hi! link TelescopeBorder @keyword

" }}}

" {{{ Utility commands

command! WhichHi call SynStack()
command! WhichHighlight call SynStack()

command! VC e ~/dotfiles/etc/.vimrc
command! VimConfig e ~/dotfiles/etc/.vimrc

" Call using :call SynStack()
function! SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

augroup netrw_setup | au!
	au FileType vim set foldmethod=marker
augroup END

" }}}

" ---------------------------------------
" Plugin Configuration
" ---------------------------------------

" {{{ Lightline

let g:lightline = {
	\ 'colorscheme': 'deepspace',
	\ 'active': {
	\   'left': [
	\	   [ 'mode', 'paste' ],
	\	   [ 'cocstatus', 'readonly', 'filename' ],
	\	   [ 'coc_error', 'coc_warn' ],
	\	   [ 'git_info' ],
	\   ],
	\   'right':[
	\	   [ 'percent' ],
	\	   [ 'lineinfo' ],
	\	   [ 'filetype', 'fileencoding', 'indent'],
	\	   [ 'blame' ],
	\   ],
	\ },
	\ 'inactive': {
	\   'left': [
	\	   [ 'mode', 'paste' ],
	\	   [ 'readonly', 'filename' ],
	\	   [ 'coc_status' ],
	\   ],
	\   'right': [
	\	   [ 'percent' ],
	\	   [ 'lineinfo' ],
	\	   [ 'filetype', 'fileencoding'],
	\   ]
	\ },
	\ 'component_expand': {
	\   'coc_error': 'LightlineCocError',
	\   'coc_warn': 'LightlineCocWarn',
	\ },
	\ 'component_function': {
	\   'filename': 'LightlineFileName',
	\   'blame': 'LightlineGitBlame',
	\   'git_info': 'LightlineGitInfo',
	\   'indent': 'LightlineIndent',
	\   'cocstatus': 'LightlineCocMsg',
	\ },
	\ 'component_type': {
	\   'coc_error': 'error',
	\   'coc_warn': 'warning',
	\ }
	\ }

function! LightlineCocError()
	let info = get(b:, 'coc_diagnostic_info', {})
	if empty(info) | return '' | endif
	if get(info, 'error', 0)
		return info['error'] . 'E'
	endif
	return ''
endfunction

function! LightlineCocWarn()
	let info = get(b:, 'coc_diagnostic_info', {})
	if empty(info) | return '' | endif
	if get(info, 'warning', 0)
		return info['warning'] . 'W'
	endif
	return ''
endfunction

function! LightlineFileName()
	let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
	let modified = &modified ? '*' : ''
	return filename . modified
endfunction

function! LightlineIndent()
	let tabtype =  &expandtab ? 'spaces' : 'tabs'
	return tabtype . ': ' . &tabstop
endfunction

function! LightlineGitInfo()
	return get(g:, 'coc_git_status', '') . get(b:, 'coc_git_status', '')
endfunction

function! LightlineGitBlame()
	let blame = get(b:, 'coc_git_blame', '')
	return blame
endfunction

function! LightlineCocMsg()
	return get(g:, 'coc_status', '')
endfunction

" }}}

" {{{ LSP

if has('nvim')
	hi! CocErrorSign guifg=#b15e7c
	hi! CocInfoSign guifg=#51617d
	hi! CocWarningSign guifg=#b5a262
	hi! DiagnosticUnderlineError guisp=#b15e7c gui=underline,nocombine
	hi! DiagnosticUnderlineWarn guisp=#b5a262 gui=underline,nocombine
	hi! DiagnosticUnderlineInfo guisp=#51617d gui=underdashed
	hi! link DiagnosticUnderlineHint DiagnosticUnderlineInfo
	hi! link CocInlayHint Comment
	hi! link DiagnosticError CocErrorSign
	hi! link DiagnosticWarn CocWarningSign
	hi! link DiagnosticInfo CocInfoSign
	hi! link DiagnosticHint CocInfoSign
	hi! link NormalFloat Normal
	hi! link FloatBorder Keyword

	command! Format lua vim.lsp.buf.format()
	nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>
	nnoremap <silent> <leader>al <cmd>lua vim.lsp.buf.code_action()<CR>
	nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
	nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
	" nnoremap <silent> gp <cmd>Lspsaga peek_definition<CR>
	nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
	" nnoremap <silent> [e <cmd>Lspsaga diagnostic_jump_prev<CR>
	" nnoremap <silent> ]e <cmd>Lspsaga diagnostic_jump_next<CR>
	" nnoremap <silent> <leader>o <cmd>Lspsaga outline<CR>
	autocmd CursorHold * lua vim.diagnostic.open_float({scope="line",border="rounded",source=true,prefix=" • "})

lua << LSP
	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or rounded
		return orig_util_open_floating_preview(contents, syntax, opts, ...)
	end

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {},
		-- root_dir = function() return vim.loop.cwd() end,
		automatic_installation = true,
	})
    require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function (server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {}
        end,
		["luau_lsp"] = function(server_name)
			require("luau-lsp").setup({
				sourcemap = {
					enable = true, -- enable sourcemap generation
					autogenerate = true, -- auto generate sourcemap when saving/deleting buffers
				},
				server = {
					types = {
						roblox = true, -- enable roblox api
					},
				},
			})
		end,
    }
	require("mason-null-ls").setup({
	})

	local cmp = require("cmp")
	local lspkind = require("lspkind")

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			-- ['<tab>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			-- ['<tab>'] = cmp.mapping(cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }), { 'i', 'c' }),
			['<tab>'] = cmp.mapping.select_next_item(),
			['<S-tab>'] = cmp.mapping.select_prev_item(),
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' }, -- For vsnip users.
			-- { name = 'luasnip' }, -- For luasnip users.
			-- { name = 'ultisnips' }, -- For ultisnips users.
			-- { name = 'snippy' }, -- For snippy users.
		}, {
			{ name = 'buffer' },
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol', -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				before = function (entry, vim_item)
					return vim_item
				end
			})
		},
		completion = {
			completeopt = 'menu,menuone,preview,noselect'
		},
	})

	-- Set configuration for specific filetype.
	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
			{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
			{ name = 'buffer' },
		})
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})

	local lspconfig = require("lspconfig")

	local null_ls = require("null-ls")

	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua
		}
	})

	-- require("lspsaga").setup({
	-- 	symbol_in_winbar = { enable = false },
	-- 	lightbulb = { enable = false },
	-- 	code_action = { keys = { quit = "<esc>" } },
	-- 	rename = { quit = "<esc>" },
	-- 	ui = {
	-- 		-- This option only works in Neovim 0.9
	-- 		title = true,
	-- 		-- Border type can be single, double, rounded, solid, shadow.
	-- 		border = "single",
	-- 		winblend = 0,
	-- 		expand = "",
	-- 		collapse = "",
	-- 		code_action = "💡",
	-- 		incoming = " ",
	-- 		outgoing = " ",
	-- 		hover = ' ',
	-- 		kind = {},
	-- 	},
	-- })
LSP
endif

" }}}

" ---------------------------------------
" Neovim Configuration
" ---------------------------------------

if has('nvim')

	" {{{ Patches

	" Fix command line in MSYS terminal by escaping slashes \
	if !empty($MSYSTEM_PREFIX)
		let &shell = substitute(&shell, '\\\+', '/', 'g')
	endif

	" Custom luau highlight
	lua require("nvim-treesitter.parsers").get_parser_configs().luau = { install_info = { url = "https://github.com/polychromatist/tree-sitter-luau.git", branch = "main", files = { "src/parser.c", "src/scanner.c" }, requires_generate_from_grammar = false }, filetype = "luau" }

	" Use luau highlight for lua files because it behaves better..
	augroup useLuauSyntax
		autocmd!
		autocmd FileType lua set filetype=luau
	augroup END

	augroup luauFolds
		autocmd!
		autocmd FileType luau setlocal foldmethod=expr
		autocmd FileType luau setlocal foldexpr=nvim_treesitter#foldexpr()
		autocmd BufReadPost,FileReadPost *.lua normal zR
	augroup END
	" }}}

	" {{{ nvim-tree
	let g:loaded_netrw = 0
	let g:loaded_netrwPlugin = 1
	lua require("nvim-tree").setup({ renderer = { icons = { glyphs = { git = { unstaged = "⬤", staged = "⬤", untracked = "⬤", deleted = "⬤", renamed = "⬤", unmerged = "⬤" } } } }, filesystem_watchers = { ignore_dirs = { "target" } } })
	" }}}

	" {{{ Neovim Terminal Changes

	function! s:TermEnter(_)
		if getbufvar(bufnr(), 'term_insert', 0)
			startinsert
			call setbufvar(bufnr(), 'term_insert', 0)
		endif
	endfunction

	" Make terminal behave more like vim terminal
	augroup Term
		autocmd CmdlineLeave,WinEnter,BufWinEnter * call timer_start(0, function('s:TermEnter'), {})
	augroup end

	autocmd TermOpen * startinsert
	autocmd TermOpen * let b:term_job_finished = 0
	autocmd TermOpen * setlocal nonumber norelativenumber
	autocmd TermEnter * if  b:term_job_finished | call feedkeys("\<C-\>\<C-n>") | endif
	autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
	" tnoremap <silent> <C-W>. <C-W>
	" tnoremap <silent> <C-W><C-.> <C-W>
	" tnoremap <silent> <C-W><C-\> <C-\>
	" tnoremap <silent> <C-W>N <C-\><C-N>
	" tnoremap <silent> <C-W>: <C-\><C-N>:call TermExec('call feedkeys(":")')<CR>
	" tnoremap <silent> <C-W><C-W> <cmd>call TermExec('wincmd w')<CR>
	" tnoremap <silent> <C-W>h <cmd>call TermExec('wincmd h')<CR>
	" tnoremap <silent> <C-W>j <cmd>call TermExec('wincmd j')<CR>
	" tnoremap <silent> <C-W>k <cmd>call TermExec('wincmd k')<CR>
	" tnoremap <silent> <C-W>l <cmd>call TermExec('wincmd l')<CR>
	" tnoremap <silent> <C-W><C-H> <cmd>call TermExec('wincmd h')<CR>
	" tnoremap <silent> <C-W><C-J> <cmd>call TermExec('wincmd j')<CR>
	" tnoremap <silent> <C-W><C-K> <cmd>call TermExec('wincmd k')<CR>
	" tnoremap <silent> <C-W><C-L> <cmd>call TermExec('wincmd l')<CR>
	" tnoremap <silent> <C-W>gt <cmd>call TermExec('tabn')<CR>
	" tnoremap <silent> <C-W>1gt <cmd>call TermExec('tabn 1')<CR>
	" tnoremap <silent> <C-W>2gt <cmd>call TermExec('tabn 2')<CR>
	" tnoremap <silent> <C-W>3gt <cmd>call TermExec('tabn 3')<CR>
	" tnoremap <silent> <C-W>4gt <cmd>call TermExec('tabn 4')<CR>
	" tnoremap <silent> <C-W>5gt <cmd>call TermExec('tabn 5')<CR>
	" tnoremap <silent> <C-W>6gt <cmd>call TermExec('tabn 6')<CR>
	" tnoremap <silent> <C-W>7gt <cmd>call TermExec('tabn 7')<CR>
	" tnoremap <silent> <C-W>8gt <cmd>call TermExec('tabn 8')<CR>
	" tnoremap <silent> <C-W>9gt <cmd>call TermExec('tabn 9')<CR>
	" tnoremap <silent> <C-W>T <cmd>call TermExec('wincmd T')<CR>
	" tnoremap <silent> <C-W>q <cmd>call TermExec('wincmd q')<CR>
	" }}}

	" {{{ Telescope
	nnoremap <silent> <C-p> <cmd>Telescope find_files<cr>
	nnoremap <silent> <leader>ff <cmd>Telescope find_files<cr>
	nnoremap <silent> <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <silent> <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <silent> <leader>fh <cmd>Telescope help_tags<cr>

	lua require("telescope").setup({ defaults = { file_ignore_patterns = { ".git\\", ".git/", "node_modules\\", "node_modules/" }, mappings = { i = { ["<esc>"] = require("telescope.actions").close, ["<c-d>"] = require('telescope.actions').delete_buffer } } } })
	" }}}

	" {{{ Misc. Plugins
	" Setup autopairs
	lua << AUTOPAIRS
		npairs = require("nvim-autopairs")
		endwise = require("nvim-autopairs.ts-rule").endwise

		npairs.setup({})
		npairs.add_rules({
			-- endwise("then$", "end", "luau", "if_statement"),
			-- endwise("function.*%(.*%)$", "end", "luau", {"function_declaration", "local_function", "function"})
			endwise("then$", "end", "luau", nil),
			endwise("do$", "end", "luau", nil),
			endwise("function.*%(.*%)$", "end", "luau", nil)
		})
AUTOPAIRS

	" Setup Treesitter
	lua require('nvim-treesitter.configs').setup({ highlight = { enable = true }, indent = { enable = true }, rainbow = { enable = true, extended_mode = true, colors = { "#9b59b6", "#3498db", "#2ecc71" } } })

	lua require('guess-indent').setup()

	lua require('colorizer').setup()

	lua require('treesj').setup({})

	set foldcolumn=0
	set foldlevel=99
	set foldlevelstart=99

	nnoremap <silent> zR :lua require("ufo").openAllFolds()<cr>
	nnoremap <silent> zM :lua require("ufo").closeAllFolds()<cr>

	lua << UFO
		local function handler(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = ('  %d '):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, {chunkText, hlGroup})
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, {suffix, 'Folded'})
			return newVirtText
		end

		local function providerSelector(bufnr, filetype, buftype)
			return { 'tree-sitter', 'indent' }
		end

		require('ufo').setup({ providerSelector = providerSelector, fold_virt_text_handler = handler })
UFO

	if exists('g:neovide')
		set linespace=1
		set guifont=Cascadia\ Code:h12
		if HostnameMatches('CEPHEUS')
			let g:neovide_refresh_rate = 144
			nnoremap <silent><leader>t :below split +term\ C:/Progra~1/Git/bin/bash.exe<cr>
			nnoremap <silent><leader>T :tabnew +term\ C:/Progra~1/Git/bin/bash.exe<cr>
			nnoremap <F3> :below split +term\ C:/Progra~1/Git/bin/bash.exe<cr>
			nnoremap <S-F3> :tabnew +term\ C:/Progra~1/Git/bin/bash.exe<cr>
		endif
	endif

	lua require('gitsigns').setup()

	lua << NOICE
		require("noice").setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
NOICE

	" }}}
	
	" {{{ Lualine
	
	lua << LUALINE
		local colors = {
			color11  = "#709d6c",
			color0   = "#9aa7bd",
			color1   = "#323c4d",
			color2   = "#51617d",
			color3   = "#232936",
			color4   = "#608cc3",
			color5   = "#b15e7c",
			color8   = "#b3785d",
		}

		local deepspace = {
			inactive = {
				a = { fg = colors.color0, bg = colors.color1 , gui = "bold", },
				c = { fg = colors.color2, bg = colors.color3 },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			normal = {
				a = { fg = colors.color3, bg = colors.color4 , gui = "bold", },
				c = { fg = colors.color2, bg = colors.color3 },
				b = { fg = colors.color0, bg = colors.color1 },
			},
			replace = {
				a = { fg = colors.color3, bg = colors.color5 , gui = "bold", },
				b = { fg = colors.color0, bg = colors.color1 },
			},
			visual = {
				a = { fg = colors.color3, bg = colors.color8 , gui = "bold", },
				b = { fg = colors.color0, bg = colors.color1 },
			},
			insert = {
				a = { fg = colors.color3, bg = colors.color11 , gui = "bold", },
				b = { fg = colors.color0, bg = colors.color1 },
			},
		}

		local function get_short_cwd()
			return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
		end

		local nvim_tree = {
			sections = {
				lualine_c = { get_short_cwd },
			},
			filetypes = { 'NvimTree' }
		}

		local lsp_status = require("lsp-status")
		lsp_status.config({
			status_symbol = "",
		})

		local function get_status()
			local status = lsp_status.status()
			return vim.trim(status)
		end

		require("lualine").setup({
			options = {
				theme = deepspace,
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_b = {
					{
						'branch',
						icon = "",
						fmt = function(branch, ctx)
							local status = get_status()
							local out = {}

							if branch ~= "" then table.insert(out, " " .. branch) end
							if status ~= "" then table.insert(out, status) end
							
							return table.concat(out, " ")
						end,
						padding = { left = 0, right = 1 }
					}
				},
				lualine_c = { 'filename', 'diff' },
				lualine_x = { 'encoding', 'fileformat', { 'filetype', colored = false, icon_only = true } },
			},
			extensions = { nvim_tree },
		})
LUALINE

	" }}}

endif

