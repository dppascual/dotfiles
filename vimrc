""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Filename: .vimrc                                                         "
"   Maintainer: Daniel Peña <dppascual@gmail.com>                            "
"                                                                            "
"                                                                            "
" Sections:                                                                  "
"   * General                                                                "
"   * Vim-plug                                                               "
"   * UI Layout                                                              "
"   * Theme & Colors                                                         "
"   * Spaces & Tabs                                                          "
"   * Searching                                                              "
"   * Misc                                                                   "
"   * Vim-multiple-cursors                                                   "
"   * IndentLine                                                             "
"   * UltiSnips                                                              "
"   * Airline                                                                "
"   * Auto-pairs                                                             "
"   * CtrlP                                                                  "
"   * Deoplete
"   * Neomake                                                                "
"   * Vim-go                                                                 "
"   * Vim-json                                                               "
"   * Tagbar                                                                 "
"   * Mapping keys                                                           "
"   * AutoGroups                                                             "
"   * Functions                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"{{{ General
set nocompatible         " get rid of Vi compatibility mode. SET FIRST!
set hidden				 " it hides buffers instead of closing them. It allows to switch between buffers without saving changes
set encoding=utf-8
filetype off
set mouse=""
"}}}

"{{{ Vim-plug
call plug#begin('~/.vim/plugged')

" Appareance
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
" IDE options
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}
" Error Handling
Plug 'neomake/neomake'
" Miscellaneous functionalities
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-fugitive'
" Languages
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'fatih/vim-go'
Plug 'vim-ruby/vim-ruby'

call plug#end()
"}}}

"{{{ UI Layout
filetype plugin indent on       " use indentation scripts located in the indent folder of your vim installation.
" show the absolute number on the cursor line and relative numbers everywhere else (number and relativenumber)
set number                      " show line numbers
set relativenumber			    " display line numbers relative to the line with the cursor
set numberwidth=6               " change the width of the gutter column used for numbering
set cul                         " highlight current line
set laststatus=2                " last window always has a statusline
set wildmenu
"}}}

"{{{ Theme & Colors
syntax on
set t_Co=256
set background=dark
colorscheme gruvbox
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

"{{{ Misc
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set clipboard=unnamed
set nrformats=
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

"{{{ Airline
let g:bufferline_echo=0
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:Powerline_symbols='fancy'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
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

"{{{ Auto-pairs
let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
"}}}

"{{{ CtrlP
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_mruf_max=450    " number of recently opened files
let g:ctrlp_max_files=0     " do not limit the number of searchable files
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'
let g:ctrlp_buftag_types = {'go' : '--language-force=go --golang-types=ftv'}

nnoremap <silent> <leader>b :CtrlPCurWD<CR>
"}}}

"{{{ Deoplete
"let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
"let g:ycm_python_binary_path = 'python'
" make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'
set completeopt-=longest,menuone,preview " auto complete setting
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns['default'] = '\h\w*'
let g:deoplete#omni#input_patterns = {}
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#align_class = 1
"}}}

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

"{{{ Tagbar
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
"}}}

"{{{ Folding
"set foldmethod=indent
"set foldcolumn=5                " sets the width for a column on the side of the window to indicate folds
"set foldnestmax=10              " Maximum nesting for indent and syntax folding
"set foldlevelstart=1
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
    autocmd BufEnter .vimrc,*.vim :setlocal foldmethod=marker foldmarker={{{,}}} foldcolumn=5 foldlevelstart=0
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
    autocmd FileType go setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=5
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
    autocmd FileType ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=5
    autocmd FileType ruby IndentLinesEnable
augroup END

augroup CFiles
    autocmd!
    autocmd BufNewFile,BufRead *.c,*.h setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
augroup END


augroup JsonFiles
    autocmd!
    autocmd FileType json setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=5
augroup END

augroup MakeFiles
    autocmd!
    autocmd FileType make setlocal noexpandtab tabstop=4 softtabstop=4  shiftwidth=4
augroup END
"}}}

"{{{ Functions
"}}}
