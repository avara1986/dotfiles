set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"=============================================================================
" PEP8 Indent
Plugin 'Vimjas/vim-python-pep8-indent'

" would conflict otherwise
let g:pymode_indent = 0

"=============================================================================
" Colorized parenthesis

Plugin 'junegunn/rainbow_parentheses.vim'

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']']]

" ========================================================
" === BASIC CONFIGURATION  ===============================
" ========================================================

behave xterm
syntax on
filetype plugin indent on
set nocompatible

set vb t_vb=                   " no bells please
set novisualbell
set noerrorbells               " idem
"set list  lcs=tab:»·,eol:¬      show invisible characters line newline or tabs
set switchbuf=usetab,newtab    " switch to a buffer opened on a tab switches to that tab
set history=200
set viminfo='50,\"50
set modeline                   " enable per-file modelines
set modelines=5
set undofile
set undolevels=1000
set undoreload=10000
set backspace=start,indent,eol
set encoding=utf-8
set scrolloff=5                " minimal number of lines above or below the cursor
set showcmd
set ruler
set hidden                     " allow to change buffers even if current is unsaved
set showmode
set showtabline=1
set guitablabel=\[%N\]\ %t     " Nice format for the tabs, with number and filename
set wildmenu
set nobackup
set nowritebackup
set noswapfile
set ignorecase
set smartcase           " Case insensitive search with lowercase terms, sensitive with uppercase
set hlsearch              " highlight search results
set showmatch
set gdefault            " default to global substitution, without having to put the /g at the end
set relativenumber      " show relative line numbers
set number              " but show the current linenum at the center
set virtualedit=block   " can select anything inside visual block mode (v + ctrl-v)
set cursorline          " highlight the line with the cursor
set autochdir           " change the cwd to the buffer
set undodir="$VIMRUNTIME\\undodir"
set wildignore+=.git\*,.hg\*,.svn\*,.bzr\*
set mouse+=a
set timeout timeoutlen=5000 ttimeoutlen=100 " wait longer for commands

" Colors related settings
set termguicolors       " true color
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"set t_Co=256            " more colors
"set term=xterm-256color
let &t_ut=''            " this is needed so the background is correctly shown under tmux
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" when opening a buffer, jump to the last known position
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif

" automatically strip trailing whitespace
 fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
 endfun

autocmd FileType c,cpp,java,php,ruby,python,go,nim,d,java autocmd BufWritePre <buffer>
            \ :call <SID>StripTrailingWhitespaces()

 " Dont go back 1 character when leaving insert mode
 au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

" Use CTRL-S for saving, also in Insert mode
noremap  <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" =========================================================
" === TABS, INDENTATION AND FORMATTING ====================
" =========================================================

" default line length, can be changed depending on the filemode
let my_linelen = 82
set colorcolumn=80  " color text written past the column

" 4 space tabs, anything else is wrong
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent

autocmd FileType c setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2

set nowrap
set wh=12

" justify comments inside code; start the next line after a comment as a comment
set formatoptions=qrn
set copyindent        " copy the indentation of the previous line
set foldmethod=indent " fold by indentation (except for python, see below)
set foldnestmax=2     " ...but not more than two levels (class and method)
set foldlevel=99      " start with everything unfolded

function! SetLineLengthOptions(len)
    let &l:tw = a:len
    let &l:colorcolumn = a:len
endfunction

au BufNewFile,BufRead,BufEnter *.md,*.markdown,*.txt,*.me,*.ME,.article*,.followup,.letter*,mutt*
            \ call SetLineLengthOptions(80)
au BufNewFile,BufRead,BufEnter .vimrc,_vimrc,*.d,*.cpp,*.cc,*.py,*.js,*.go,*.nim,*.js,*.java,*.scala,*.rs,*.c,*.h,*.cpp,*.hpp
            \ call SetLineLengthOptions(90)

autocmd FileType html set formatoptions+=l

