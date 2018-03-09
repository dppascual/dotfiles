""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Filename: .vimrc                                                         "
"   Maintainer: Daniel Peña <dppascual@gmail.com>                            "
"                                                                            "
"                                                                            "
" Sections:                                                                  "
"                                                                            "
"   * User-declared variables and functions                                  "
"   * General                                                                "
"   * Vim-plug                                                               "
"   * Appareance                                                             "
"       * UI Layout                                                          "
"       * Theme & Colors                                                     "
"       * Airline                                                            "
"       * Vim-devicons                                                       "
"   * IDE options                                                            "
"       * Denite                                                             "
"       * Spaces & Tabs                                                      "
"       * Searching                                                          "
"       * Deoplete                                                           "
"       * Vim-multiple-cursors                                               "
"       * IndentLine                                                         "
"       * UltiSnips                                                          "
"       * Auto-pairs                                                         "
"       * NERDTree                                                           "
"       * Tagbar                                                             "
"       * Folding                                                            "
"   * Error Handling                                                         "
"       * Neomake                                                            "
"   * Languages                                                              "
"      * Vim-go                                                              "
"      * Vim-json                                                            "
"   * Mapping keys                                                           "
"   * AutoGroups                                                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"{{{ User-declared variables and functions

" Set KernosVim buffer index type, default is 0.
" >
"   " types:
"   " 0: 1 ➛ ➊
"   " 1: 1 ➛ ➀
"   " 2: 1 ➛ ⓵
"   " 3: 1 ➛ ¹
"   " 4: 1 ➛ 1
"   let g:kernosvim_buffer_index_type = 1
" <
let g:kernosvim_buffer_index_type = 0

function! s:kernosvim_bubble_num(num, type) abort
  let list = []
  call add(list,['➊', '➋', '➌', '➍', '➎', '➏', '➐', '➑', '➒', '➓'])
  call add(list,['➀', '➁', '➂', '➃', '➄', '➅', '➆', '➇', '➈', '➉'])
  call add(list,['⓵', '⓶', '⓷', '⓸', '⓹', '⓺', '⓻', '⓼', '⓽', '⓾'])
  let n = ''
  try
    let n = list[a:type][a:num-1]
  catch
  endtry
  return  n
endfunction

"}}}

"{{{ General
set nocompatible         " get rid of Vi compatibility mode. SET FIRST!
set hidden				 " it hides buffers instead of closing them. It allows to switch between buffers without saving changes
set encoding=utf-8
"filetype off
set mouse=a
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set clipboard=unnamed
set nrformats=
"}}}

"{{{ Vim-plug
call plug#begin('~/.vim/plugged')

" Appareance
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" IDE options
Plug 'Shougo/denite.nvim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-fugitive'
" Error Handling
Plug 'neomake/neomake'
" Languages
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'vim-ruby/vim-ruby'

call plug#end()
"}}}

"{{{ Appareance
"{{{ UI Layout
filetype plugin indent on       " use indentation scripts located in the indent folder of your vim installation.
" show the absolute number on the cursor line and relative numbers everywhere else (number and relativenumber)
set number                          " show line numbers
set relativenumber			        " display line numbers relative to the line with the cursor
set numberwidth=6                   " change the width of the gutter column used for numbering
set cul                             " highlight current line
set laststatus=2                    " last window always has a statusline
set wildmenu
set fillchars=vert:│,fold:·         " get rid of the pipe character between windows
set noshowcmd                       " hide cmd
set linebreak                       " no break words
"}}}

"{{{ Theme & Colors
syntax on
set t_Co=256
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'soft'
set guifont=MesloLGMDZ\ Nerd\ Font:h12
" it sets tilde symbols to bg color
hi! EndOfBuffer ctermfg=bg
hi! FoldColumn ctermbg=bg
"}}}

"{{{ Airline
let g:airline_theme='gruvbox'
let g:Powerline_symbols='unicode'
let g:airline_powerline_fonts=1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {}
for s:i in range(9)
    call extend(g:airline#extensions#tabline#buffer_idx_format,
            \ {s:i : s:kernosvim_bubble_num(s:i,
            \ g:kernosvim_buffer_index_type). ' '})
endfor
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#fnametruncate = 0
let g:airline#extensions#tabline#buffers_label = 'Buffers'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
if get(g:, 'airline_powerline_fonts', 0)
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
  let g:airline_symbols.maxlinenr= ''
endif


let g:bufferline_echo=0
"let g:airline#extensions#tabline#buffer_nr_format = '%s:'
"let g:airline#extensions#tabline#fnamemod = ':t'
"let g:airline#extensions#tabline#fnamecollapse = 1
"let g:airline#extensions#tabline#fnametruncate = 0
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
"let g:airline#extensions#default#section_truncate_width = {
"    \ 'b': 79,
"    \ 'x': 60,
"    \ 'y': 88,
"    \ 'z': 45,
"    \ 'warning': 80,
"    \ 'error': 80,
"    \ }
"let g:airline#extensions#default#layout = [
"    \ [ 'a', 'error', 'warning', 'b', 'c'  ],
"    \ [ 'x', 'y', 'z'  ]
"    \ ]
"let g:airline#extensions#tagbar#enabled = 0
" Distinct background color is enough to discriminate the warning and
" error information.
"let g:airline#extensions#ale#error_symbol = '•'
"let g:airline#extensions#ale#warning_symbol = '•'
"let g:airline#extensions#bufferline#overwrite_variables=0
"}}}

"{{{ Vim-devicons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsOS = 'Darwin'
let g:WebDevIconsUnicodeDecorateFileNodes = 0
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
"}}}
"}}} Appareance

"{{{ IDE options
"{{{ Denite
nnoremap <silent> <C-j>s :Denite file_rec<CR>
nnoremap <silent> <C-j>l :Denite buffer<CR>
"}}}

"{{{ Spaces & Tabs
" Indentation options by default
set autoindent			" Copy the indentation from current line when starting a new line
set expandtab			" When enabled, causes spaces to be used in place of tab characters
set tabstop=4           " Specifies the width of a tab character
set softtabstop=4       " When enabled, fine tunes the amount of whitespace to be inserted
set shiftwidth=4  	    " Determines the amount of whitespace to insert or remove using indentatioin when you press >>, << or ==
                        " It also affects how automatic indentation works with smarttab
"}}}

"{{{ Searching
set hlsearch						" occurrences searched will be highlighted
"set incsearch
"}}}

"{{{ Deoplete
set completeopt=longest,menuone,preview " auto complete setting
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns['default'] = '\h\w*'
let g:deoplete#omni#input_patterns = {}
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#align_class = 1
"}}}

"{{{ Vim-multiple-cursors
" Default mapping disable
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<C-c>'
nnoremap <C-c> :call multiple_cursors#quit()<CR>
"}}}

"{{{ IndentLine
let g:indentLine_enabled = 0
let g:indentLine_color_term = 239
let g:indentLine_char = '¦'
"set conceallevel=0
"}}}

"{{{ UltiSnips
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
"}}}

"{{{ Auto-pairs
let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
"}}}

"{{{ NERDTree
let NERDTreeMinimalUI = 0
let NERDTreeQuitOnOpen = 1
let g:NERDTreeDirArrows = 1
"}}}

"{{{ Tagbar
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
"}}}

"{{{ Folding
"set foldmethod=indent
"set foldcolumn=5                " sets the width for a column on the side of the window to indicate folds
"set foldnestmax=10              " Maximum nesting for indent and syntax folding
"set foldlevelstart=1
"}}}
"}}}

"{{{ Error Handling
"{{{ Neomake
"let g:neomake_verbose=3
"let g:neomake_logfile='/tmp/error.log'

let g:neomake_open_list = 2
let g:neomake_go_enabled_makers = ['scalastyle']
let g:neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
let g:neomake_go_gometalinter_maker = {
  \ 'args': [
  \   '--tests',
  \   '--enable-gc',
  \   '--concurrency=3',
  \   '--fast',
  \   '-D', 'aligncheck',
  \   '-D', 'dupl',
  \   '-D', 'gocyclo',
  \   '-D', 'gotype',
  \   '-E', 'errcheck',
  \   '-E', 'misspell',
  \   '-E', 'unused',
  \   '%:p:h',
  \ ],
  \ 'append_file': 0,
  \ 'errorformat':
  \   '%E%f:%l:%c:%trror: %m,' .
  \   '%W%f:%l:%c:%tarning: %m,' .
  \   '%E%f:%l::%trror: %m,' .
  \   '%W%f:%l::%tarning: %m'
  \ }

let g:neomake_error_sign = {
    \ 'text': '✘',
    \ 'texthl': 'NeomakeErrorSign',
    \ }
let g:neomake_warning_sign = {
    \ 'text': '!',
    \ 'texthl': 'NeomakeWarningSign',
    \ }
let g:neomake_message_sign = {
     \   'text': '➤',
     \   'texthl': 'NeomakeMessageSign',
     \ }
let g:neomake_info_sign = {
    \   'text': 'ℹ',
    \   'texthl': 'NeomakeInfoSign'
    \ }
"}}}
"}}}

"{{{ Languages
"{{{ Vim-go
let g:go_fmt_autosave=0                   "Disable auto gofmt when files are saved
let g:go_fmt_command = "goimports"        "Enable goimports instead of gofmt. goimport does everything that gofmt do. Additionally it groups and corrects imported packages. While correcting, goimports removes unused imports and adds missing ones.
"Enable syntax-highlighting for Functions, Methods and Structs.
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
"let g:go_fmt_fail_silently = 1
"let g:go_list_type = "quickfix"
"}}}

"{{{ Vim-json
"let g:vim_json_syntax_conceal = 0
"}}}
"}}}

"{{{ Mapping keys
" Tagbar
nnoremap <silent> <leader>t :TagbarToggle<CR>

" NERDTree
nnoremap <silent> <leader>d :NERDTreeToggle<CR>

" Toogle highlighting on/off
nnoremap <silent> <leader>h :set hlsearch!<cr>

" Toogle relative number on/off
nnoremap <silent> <leader>rn :set relativenumber!<cr>

" <C-c> to <Esc> (problem with Vim-multiple-cursors)
"inoremap <esc> <Nop>

" Disable arrow keys
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
"}}}

"{{{ AutoGroups
augroup GeneralFiles
    autocmd!
    autocmd FileType * :setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

augroup Neomake
    autocmd!
    autocmd BufWritePost *.go Neomake
    autocmd FileType go nnoremap <silent> <leader>lo :lopen<CR>
    autocmd FileType go nnoremap <silent> <leader>lc :lclose<CR>
augroup END

augroup Vim
    autocmd!
    autocmd BufEnter .vimrc,*.vim :setlocal foldmethod=marker foldmarker={{{,}}} foldcolumn=0 foldlevelstart=0
augroup END

augroup PythonFiles
    autocmd!
    autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab foldmethod=indent foldlevel=99
    autocmd FileType python IndentLinesEnable
    autocmd FileType python nnoremap <C-]> :YcmCompleter GoToDeclaration<CR>
    autocmd FileType python nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
augroup END

augroup GoFiles
    autocmd!
    autocmd FileType go setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=0
    autocmd FileType go setlocal list listchars=tab:\¦\ 
    autocmd FileType go nnoremap <silent> <leader>gr <Plug>(go-run)
    autocmd FileType go nnoremap <silent> <leader>gb <Plug>(go-build)
    autocmd FileType go nnoremap <silent> <leader>gt <Plug>(go-test)
    autocmd FileType go nmap <leader>gd <Plug>(go-doc-split)
    autocmd FileType go nmap <leader>gf <Plug>(go-def-split)
"    autocmd FileType go inoremap { {<cr>}<esc>O
"    autocmd FileType go inoremap [ [<cr>]<esc>O
augroup END

augroup RubyFiles
    autocmd!
    autocmd FileType ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=0
    autocmd FileType ruby IndentLinesEnable
augroup END

augroup CFiles
    autocmd!
    autocmd BufNewFile,BufRead *.c,*.h setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
augroup END


augroup JsonFiles
    autocmd!
    autocmd FileType json setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=0
augroup END

augroup MakeFiles
    autocmd!
    autocmd FileType make setlocal noexpandtab tabstop=4 softtabstop=4  shiftwidth=4
augroup END
"}}}
