" ---------------------------------------
" Vim Configuration
" ---------------------------------------

" {{{ Plugins
call plug#begin()

if has('nvim')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'josa42/vim-lightline-coc'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/playground'
	Plug 'nmac427/guess-indent.nvim'
	Plug 'mrjones2014/nvim-ts-rainbow'
	Plug 'windwp/nvim-autopairs'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'norcalli/nvim-colorizer.lua'

	Plug 'kevinhwang91/promise-async'
	Plug 'kevinhwang91/nvim-ufo'

	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
	Plug 'Wansmer/treesj'
	Plug 'rust-lang/rust.vim'
endif

Plug 'aymericbeaumet/vim-symlink'
Plug 'moll/vim-bbye'
Plug 'tyrannicaltoucan/vim-deep-space', {'as': 'vim-deep-space'}
Plug 'itchyny/lightline.vim'
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

hi! link TelescopeBorder NonText

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

" {{{ COC

if has('nvim')
	let g:coc_global_extensions = ["coc-git"]

	inoremap <silent><expr> <tab> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<tab>"
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

	" Use K to show documentation in preview window.
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
		if CocAction('hasProvider', 'hover')
			call CocActionAsync('doHover')
		else
			call feedkeys('K', 'in')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)
	nmap <f2> <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	nmap <leader>al  <Plug>(coc-codeaction-cursor)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Run the Code Lens action on the current line.
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
		inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
		inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
		vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of language server.
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call	 CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call	 CocActionAsync('runCommand', 'editor.action.organizeImport')

	call coc#config('git', {
		\	'addGBlameToBufferVar': 'true',
		\	'addedSign.text': '▍',
		\	'changedSign.text': '▍',
		\})

	call coc#config('diagnostic', {
		\	'errorSign': '×',
		\	'warningSign': '×',
		\	'hintSign': '×',
		\	'infoSign': '×',
		\})

	call coc#config('diagnostic', {
		\	'virtualText': 'true',
		\	'virtualTextCurrentLineOnly': 'false',
		\	'virtualTextLines': 1,
		\})

	call coc#config('semanticTokens', {
		\	'enable': 'true',
		\	'highlightPriority': 0,
		\	'filetypes': ['*'],
		\})
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
	lua require("nvim-treesitter.parsers").get_parser_configs().luau = { install_info = { url = "https://github.com/xethlyx/tree-sitter-luau.git", branch = "main", files = { "src/parser.c", "src/scanner.c" }, requires_generate_from_grammar = false }, filetype = "luau" }

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
		set guifont=Cascadia\ Code:h12
		if HostnameMatches('CEPHEUS')
			let g:neovide_refresh_rate = 144
			nnoremap <silent><leader>t :below split +term\ C:/Progra~1/Git/bin/bash.exe<cr>
			nnoremap <silent><leader>T :tabnew +term\ C:/Progra~1/Git/bin/bash.exe<cr>
			nnoremap <F3> :below split +term\ C:/Progra~1/Git/bin/bash.exe<cr>
			nnoremap <S-F3> :tabnew +term\ C:/Progra~1/Git/bin/bash.exe<cr>
		endif
	endif

	" }}}

endif