" Rename tabs to show tab number (change with [number]gt)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    highlight link TabNum Special
endif

" Format for the folded folds line
function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    "return line . '-' . repeat(" ",fillcharcount) . foldedlinecount . '-' . ' '
    return line . '   |' . foldedlinecount . ' lines|'
endfunction " }}}
set foldtext=MyFoldText()

" CleanBuffers will remove all empty buffers
function! s:CleanEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
    if !empty(buffers)
        exe 'bw ' . join(buffers, ' ')
    endif
endfunction
command! CleanBuffers call s:CleanEmptyBuffers()

" Distraction free write mode, based on: https://statico.github.io/vim3.html
function! s:WriteMode()
  call goyo#execute(0, [])
  setl spell noci nosi noai nolist noshowmode noshowcmd 
  setl colorcolumn=
  setl nocursorline
  setl complete+=s
  setl fo=aw2tq
  setl textwidth=80
  setl background=light
  colors juanjux-light
endfunction
command! WriteMode call s:WriteMode()

" =========================================================
" === SHORTCUTS ===========================================
" =========================================================

" Important: uncoment any set encoding line before adding new non-ASCII chars
" to vimrc, enable them after
" Vim Reminders:
" <c-o> and <c-i> jump between the history of cursor positions
" <c-o> run a single command while in insert mode
" '. jump to last insert position
" gi jump to last insert location and enter insert mode
" "* register clipboard (Windows)
" "+ register clipboard (Linux)
" "% register with buffer name (only for pasting)
" :goto n: go to the byte in the buffer
" gp paste and move the cursor to the end
" :pu or ,p paste below the current line
" P paste before the cursor
" f / F search for next / prev char in line
" t / T search for next / prev char in line, jump before it
" w start of next word (W for WORD)
" e end of next word (E for WORD)
" b start of prev word (B for WORD)
" d/[search] delete until [search] not including the search terms
" y/[search] yank until [search] not including the search terms
" */# search for next/prev occurrence of word under cursor
" 0/^/$ motions: start of line, start of text, end of line
" gg / G: motions: start of text, end of text
" I move to start of text and enter insert mode
" A move to end of line and enter insert mode (append)
" C change since cursor to the end of line
" cc change entire line
" o/O create new line below / above current
" z= see spelling suggestions for word under cursor
" ]s / [s jump to next / prev misspelled word
" zg add word to spellfile
" gn "select next search match", e.g. cgn deletes and insert on the next search match

" === BASIC ===
imap jk <Esc>
let mapleader = ","
" When I use a Spanish keyboard I still want to use these keys
" without pressing shift
"map - /
nmap ñ :
nmap Ñ :
"imap º <esc>
map ç ^
"nmap ¡ `

" map Tab/ShiftTab to next/prev tab
nmap <Tab>   gt
nmap <S-Tab> gT

" navigate trought wrapped lines easily
nmap j gj
nmap k gk

" w!! to save as root with sudo
cmap w!! w !sudo tee % >/dev/null<cr>

" === TAGS ===
nmap <leader>tg :set tags=tags<cr>
",ta jump to tag (also the default C-])
nnoremap <leader>ta <C-]>

" === TABS AND WINDOWS ===
" ,v (vsplit)
nmap <leader>v :vspl<cr><c-w><c-w>
" ,cv (close other vertical split)
nmap <leader>cv <c-w><c-w>:q<cr>

" ,tn (Tab New)
nmap <leader>tn :tabnew<cr>

" ,bt (buffer tabs) open all buffers as tabs
nnoremap <leader>bt :tab sball<cr>

",tl moves the tab one position to the left
nnoremap <leader>tl :tabm -1<cr>

",tr moves the tab one position to the right
nnoremap <leader>tr :tabm +1<cr>

" === COPY/PASTE ===
" Obvious shortcuts so I don't mess with C-V, C-C when using Vim along other
" programs that use these shortcuts for copy/paste (these copy/paste to the
" system clipboard)

