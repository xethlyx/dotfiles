call plug#begin()

" set cmdheight=10

" if !has("nvim")
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'josa42/vim-lightline-coc'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" endif

" Plug 'metakirby5/codi.vim'

if has("nvim")
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'windwp/nvim-autopairs'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-tree/nvim-web-devicons'
    " LINUX ONLY!!
    " Plug 'icedman/nvim-textmate'
    " lua require('nvim-textmate')
    " Plug 'neovim/nvim-lspconfig'
    " Plug 'hrsh7th/nvim-cmp'
endif

Plug 'tyrannicaltoucan/vim-deep-space', {'as': 'vim-deep-space'}
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary' " gc to comment selection, gcc to comment current line
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

call plug#end()

" Fix alt keys in Windows Terminal, but only if not in nvim because it doesn't
" respect this
if !has("nvim")
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
set expandtab
set autoindent
set smarttab
set belloff=cursor,backspace

inoremap <C-U> <C-G>u<C-U>
nnoremap <silent><C-L> :let @/ = ""<CR><C-L>
colorscheme deep-space

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

set number
set noshowmode
set laststatus=2

set ttimeout
set ttimeoutlen=25

imap <c-j> <down>
imap <c-k> <up>

nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

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
    highlight! link NvimTreeGitNew SignifySignAdd
    highlight! link NvimTreeGitDirty SignifySignChange
    highlight! link NvimTreeGitDeleted SignifySignDelete
endif

highlight! link DiffAdd SignifySignAdd
highlight! link DiffChange SignifySignChange
highlight! link DiffDelete SignifySignDelete

:nmap <leader>l :set invlist<cr>
set list listchars=tab:\ \ ,trail:·,extends:»,precedes:«,nbsp:×
" set list listchars=tab:❘⠀,trail:·,extends:»,precedes:«,nbsp:×

augroup netrw_setup | au!
    au FileType netrw nmap <buffer> l <CR>
augroup END

let g:lightline = {
    \ 'colorscheme': 'deepspace',
    \ 'active': {
    \   'left': [
    \       [ 'mode', 'paste' ],
    \       [ 'readonly', 'filename' ],
    \       [ 'coc_error', 'coc_warn' ],
    \       [ 'git_info' ],
    \   ],
    \   'right':[
    \       [ 'percent' ],
    \       [ 'lineinfo' ],
    \       [ 'filetype', 'fileencoding'],
    \       [ 'blame' ],
    \   ],
    \ },
    \ 'inactive': {
    \   'left': [
    \       [ 'mode', 'paste' ],
    \       [ 'readonly', 'filename' ],
    \       [ 'coc_status' ],
    \   ],
    \   'right': [
    \       [ 'percent' ],
    \       [ 'lineinfo' ],
    \       [ 'filetype', 'fileencoding'],
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

function! LightlineGitInfo()
    return get(g:, 'coc_git_status', '') . get(b:, 'coc_git_status', '')
endfunction

function! LightlineGitBlame()
    let blame = get(b:, 'coc_git_blame', '')
    return blame
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COC stuff                                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_global_extensions = ["coc-git"]

" if !has("nvim")
set updatetime=300
set signcolumn=yes
inoremap <silent><expr> <tab> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<tab>"
hi! CocErrorSign guifg=#d1666a
hi! CocInfoSign guibg=#353b45
hi! CocWarningSign guifg=#d1cd66
hi! link CocInlayHint Comment
hi! link DiagnosticError CocErrorSign
hi! link DiagnosticWarn CocWarningSign

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
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
" endif

" Highlight stuff
set fillchars+=vert:\ 
hi! link VertSplit CursorLine
hi! link netrwTreeBar Comment
hi! EndOfBuffer guifg=bg

command! WhichHi call SynStack()
command! WhichHighlight call SynStack()
" Call using :call SynStack()
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if has('mouse')
    if &term =~ 'xterm'
        set mouse=a
    else
        set mouse=nvi
    endif
endif

if has('nvim')
    " Remove netrw
    let g:loaded_netrw = 0
    let g:loaded_netrwPlugin = 1

    " Use teal syntax highlight for lua files because it behaves better..
    augroup useTealSyntax
        autocmd!
        autocmd FileType lua set filetype=teal
    augroup END

    " Setup nvim-tree
    lua require("nvim-tree").setup({ renderer = { icons = { glyphs = { git = { unstaged = "⬤", staged = "⬤", untracked = "⬤", deleted = "⬤", renamed = "⬤", unmerged = "⬤" } } } } })

    " Make terminal behave more like vim terminal
    tnoremap <C-W>N <C-\><C-n>

    " Setup autopairs
    lua require("nvim-autopairs").setup({})

    " Setup Treesitter
    lua require('nvim-treesitter.configs').setup({ highlight = { enable = true }, indent = { enable = true }, rainbow = { enable = true, extended_mode = true, colors = { "#9b59b6", "#3498db", "#2ecc71" } } })
endif
