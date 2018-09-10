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
"       * Airline                                                            "
"       * Vim-devicons                                                       "
"       * Statusline                                                         "
"       * Theme & Colors                                                     "
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
""
" Set KernOSVim windows index type, default is 0.
" >
"   " types:
"   " 0: 1 ➛ ➊ 
"   " 1: 1 ➛ ➀
"   " 2: 1 ➛ ⓵
"   let g:kernosvim_windows_index_type = 1
" <
let g:kernosvim_windows_index_type = 0
""
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

function! Kernosvim_bubble_num(num, type) abort
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

function! Kernosvim_circled_letter(letter) abort
  " http://www.unicode.org/charts/beta/nameslist/n_2460.html
  if index(range(1, 26), char2nr(a:letter) - 64) != -1
    return nr2char(9397 + char2nr(a:letter) - 64)
  elseif index(range(1, 26), char2nr(a:letter) - 96) != -1
    return nr2char(9423 + char2nr(a:letter) - 96)
  else
    return ''
  endif
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
Plug 'blueyed/vim-diminactive'
" IDE options
Plug 'Shougo/denite.nvim'
Plug 'wsdjeg/FlyGrep.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-fugitive'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" Error Handling
Plug 'neomake/neomake'
" Languages
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'jodosha/vim-godebug'
Plug 'rust-lang/rust.vim'
Plug 'vim-ruby/vim-ruby'

call plug#end()
"}}}

"{{{ Appareance
"{{{ UI Layout
filetype plugin indent on       " use indentation scripts located in the indent folder of your vim installation.
" show the absolute number on the cursor line and relative numbers everywhere else (number and relativenumber)
set number                          " show line numbers
set relativenumber			        " display line numbers relative to the line with the cursor
set numberwidth=4                   " change the width of the gutter column used for numbering
set cul                             " highlight current line
set laststatus=2                    " last window always has a statusline
set wildmenu
set fillchars=vert:│,fold:·         " get rid of the pipe character between windows
set noshowcmd                       " hide cmd
set linebreak                       " no break words
"}}}