vnoremap <C-X> "+x
vnoremap <C-C> "+y
map      <C-V> "+gP

" make paste also work in the command line
cmap <C-V> <C-R>+
exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" CTRL-A is Select all
noremap  <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Use CTRL-Q to do what CTRL-V used to do (block visual mode, escape chars in the command line, etc)
noremap <C-Q> <C-V>

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" ,p paste AFTER current line, useful when you're pasting several lines
nnoremap <leader>p :pu<cr>

" ,V will select the last pasted text
nnoremap <leader>V `[v`]

" The unnamed buffer (when you yank or cut without naming a register) is the clipboard
set clipboard+=unnamed
set clipboard+=unnamedplus

" === OTHER SHORTCUTS ===
" ,ct Clear Trailing : remove trailing whitespace after the end of line
nnoremap <leader>ct :%s/\s\+$//<cr>

" space and backspace pagedown/up
nnoremap <space> <c-f>
nnoremap <bs> <c-b>

" ,sv reload .vimrc
nmap <leader>sv :so $MYVIMRC<cr>

" ,rr: sometimes syntax highlighting fails and put everything as string, this reset it
nmap <leader>rr :syntax sync fromstart<cr>:redraw!<cr>

" Spellchecking:
" ,ss Spanish
" ,se English
" ,sn Disable
" z= to see suggestions
" ]s / [s jump to next/prev misspelled word
" zg add word to the spellfile
nmap <leader>ss :set termguicolors&<cr>:setlocal spell spelllang=es_es<cr>
nmap <leader>se :set termguicolors&<cr>:setlocal spell spelllang=en_en<cr>
nmap <leader>sn :set termguicolors<cr>:set nospell<cr>
" Download missing files from there
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

" some aliases for stupid fingers
nmap :W :w
nmap :q1 :q!
nmap :Q :q
nmap :Q! :q!
nmap :Q1 :q!
nmap :Qa :qa
nmap :QA :qa

" ,<space> to clean search results
nmap <leader><space> :noh<cr>

" ,yy show yanking registers
nnoremap <leader>yy :YRShow<cr>

" F1 = exit insert mode and save
inoremap <f1> <ESC>:w<cr>
nnoremap <f1> :w<cr>
vnoremap <f1> :w<cr>
inoremap <f2> <ESC>:bd!<cr>
nnoremap <f2> :bd!<cr>
vnoremap <f2> :bd!<cr>
inoremap <f3> <ESC>:QuickRun<cr>
nnoremap <f3> :QuickRun<cr>
vnoremap <f3> :QuickRun<cr>

" Netrw, and Tagbar toggles
nmap <leader>E :Vex<cr>
nmap <leader>tb :TagbarToggle<cr>

" ,gs (Guarda Sesion) save vim session, ,css (Carga Sesion), load it
nmap <leader>gs :mksession! ~\.vim\session\default<cr>
nmap <leader>css :source ~\.vim\session\default<cr>

" ,sp, ,snp set paste, set no paste modes
nmap <leader>sp :set paste<cr>
nmap <leader>np :set nopaste<cr>

" ,1 Put === lines above and below the current line
nnoremap <leader>1 yyPVr=jyypVr=k

" <leader>cp copy the current path to the system clipboard
nmap <leader>cp :let @+ = expand("%:p:h")<cr>:echo @+<cr>

" Replace the timestamp under cursor for a date. Must be a "word" so separate


" so separate
" using spaces or other word delimiters before calling it
nmap <leader>ts <esc>"mciw<c-r>=strftime("%d/%m/%y %H:%M:%S", @m)

" =========================================================
" === COLORS, FONTS AND GUI ===============================
" =========================================================

"hi NonText guifg=#b2b2b2

" Uncomment the first like of every block for setting the right background
" and then the specific colorscheme

