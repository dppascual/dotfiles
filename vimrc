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
"   * YouComplete                                                            "
"   * Neomake                                                                "
"   * Vim-go                                                                 "
"   * Vim-json                                                               "
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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
" IDE options
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'Valloric/YouCompleteMe'
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
colorscheme molokai
"}}}

"{{{ Spaces & Tabs
" Indentation options by default
set autoindent			" Copy the indentation from current line when starting a new line
set noexpandtab			" When enabled, causes spaces to be used in place of tab characters
set tabstop=8                   " Specifies the width of a tab character
set softtabstop=0               " When enabled, fine tunes the amount of whitespace to be inserted
set shiftwidth=8  	        " Determines the amount of whitespace to insert or remove using indentatioin when you press >>, << or ==
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
function! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    if pumvisible()
      return "\<C-n>"
    else
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        return "\<TAB>"
      endif
    endif
  endif
  return ""
endfunction

function! g:UltiSnips_Reverse()
  call UltiSnips#JumpBackwards()
  if g:ulti_jump_backwards_res == 0
    return "\<C-P>"
  endif

  return ""
endfunction


if !exists("g:UltiSnipsJumpForwardTrigger")
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
endif

if !exists("g:UltiSnipsJumpBackwardTrigger")
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
endif

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
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