"{{{ Airline
let g:airline#extensions#tabline#enabled=0
let g:airline_theme='gruvbox'
let g:Powerline_symbols='unicode'
let g:airline_powerline_fonts=1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {}
for s:i in range(9)
    call extend(g:airline#extensions#tabline#buffer_idx_format,
            \ {s:i : Kernosvim_bubble_num(s:i,
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

"{{{ Statusline
""" Init
""
" Enable/Disable unicode symbols in statusline
let g:kernosvim_statusline_unicode_symbols = 1
""
" Enable/Disable display mode. Default is 0, mode will be
" displayed in statusline. To enable this feature:
let g:kernosvim_enable_statusline_display_mode = 0
""
" Set the statusline separators of statusline, default is 'curve'
" >
"   Separatos options:
"     1. arrow
"     2. curve
"     3. slant
"     4. nil
"     5. fire
" <
let s:kernosvim_statusline_separator = 'arrow'
let s:kernosvim_statusline_inactive_separator = 'arrow'


""
" Define the left section of statusline in active windows.
let s:kernosvim_statusline_left_sections = ['winnr', 'filename', 'filetype',
      \ 'minor mode lighters', 'version control info']
""
" Define the right section of statusline in active windows.
let s:kernosvim_statusline_right_sections = ['fileformat', 'cursorpos', 'percentage']
let s:separators = {
      \ 'arrow' : ["\ue0b0", "\ue0b2"],
      \ 'curve' : ["\ue0b4", "\ue0b6"],
      \ 'slant' : ["\ue0b8", "\ue0ba"],
      \ 'brace' : ["\ue0d2", "\ue0d4"],
      \ 'fire' : ["\ue0c0", "\ue0c2"],
      \ 'nil' : ['', ''],
      \ }
let s:i_separators = {
      \ 'arrow' : ["\ue0b1", "\ue0b3"],
      \ 'bar' : ["|", "|"],
      \ 'nil' : ['', ''],
      \ }
let s:loaded_modes = ['syntax-checking', 'whitespace']

if &cc ==# '80'
  call add(s:loaded_modes, 'fill-column-indicator')
endif

let s:modes = {
      \ 'hi-characters-for-long-lines' :{
      \ 'icon' : '⑧',
      \ 'icon_asc' : '8',
      \ 'desc' : 'toggle highlight of characters for long lines',
      \ },
      \ 'fill-column-indicator' :{
      \ 'icon' : Kernosvim_circled_letter('f'),
      \ 'icon_asc' : 'f',
      \ 'desc' : 'fill-column-indicator mode',
      \ },
      \ 'syntax-checking' :{
      \ 'icon' : Kernosvim_circled_letter('s'),
      \ 'icon_asc' : 's',
      \ 'desc' : 'syntax-checking mode',
      \ },
      \ 'spell-checking' :{
      \ 'icon' : Kernosvim_circled_letter('S'),
      \ 'icon_asc' : 'S',
      \ 'desc' : 'spell-checking mode',
      \ },
      \ 'whitespace' :{
      \ 'icon' : Kernosvim_circled_letter('w'),
      \ 'icon_asc' : 'w',
      \ 'desc' : 'whitespace mode',
      \ },
      \ }

let [s:lsep , s:rsep] = get(s:separators, s:kernosvim_statusline_separator, s:separators['arrow'])
let [s:ilsep , s:irsep] = get(s:i_separators, s:kernosvim_statusline_inactive_separator, s:i_separators['arrow'])

let s:colors_template = [
                \ ['#282828', '#a89984', 246, 235],
                \ ['#a89984', '#504945', 239, 246],
                \ ['#a89984', '#3c3836', 237, 246],
                \ ['#665c54', 241],
                \ ['#282828', '#83a598', 235, 109],
                \ ['#282828', '#fe8019', 235, 208],
                \ ['#282828', '#8ec07c', 235, 108],
                \ ['#282828', '#689d6a', 235, 72],
                \ ['#282828', '#8f3f71', 235, 132],
                \ ]
"let s:colors_template = [
"                \ ['#282828', '#a89984', 33, 17],
"                \ ['#a89984', '#504945', 19, 33],
"                \ ['#a89984', '#3c3836', 18, 33],
"                \ ['#665c54', 20],
"                \ ['#282828', '#83a598', 17, 109],
"                \ ['#282828', '#fe8019', 17, 208],
"                \ ['#282828', '#8ec07c', 17, 108],
"                \ ['#282828', '#689d6a', 17, 72],
"                \ ['#282828', '#8f3f71', 17, 132],
"                \ ]

function! s:group2dict(name) abort
    let id = index(map(range(1999), "synIDattr(v:val, 'name')"), a:name)
    if id == -1
        return {
                    \ 'name' : '',
                    \ 'ctermbg' : '',
                    \ 'ctermfg' : '',
                    \ 'bold' : '',
                    \ 'italic' : '',
                    \ 'underline' : '',
                    \ 'guibg' : '',
                    \ 'guifg' : '',
                    \ }
    endif
    let rst = {
                \ 'name' : synIDattr(id, 'name'),
                \ 'ctermbg' : synIDattr(id, 'bg', 'cterm'),
                \ 'ctermfg' : synIDattr(id, 'fg', 'cterm'),
                \ 'bold' : synIDattr(id, 'bold'),
                \ 'italic' : synIDattr(id, 'italic'),
                \ 'underline' : synIDattr(id, 'underline'),
                \ 'guibg' : synIDattr(id, 'bg#'),
                \ 'guifg' : synIDattr(id, 'fg#'),
                \ }
    return rst
endfunction

function! s:hi(info) abort
    if empty(a:info) || get(a:info, 'name', '') ==# ''
        return
    endif
    let cmd = 'hi! ' .  a:info.name
    if !empty(a:info.ctermbg)
        let cmd .= ' ctermbg=' . a:info.ctermbg
    endif
    if !empty(a:info.ctermfg)
        let cmd .= ' ctermfg=' . a:info.ctermfg
    endif
    if !empty(a:info.guibg)
        let cmd .= ' guibg=' . a:info.guibg
    endif
    if !empty(a:info.guifg)
        let cmd .= ' guifg=' . a:info.guifg
    endif
    let style = []
    for sty in ['bold', 'italic', 'underline']
        if get(a:info, sty, '') ==# '1'
            call add(style, sty)
        endif
    endfor
    if !empty(style)
        let cmd .= ' gui=' . join(style, ',') . ' cterm=' . join(style, ',')
    endif
    try
        exe cmd
    catch
    endtry
endfunction

function! s:hi_separator(a, b) abort
    let hi_a = s:group2dict(a:a)
    let hi_b = s:group2dict(a:b)
    let hi_a_b = {
                \ 'name' : a:a . '_' . a:b,
                \ 'guibg' : hi_b.guibg,
                \ 'guifg' : hi_a.guibg,
                \ 'ctermbg' : hi_b.ctermbg,
                \ 'ctermfg' : hi_a.ctermbg,
                \ }
    let hi_b_a = {
                \ 'name' : a:b . '_' . a:a,
                \ 'guibg' : hi_a.guibg,
                \ 'guifg' : hi_b.guibg,
                \ 'ctermbg' : hi_a.ctermbg,
                \ 'ctermfg' : hi_b.ctermbg,
                \ }
    call s:hi(hi_a_b)
    call s:hi(hi_b_a)
endfunction

function! Kernosvim_statusline_def_colors() abort
  let t = s:colors_template
  exe 'hi! KernosVim_statusline_a ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! KernosVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! KernosVim_statusline_ia ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! KernosVim_statusline_b ctermbg=' . t[1][2] . ' ctermfg=' . t[1][3] . ' guibg=' . t[1][1] . ' guifg=' . t[1][0]
  exe 'hi! KernosVim_statusline_c ctermbg=' . t[2][2] . ' ctermfg=' . t[2][3] . ' guibg=' . t[2][1] . ' guifg=' . t[2][0]
  exe 'hi! KernosVim_statusline_z ctermbg=' . t[3][1] . ' ctermfg=' . t[3][1] . ' guibg=' . t[3][0] . ' guifg=' . t[3][0]
  hi! KernosVim_statusline_error ctermbg=003 ctermfg=Black guibg=#504945 guifg=#fb4934 gui=bold
  hi! KernosVim_statusline_warn ctermbg=003 ctermfg=Black guibg=#504945 guifg=#fabd2f gui=bold
  call s:hi_separator('KernosVim_statusline_a', 'KernosVim_statusline_b')
  call s:hi_separator('KernosVim_statusline_a_bold', 'KernosVim_statusline_b')
  call s:hi_separator('KernosVim_statusline_ia', 'KernosVim_statusline_b')
  call s:hi_separator('KernosVim_statusline_a', 'KernosVim_statusline_c')
  call s:hi_separator('KernosVim_statusline_b', 'KernosVim_statusline_c')
  call s:hi_separator('KernosVim_statusline_b', 'KernosVim_statusline_z')
  call s:hi_separator('KernosVim_statusline_c', 'KernosVim_statusline_z')
endfunction

function! s:percentage() abort
  return ' %P '
endfunction

function! s:cursorpos() abort
  return ' %l:%c '
endfunction

function! s:fileformat() abort
  return '%{" " . "" . " | " . (&fenc!=""?&fenc:&enc) . " "}'
endfunction

function! s:whitespace() abort
  let ln = search('\s\+$', 'n')
  if ln != 0
    return ' trailing[' . ln . '] '
  else
    return ''
  endif
endfunction

function! s:statusline_icon_battery_status(v) abort
  if a:v >= 90
    return ''
  elseif a:v >= 75
    return ''
  elseif a:v >= 50
    return ''
  elseif a:v >= 25
    return ''
  else
    return ''
  endif
endfunction

function! s:battery_status() abort
  if executable('acpi')
    let battery = split(system('acpi'))[-1][:-2]
    if s:kernosvim_statusline_unicode_symbols
      return ' ' . s:statusline_icon_battery_status(battery) . '  '
    else
      return ' ⚡' . battery . ' '
    endif
  elseif executable('pmset')
    let battery = matchstr(system('pmset -g batt'), '\d\+%')[:-2]
    if s:kernosvim_statusline_unicode_symbols
      return ' ' . s:statusline_icon_battery_status(battery) . '  '
    else
      return ' ⚡' . battery . ' '
    endif

  else
    return ''
  endif
endfunction

function! s:syntax_checking()
	let counts = neomake#statusline#LoclistCounts()
	let warnings = get(counts, 'W', 0)
	let errors = get(counts, 'E', 0)
	let l =  warnings ? '%#KernosVim_statusline_warn# ● ' . warnings . ' ' : ''
	let l .=  errors ? (warnings ? '' : ' ') . '%#KernosVim_statusline_error#● ' . errors  . ' ' : ''
	return l
endfunction

function! s:hunks() abort
  let hunks = [0,0,0]
  try
    let hunks = GitGutterGetHunkSummary()
  catch
  endtry
  let rst = ''
  if hunks[0] > 0
    let rst .= hunks[0] . '+ '
  endif
  if hunks[1] > 0
    let rst .= hunks[1] . '~ '
  endif
  if hunks[2] > 0
    let rst .= hunks[2] . '- '
  endif
  return empty(rst) ? '' : ' ' . rst
endfunction

function! s:git_branch() abort
    let l:head = fugitive#head()
    if empty(l:head)
      call fugitive#detect(getcwd())
      let l:head = fugitive#head()
    endif
    return empty(l:head) ? '' : '  '.l:head . ' '
endfunction

function! s:modes() abort
  let m = ' ❖ '
  let l = len(s:loaded_modes)
  for mode in s:loaded_modes
    if g:kernosvim_statusline_unicode_symbols == 1
      if s:loaded_modes[l-1] == mode
        let m .= s:modes[mode].icon . ' '
      else
        let m .= s:modes[mode].icon . '  '
      endif
    else
      let m .= s:modes[mode].icon_asc . ' '
    endif
  endfor
  return m . ' '
endfunction

function! s:type_of_file() abort
  return '%{empty(&ft)? "" : " " . &ft . " "}'
endfunction

function! s:filesize() abort
  let l:size = getfsize(bufname('%'))
  if l:size == 0 || l:size == -1 || l:size == -2
    return ''
  endif
  if l:size < 1024
    return l:size.' bytes '
  elseif l:size < 1024*1024
    return printf('%.1f', l:size/1024.0).'k '
  elseif l:size < 1024*1024*1024
    return printf('%.1f', l:size/1024.0/1024.0) . 'm '
  else
    return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g '
  endif
endfunction

function! s:filename() abort
  let name = fnamemodify(bufname('%'), ':t')
  if empty(name)
    let name = 'No Name'
  endif
  return "%{ &modified ? ' * ' : ' - '}" . s:filesize() . name . ' '
endfunction

function! Kernosvim_mode(mode)
  let t = s:colors_template
  let mode = get(w:, 'kernosvim_statusline_mode', '')
  if  mode != a:mode
    if a:mode == 'n'
        exe 'hi! KernosVim_statusline_a ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
    elseif a:mode == 'i'
      exe 'hi! KernosVim_statusline_a ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
    elseif a:mode == 'R'
      exe 'hi! KernosVim_statusline_a ctermbg=' . t[6][3] . ' ctermfg=' . t[6][2] . ' guibg=' . t[6][1] . ' guifg=' . t[6][0]
    elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V' || a:mode == 's' || a:mode == 'S' || a:mode == '^S'
      exe 'hi! KernosVim_statusline_a ctermbg=' . t[5][3] . ' ctermfg=' . t[5][2] . ' guibg=' . t[5][1] . ' guifg=' . t[5][0]
    endif
    call s:hi_separator('KernosVim_statusline_a', 'KernosVim_statusline_b')
    let w:kernosvim_statusline_mode = a:mode
  endif
  return ''
endfunction

function! Kernosvim_mode_text(mode)
  if a:mode == 'n'
    return 'NORMAL '
  elseif a:mode == 'i'
    return 'INSERT '
  elseif a:mode == 'R'
    return 'REPLACE '
  elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V' || a:mode == 's' || a:mode == 'S' || a:mode == '^S'
    return 'VISUAL '
  endif
  return ' '
endfunction

function! Denite_mode()
  let t = s:colors_template
  let dmode = split(denite#get_status_mode())[1]
  if get(w:, 'kernosvim_statusline_mode', '') != dmode
    if dmode == 'NORMAL'
      exe 'hi! KernosVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
    elseif dmode == 'INSERT'
      exe 'hi! KernosVim_statusline_a_bold cterm=bold gui=bold ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
    endif
    call s:hi_separator('KernosVim_statusline_a_bold', 'KernosVim_statusline_b')
    let w:kernosvim_statusline_mode = dmode
  endif
  return dmode
endfunction

function! Winnr(...) abort
      return '%{Kernosvim_mode(mode())} %{ Kernosvim_bubble_num(get(w:, "winid", winnr()), g:kernosvim_windows_index_type) } %{Kernosvim_mode_text(mode())}'
endfunction

let s:registed_sections = {
      \ 'winnr' : function('Winnr'),
      \ 'filename' : function('s:filename'),
      \ 'fileformat' : function('s:fileformat'),
      \ 'filetype' : function('s:type_of_file'),
      \ 'minor mode lighters' : function('s:modes'),
      \ 'version control info' : function('s:git_branch'),
      \ 'hunks' : function('s:hunks'),
      \ 'cursorpos' : function('s:cursorpos'),
      \ 'syntax checking' : function('s:syntax_checking'),
      \ 'percentage' : function('s:percentage'),
      \ 'battery status' : function('s:battery_status'),
      \ }

function! s:kernosvim_statusline_build_check_width(len, sec, winwidth) abort
  return a:len + s:kernosvim_statusline_build_len(a:sec) < a:winwidth
endfunction

function! s:kernosvim_statusline_build_len(sec) abort
  let str = matchstr(a:sec, '%{.*}')
  if !empty(str)
    return len(a:sec) - len(str) + len(eval(str[2:-2])) + 4
  else
    return len(a:sec) + 4
  endif
endfunction

function! s:kernosvim_statusline_build_eval(sec) abort
  return substitute(a:sec, '%{.*}', '', 'g')
endfunction

function! s:kernosvim_statusline_build(left_sections, right_sections, lsep, rsep, hi_a, hi_b, hi_c, hi_z, winwidth) abort
  let l = '%#' . a:hi_a . '#' . a:left_sections[0]
  let l .= '%#' . a:hi_a . '_' . a:hi_b . '#' . a:lsep
  let flag = 1
  let len = 0
  for sec in filter(a:left_sections[1:], '!empty(v:val)')
    if s:kernosvim_statusline_build_check_width(len, sec, a:winwidth)
      let len += s:kernosvim_statusline_build_len(sec)
      if flag == 1
        let l .= '%#' . a:hi_b . '#' . sec
        let l .= '%#' . a:hi_b . '_' . a:hi_c . '#' . a:lsep
      else
        let l .= '%#' . a:hi_c . '#' . sec
        let l .= '%#' . a:hi_c . '_' . a:hi_b . '#' . a:lsep
      endif
      let flag = flag * -1
    endif
  endfor
  let l = l[:len(a:lsep) * -1 - 1]
  if empty(a:right_sections)
    if flag == 1
      return l . '%#' . a:hi_c . '#'
    else
      return l . '%#' . a:hi_b . '#'
    endif
  endif
  if flag == 1
    let l .= '%#' . a:hi_c . '_' . a:hi_z . '#' . a:lsep . '%='
  else
    let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:lsep . '%='
  endif
  let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:rsep
  let flag = 1
  for sec in filter(a:right_sections, '!empty(v:val)')
    if s:kernosvim_statusline_build_check_width(len, sec, a:winwidth)
      let len += s:kernosvim_statusline_build_len(sec)
      if flag == 1
        let l .= '%#' . a:hi_b . '#' . sec
        let l .= '%#' . a:hi_c . '_' . a:hi_b . '#' . a:rsep
      else
        let l .= '%#' . a:hi_c . '#' . sec
        let l .= '%#' . a:hi_b . '_' . a:hi_c . '#' . a:rsep
      endif
      let flag = flag * -1
    endif
  endfor
  return l[:-4]
endfunction

function! s:inactive() abort
  let l = '%#KernosVim_statusline_ia#' . Winnr() . '%#KernosVim_statusline_ia_KernosVim_statusline_b#' . s:lsep . '%#KernosVim_statusline_b#'
  let secs = [s:filename(), " " . &filetype, s:modes(), s:git_branch()]
  let base = 10
  for sec in filter(secs, '!empty(v:val)')
    let len = s:kernosvim_statusline_build_len(sec)
    let base += len
    let l .= '%{ get(w:, "winwidth", 150) < ' . base . ' ? "" : (" ' . s:kernosvim_statusline_build_eval(sec) . ' ' . s:ilsep . '")}'
  endfor
  if get(w:, 'winwidth', 150) > base + 10
    let l .= join(['%=', '%{" " . &ff . "|" . (&fenc!=""?&fenc:&enc) . " "}', ' %P '], s:irsep)
  endif
  return l
endfunction

function! s:active() abort
  let lsec = []
  for section in s:kernosvim_statusline_left_sections
    if has_key(s:registed_sections, section)
      call add(lsec, call(s:registed_sections[section], []))
    endif
  endfor
  let rsec = []
  for section in s:kernosvim_statusline_right_sections
    if has_key(s:registed_sections, section)
      call add(rsec, call(s:registed_sections[section], []))
    endif
  endfor
  return s:kernosvim_statusline_build(lsec, rsec, s:lsep, s:rsep, 
        \ 'KernosVim_statusline_a', 'KernosVim_statusline_b', 'KernosVim_statusline_c', 'KernosVim_statusline_z', winwidth(winnr()))
endfunction

function! Kernosvim_statusline_get(...) abort
  for nr in range(1, winnr('$'))
    call setwinvar(nr, 'winwidth', winwidth(nr))
    call setwinvar(nr, 'winid', nr)
  endfor
  if &filetype ==# 'nerdtree'
    return '%#KernosVim_statusline_ia#' . Winnr() . '%#KernosVim_statusline_ia_KernosVim_statusline_b#' . s:lsep
          \ . '%#KernosVim_statusline_b# nerdtree %#KernosVim_statusline_b_KernosVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'vim-plug'
    return '%#KernosVim_statusline_a#' . Winnr() . '%#KernosVim_statusline_a_KernosVim_statusline_b#' . s:lsep
          \ . '%#KernosVim_statusline_b# PlugManager %#KernosVim_statusline_b_KernosVim_statusline_c#' . s:lsep
  elseif &filetype ==# 'denite'
    return '%#KernosVim_statusline_a_bold# %{Denite_mode()} '
          \ . '%#KernosVim_statusline_a_bold_KernosVim_statusline_b#' . s:lsep . ' '
          \ . '%#KernosVim_statusline_b#%{denite#get_status_sources()} %#KernosVim_statusline_b_KernosVim_statusline_z#' . s:lsep . ' '
          \ . '%#KernosVim_statusline_z#%=%#KernosVim_statusline_c_KernosVim_statusline_z#' . s:rsep
          \ . '%#KernosVim_statusline_c# %{denite#get_status_path() . denite#get_status_linenr()}'
  elseif &filetype ==# 'SpaceVimFlyGrep'
    return '%#KernosVim_statusline_a_bold# FlyGrep %#KernosVim_statusline_a_KernosVim_statusline_c#' . s:lsep
          \ . '%#KernosVim_statusline_c# %{getcwd()} %#KernosVim_statusline_c_KernosVim_statusline_b#' . s:lsep
          \ . '%#KernosVim_statusline_b# %{SpaceVim#plugins#flygrep#lineNr()}'
  elseif &filetype ==# 'help'
    return '%#KernosVim_statusline_a# HelpDescribe %#KernosVim_statusline_a_KernosVim_statusline_b#'
  endif
  if a:0 > 0
    return s:active()
  else
    return s:inactive()
  endif
endfunction

function! Kernosvim_statusline_init() abort
  augroup kernOSVim_statusline
    autocmd!
    autocmd BufWinEnter,WinEnter,FileType
          \ * let &l:statusline = Kernosvim_statusline_get(1)
    autocmd BufWinLeave,WinLeave * let &l:statusline = Kernosvim_statusline_get()
    autocmd ColorScheme * call Kernosvim_statusline_def_colors()
  augroup END
endfunction

call Kernosvim_statusline_init()
"}}}

"{{{ Theme & Colors
syntax on
set t_Co=256
set background=dark
colorscheme gruvbox
"let g:gruvbox_contrast_dark = 'soft'
set guifont=MesloLGMDZ\ Nerd\ Font:h12
" it sets tilde symbols to bg color
hi! EndOfBuffer ctermfg=bg
hi! FoldColumn ctermbg=bg
"}}}
"}}} Appareance

"{{{ IDE options
"{{{ Denite

" denite option
let s:denite_options = {
      \ 'default' : {
      \ 'winheight' : 15,
      \ 'mode' : 'insert',
      \ 'post-action' : 'quit',
      \ 'highlight_matched_char' : 'MoreMsg',
      \ 'highlight_matched_range' : 'MoreMsg',
      \ 'direction': 'rightbelow',
      \ 'statusline' : has('patch-7.4.1154') ? v:false : 0,
      \ 'prompt' : '>'
      \ }}

function! s:profile(opts) abort
  for fname in keys(a:opts)
    for dopt in keys(a:opts[fname])
      call denite#custom#option(fname, dopt, a:opts[fname][dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

" buffer source
call denite#custom#var(
      \ 'buffer',
      \ 'date_format', '%m-%d-%Y %H:%M:%S')

call denite#custom#alias('source', 'file_rec/git', 'file_rec')

" FIND and GREP COMMANDS
if executable('rg')
  " Ripgrep command on grep source
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

elseif  executable('pt')
  " Pt command on grep source
  call denite#custom#var('grep', 'command', ['pt'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--nogroup', '--nocolor', '--smart-case'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
        \ [ '--vimgrep', '--smart-case' ])
elseif executable('ack')
  " Ack command
  call denite#custom#var('grep', 'command', ['ack'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--match'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
        \ ['--ackrc', $HOME.'/.config/ackrc', '-H',
        \ '--nopager', '--nocolor', '--nogroup', '--column'])
endif

" KEY MAPPINGS
let s:insert_mode_mappings = [
      \  ['jk', '<denite:enter_mode:normal>', 'noremap'],
      \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
      \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
      \  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
      \  ['<C-c>', '<denite:enter_mode:normal>', 'noremap'],
      \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
      \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
      \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
      \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
      \  ['<C-Y>', '<denite:redraw>', 'noremap'],
      \ ]

let s:normal_mode_mappings = [
      \   ["'", '<denite:toggle_select_down>', 'noremap'],
      \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
      \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
      \   ['gg', '<denite:move_to_first_line>', 'noremap'],
      \   ['st', '<denite:do_action:tabopen>', 'noremap'],
      \   ['sg', '<denite:do_action:vsplit>', 'noremap'],
      \   ['sv', '<denite:do_action:split>', 'noremap'],
      \   ['q', '<denite:quit>', 'noremap'],
      \   ['r', '<denite:redraw>', 'noremap'],
      \ ]

for s:m in s:insert_mode_mappings
  call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
  call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

nnoremap <silent> <C-j>s :Denite file_rec<CR>
nnoremap <silent> <C-j>l :Denite buffer -mode=normal<CR>
nnoremap <silent> <C-j>g :FlyGrep<CR>
"}}}

"{{{ Spaces & Tabs
" Indentation options by default
set autoindent			" Copy the indentation from current line when starting a new line
set expandtab			" When enabled, causes spaces to be used in place of tab characters
set tabstop=2           " Specifies the width of a tab character
set softtabstop=2       " When enabled, fine tunes the amount of whitespace to be inserted
set shiftwidth=2  	    " Determines the amount of whitespace to insert or remove using indentatioin when you press >>, << or ==
                        " It also affects how automatic indentation works with smarttab
"}}}

"{{{ Searching
set hlsearch						" occurrences searched will be highlighted
"set incsearch
"}}}

"{{{ Deoplete
set completeopt=longest,menuone,preview " auto complete setting
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns['default'] = '\h\w*'
let g:deoplete#omni#input_patterns = {}
"let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
"let g:deoplete#sources#go#align_class = 1
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)
inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
let g:LanguageClient_serverCommands = {
    \ 'go': ['go-langserver'],
    \ 'c': ['clangd'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"}}}

"{{{ Vim-multiple-cursors
" Default mapping disable
function! Multiple_cursors_before()
    let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
    let b:deoplete_disable_auto_complete = 0
endfunction

let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<C-c>'
let g:multi_cursor_exit_from_insert_mode=0
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

function! Kernosvim_quickfix_toggle() abort
    let nr = winnr()
    lopen
    let nr2 = winnr()
    if nr == nr2
        lclose
    endif
endfunction

let g:neomake_open_list = 0
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
    \ 'text': '|',
    \ 'texthl': 'NeomakeErrorSign',
    \ }
let g:neomake_warning_sign = {
    \ 'text': '|',
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
let g:vim_json_syntax_conceal = 0
"}}}
"}}}

"{{{ Mapping keys
" Tagbar
nnoremap <silent> <leader>t :TagbarToggle<CR>

" NERDTree
nnoremap <silent> <C-j>j :NERDTreeToggle<CR>

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
    autocmd FileType go nnoremap <silent> <C-j>e :call Kernosvim_quickfix_toggle()<CR>
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
    autocmd FileType go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=0
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
    autocmd FileType json setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4 foldlevel=99 foldmethod=syntax foldnestmax=2 foldcolumn=0
augroup END

augroup MakeFiles
    autocmd!
    autocmd FileType make setlocal noexpandtab tabstop=4 softtabstop=4  shiftwidth=4
augroup END
"}}}