"set background=light
"colors calm_light
"colors gruvbox
"colors professional_jjux
"colors juanjux-light
"colors summerfruit

set background=dark
"colors obsidian
"colors northsky
"colors jelleybeans
colors molokai
"colors monokain
"colors chroma
"let g:solarized_termcolors=256
"colors solarized
"colors flattened_dark

" EasyMotion Colors
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment
hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second Define

" ,e jump to word
nmap <leader>e <Plug>(easymotion-overwin-w)
" ,f easy motion search character
nmap <leader>f <Plug>(easymotion-overwin-f)

" GVIM options:

" Font
" On gvim we can use :set guifont=* to show a font picker window
" TIP for changing the font in the .vimrc: to get the guifont value copied to the current
" buffer as text do :put =&guifont   " Font
if has("gui_running")
    if has("gui_gtk2") || has("gui_gtk3") || has("gui_gnome")
        set guifont=Fira\ Code\ 9
    endif
endif

" Maximized initial screen
if has("gui_running")
  set lines=999 columns=999
endif

" Negated:
" !a: dont autocopy VISUAL regions to the clipboard
set guioptions-=a
" !T: dont show the toolbar
set guioptions-=T
" !i: dont use an icon
set guioptions-=i
" !e: dont use graphic tabs (they look nicer with text tabs can be reordered by dragging with the plugin)
set guioptions-=e
" !m: dont show menu bar
set guioptions-=m
" !h: dont use the cursorline as size reference for the horizontal scrollbar
set guioptions-=h

" Enabled:
" g: show inactive menu items greyed
set guioptions+=g
" r: show graphic scrollbar
set guioptions+=r
" b: show horizontal scrollbar
set guioptions+=b

" Only show the horizontall scrollbar when its actually needed:
" MaxWidth() - Return length of longest line in current buffer
function! <SID>MaxWidth()
  return max(map(range(1, line('$')), "virtcol([v:val, '$'])"))
endfunction

" TextWidth() - Return width of actual text area in current window
function! <SID>TextWidth()
  return winwidth(0) - &l:foldcolumn -
    \ ((&l:number || &l:relativenumber) ? &numberwidth : 0)
endfunction

" ToggleBottomScrollbar() - Toggle horizontal scrollbar on/off as required
function! <SID>ToggleBottomScrollbar()
  if !&l:wrap && <SID>MaxWidth() > <SID>TextWidth()
    if &l:guioptions !~# "b"
      setlocal guioptions+=b
    endif
  elseif &l:guioptions =~# "b"
    setlocal guioptions-=b
  endif
endfunction

augroup autoscrollbar
  au!
  au CursorHold * :call <SID>ToggleBottomScrollbar()
  au CursorHoldI * :call <SID>ToggleBottomScrollbar()
  au VimResized * :call <SID>ToggleBottomScrollbar()
augroup END

augroup filetypedetect
    au BufRead,BufNewFile *.py.source setfiletype python
    au BufRead,BufNewFile *.java.source setfiletype java
    " associate *.foo with php filetype
augroup END

" =========================================================
" === AUTOCOMPLETE ========================================
" =========================================================

" By language
"au BufNewFile,BufRead,BufEnter *.d  setf d
"autocmd filetype python set omnifunc=pythoncomplete#Complete
"autocmd filetype javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd filetype html set omnifunc=htmlcomplete#CompleteTags
"autocmd filetype css set omnifunc=csscomplete#CompleteCSS

" show omni menu even when there is only a single entry and don't autocomplete with the first one
set completeopt=longest,menuone,menu,noselect
set completeopt-=preview

" not infernal-pink color for the complete menu
highlight Pmenu guibg=brown gui=bold

" ========================================================
" === PLUGGIN POST-ACTIVATION STUFF   ====================
" ========================================================
" Only stuff that cant be activated on the initial plugin section

" Rainbow parenthesis
" call g:rainbow_parentheses#activate()

