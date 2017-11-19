""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Filename: .vimrc                                                         "
"   Maintainer: Daniel Peña <dppascual@gmail.com>                            "
"                                                                            "
"                                                                            "
" Sections:                                                                  "
"   * General                                                                "
"   * Vundle                                                                 "
"   * UI Layout                                                              "
"   * Theme & Colors                                                         "
"   * Spaces & Tabs                                                          "
"   * Searching                                                              "
"   * Misc                                                                   "
"   * Vim-multiple-cursors                                                   "
"   * Vim-minimap                                                            "
"   * IndentLine                                                             "
"   * UltiSnips                                                              "
"   * Airline                                                                "
"   * Auto-pairs                                                             "
"   * CtrlP                                                                  "
"   * YouComplete                                                            "
"   * Syntastic                                                              "
"   * Neomake                                                                "
"   * Vim-scala                                                              "
"   * Vim-go                                                                 "
"   * Tagbar                                                                 "
"   * Mapping keys                                                           "
"   * AutoGroups                                                             "
"   * Functions                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"python with virtualenv support
"py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"  project_base_dir = os.environ['VIRTUAL_ENV']
"  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"  execfile(activate_this, dict(__file__=activate_this))
"EOF

"{{{ General
set nocompatible         " get rid of Vi compatibility mode. SET FIRST!
set hidden				 " it hides buffers instead of closing them. It allows
" to switch between buffers without saving changes
set encoding=utf-8
filetype off
set mouse=""
"}}}

"{{{ Vundle
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-bufferline'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
"Plugin 'scrooloose/syntastic'
Plugin 'neomake/neomake'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-surround'
Plugin 'jiangmiao/auto-pairs'
Plugin 'godlygeek/tabular'
Plugin 'SirVer/ultisnips'
Plugin 'Yggdroot/indentLine'
Plugin 'fatih/vim-go'
Plugin 'vim-ruby/vim-ruby'
"Plugin 'derekwyatt/vim-scala'
"Plugin 'ensime/ensime-vim'

" All of your Plugins must be added before the following line
call vundle#end()
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
colorscheme molokai
"}}}

"{{{ Spaces & Tabs
" Indentation options
set autoindent						" copy the indentation from current line when starting a new line
set expandtab						" use spaces for indentation
set softtabstop=4
set tabstop=4                       " uses spaces, not tabs (width = 4) for indentation
set shiftwidth=4  				    " indentation used (width = 4) when you press >>, << or ==
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

"{{{ Vim-minimap
let g:minimap_show='<leader>ms'
let g:minimap_update='<leader>mu'
let g:minimap_close='<leader>mc'
let g:minimap_toggle='<leader>mt'
"}}}

"{{{ IndentLine
let g:indentLine_enabled = 1
let g:indentLine_color_term = 239
let g:indentLine_char = '¦'
"set conceallevel=1
"let g:indentLine_conceallevel=1
"}}}

"{{{ UltiSnips
"}}}

"{{{ Airline
let g:bufferline_echo=0
let g:airline_theme='badwolf'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
"let g:airline#extensions#bufferline#overwrite_variables=0
"}}}

"{{{ Auto-pairs
let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
"}}}

"{{{ CtrlP
let g:ctrlp_match_window='bottom,order:ttb'
let g:ctrlp_switch_buffer=0
let g:ctrlp_working_path_mode=0
let g:ctrlp_user_command = 'find %s -type f'
"let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
"      \ --ignore .git
"      \ --ignore .svn
"      \ --ignore .hg
"      \ --ignore .DS_Store
"      \ -g ""'
let g:ctrlp_max_files=0

nnoremap <silent> <leader>b :CtrlPBuffer<CR>
"}}}

"{{{ YouComplete
let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
let g:ycm_python_binary_path = 'python'
"}}}

"{{{ Syntastic
"set statusline+=%#warningmsg#                      "Not necessary with airline plugin
"set statusline+=%{SyntasticStatuslineFlag()}       "Not necessary with airline plugin
"set statusline+=%*                                 "Not necessary with airline plugin
"""let g:syntastic_stl_format = "[%E{Errors: %fe #%e}%B{, }%W{Warnings: %fw #%w}]"    "control what the syntastic statusline text contains. (Default: '[Syntax: line:%F (%t)]')
"""
"""let g:syntastic_always_populate_loc_list = 1    "By default syntastic doesn't fill the |location-list| with the errors found by the checkers. Enable this option to tell syntastic to always stick any detected errors into the |location-list|. (Default: 0)
"""let g:syntastic_auto_loc_list = 1       "Automatically open the |location-list| when errors are detected, and close when none are detected. syntastic fill the |location-list| with the errors found by the checkers. By default, doesn't. (Default: 2)
"""let g:syntastic_loc_list_height = 5     "Specify the height of the location lists that syntastic opens. (Default: 10)
"""let g:syntastic_check_on_open = 0       "In active mode will run syntax checks when buffers are first loaded. (Default: 0 - disable)
"""let g:syntastic_check_on_wq = 0         "In active mode syntax checks are run whenever buffers are written to disk. (Default: 1 - enable)
"""let g:syntastic_aggregate_errors = 1    "If |'syntastic_aggregate_errors'| is unset (which is the default), checking stops the first time a checker reports any errors; if |'syntastic_aggregate_errors'| is set, all checkers that apply are run in turn, and all errors found are aggregated in a single list. (Default: 0 - disable)
"""let g:syntastic_id_checkers = 1             "Label error messages with the names of the checkers that created them. (Default: 1 - enable)
"""let g:syntastic_sort_aggregated_errors = 1  "Errors are grouped by file, then sorted by line number, then grouped by type (namely errors take precedence over warnings), then they are sorted by column number, when results from multiple checkers are aggregated in a single error list. (Default: 1 - enable)
"""let g:syntastic_echo_current_error = 1  "Echo current error to the command window. (Default: 1 - enable)
"""let g:syntastic_cursor_column = 0       "This option controls which errors are echoed to the command window if |'syntastic_echo_current_error'| is set and multiple errors are found on the same line. When the option is enabled, the first error corresponding to the current column is shown. Otherwise, the first error on the current line is echoed, regardless of the cursor position on the current line. (Default: 1 - enable)
"""
"""let g:syntastic_error_symbol = "\u2718"
"""let g:syntastic_warning_symbol = "\u2718"
"""let g:syntastic_style_error_symbol = "S>"
"""let g:syntastic_style_warning_symbol = "S>"
"""highlight SyntasticErrorSign term=reverse ctermbg=52 gui=undercurl guisp=#FF0000
"""highlight SyntasticWarningSign term=reverse ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792
"""highlight link SyntasticStyleErrorSign SyntasticErrorSign
"""highlight link SyntasticStyleWarningSign SyntasticWarningSign
"""
"""let g:syntastic_go_checkers = ['go', 'gofmt', 'golint', 'govet']
"""let g:syntastic_scala_checkers = ['fsc', 'scalac']
"""let g:syntastic_mode_map = { "mode": 'active',
"""            \ "active_filetypes": [],
"""            \ "passive_filetypes": ['go','scala']  }
"}}}

"{{{ Neomake
"let g:neomake_verbose=3
"let g:neomake_logfile='/tmp/error.log'

let g:neomake_open_list = 2
"let g:neomake_scala_enabled_makers = ['scalastyle']

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

"{{{ Vim-scala
"let g:scala_scaladoc_indent = 1 "Enable the indentation standard as recommended for Scaladoc comments, else the plugin indents documentation comments according to the standard Javadoc format.
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

"augroup Syntastic
"    autocmd!
"    autocmd FileType scala,go nnoremap <silent> <leader>lo :lopen<CR>
"    autocmd FileType scala,go nnoremap <silent> <leader>lc :lclose<CR>
"    autocmd FileType scala,go nnoremap <silent> <leader>ln :lnext<CR>
"    autocmd FileType scala,go nnoremap <silent> <leader>lp :lprev<CR>
"    autocmd FileType scala,go nnoremap <silent> <leader>sc :SyntasticCheck<CR>
"augroup END

augroup Neomake
    autocmd!
    autocmd BufWritePost *.scala Neomake
    autocmd FileType scala nnoremap <silent> <leader>lo :lopen<CR>
    autocmd FileType scala nnoremap <silent> <leader>lc :lclose<CR>
augroup END

augroup Vim
    autocmd!
    autocmd BufEnter .vimrc,*.vim :setlocal foldmethod=marker foldmarker={{{,}}} foldcolumn=5 foldlevelstart=0
augroup END

augroup PythonFiles
    autocmd!
    autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab foldmethod=indent foldlevel=99
    autocmd FileType python setlocal list listchars=tab:\¦\ 
    "autocmd FileType python let g:indentLine_enabled=1
    autocmd FileType python nnoremap <C-]> :YcmCompleter GoToDeclaration<CR>
    autocmd FileType python nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
augroup END

augroup GoFiles
    autocmd!
    autocmd FileType go setlocal noexpandtab softtabstop=8 tabstop=8 shiftwidth=8 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=5
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
    autocmd FileType ruby setlocal expandtab softtabstop=2 tabstop=2 shiftwidth=2 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=5
augroup END

augroup ScalaFiles
    autocmd!
    autocmd FileType scala setlocal foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=5
    autocmd FileType scala let g:indentLine_enabled=1
    autocmd FileType scala let g:ycm_auto_trigger = 1
augroup END

augroup MakeFiles
    autocmd!
    autocmd FileType make setlocal noexpandtab softtabstop=8 tabstop=8 shiftwidth=8
augroup END
"}}}

"{{{ Functions
"}}}
