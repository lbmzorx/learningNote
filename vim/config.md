# 1.文件配置

```
syntax on
syntax enable
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set bg=dark
" colorscheme everning
set history=1000
set termencoding=utf-8

set fencs=utf-8,gbk,utf-16,utf-32,ucs-bom
" set fileencoding=gb18030
set fileencodings=utf-8,gb18030,utf-16,big5

" set langmenu=zh_CN
" let $LANG='zh_CH.UTF-8'
" language messages zh_CN.UTF-8
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim
" source $VIMRUNTIME/mswin.vim
" behave mswin

" 关闭闪屏
set vb t_vb=

"1 基本设置
set encoding=utf-8
set cindent "C 插件
set fileformats=unix "文件类型选择unix
set showcmd " 展示命令
set showmode "在底部显示，当前处于命令模式还是插入模式
set mouse=  " 关闭鼠标
set wrap " 设置自动换行， 一行不够两行展示

" 禁用铃声
set noerrorbells
set novisualbell
set t_vb=
set so=5 " 设置光标在第5行上下显示

"3 缩进
set autoindent "按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致
set smartindent "开启新行时使用智能自动缩进
set expandtab	"由于 Tab 键在不同的编辑器缩进不一致，该设置自动将 Tab 转为空格
set softtabstop=4 "Tab 转为多少个空格
set shiftwidth=4 "在文本上按下>>（增加一级缩进）、<<（取消一级缩进）或者==（取消全部缩进）时，每一级的字符数

"4 外观点
set tabstop=4
"set cursorline "光标所在的当前行高亮
"set textwidth=120 "设置行宽，即一行显示多少个字符
set colorcolumn=120 "设置提示线120个字符
"hi ColorColumn guifg=#8eb9f5 
				"提示线颜色 需要放在colorscheme 后面
set laststatus=2 "显示状态栏 (默认值为 1, 无法显示状态栏)
set ruler    	"在状态栏显示光标的当前位置（位于哪一行哪一列
set guifont=Monaco:h14 "设置字体和大小

"5 搜索
set showmatch "光标遇到圆括号、方括号、大括号时，自动高亮对应的另一个圆括号、方括号和大括号
set hlsearch "高亮显示 （查找字符串是，找到后高亮显示）
set noincsearch "在输入搜索的字符串同时就开始搜索已经输入的部分
set smartcase "小写搜索 忽略大小写，有大写则精确匹配
" set incsearch "在输入搜索的字符串同时就开始搜索已经输入的部分
"set ignorecase "搜索时忽略大小写

"6 编辑
" set spell spelllang=en_us "打开英语单词的拼写检查
set history=1000 "需要记住多少次历史操作
set autoread "打开文件监视。如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示
set listchars=tab:»■,trail:■ " 如果行尾有多余的空格（包括 Tab 键），该配置将让这些空格显示成可见的小方块
set list 		"来显示非可见字符
set wildmenu		"命令模式下，底部操作指令按下 Tab 键自动补全。第一次按下 Tab，会显示所有匹配的操作指令的清单
set wildmode=longest:list,full "第二次按下 Tab，会依次选择各个指令。
" vim退格键（backspace）无法使用的解决方法 https://www.jianshu.com/p/159b01325e61
" https://blog.csdn.net/u011475134/article/details/76216145
" indent: 如果用了:set indent,:set ai 等自动缩进，想用退格键将字段缩进的删掉，必须设置这个选项。否则不响应。
" eol:如果插入模式下在行开头，想通过退格键合并两行，需要设置eol。
" start：要想删除此次插入前的输入，需设置这个。
set nocompatible " 不要使用vi的键盘模式，而是vim自己的
set backspace=indent,eol,start "

filetype indent on
filetype on


" 6 插件
execute pathogen#infect()
syntax on
filetype plugin on
filetype plugin indent on

" Bundle 'majutsushi/tagbar'
" tagbar 使用tagbar插件
" https://www.oschina.net/news/78490/vim-editor-plugins-for-software-developers-1
" https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
"
" 插件 snazzy 主题
" https://github.com/connorholyday/vim-snazzy
colorscheme snazzy
"let g:SnazzyTransparent = 1
set background=dark

nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_right=1
let g:tagbar_ctags_bin='/d/ProgramFiles/ctags/ctags'
let g:tagbar_width = 30

" tarlist 
" https://github.com/vim-scripts/taglist.vim
let g:tagbar_width = 30
let g:tagbar_ctags_bin='/usr/bin/ctags' 
nmap <F8> :TagbarToggle<CR> 
nmap <leader>s :TagbarToggle<CR>

" " nerdtree  
" https://github.com/preservim/nerdtree 
" https://segmentfault.com/a/1190000015143474 
"
map <F9> :NERDTreeMirror<CR>  
map <leader>f :NERDTreeMirror<CR>
map <F9> :NERDTreeToggle<CR>
map <leader>d :NERDTreeToggle<CR>
let g:tagbar_ctags_bin='/usr/bin/ctags'     "ctags 程序的路径 
let g:tagbar_width=30              "窗口宽度设置为 30 
let g:tagbar_left=0                "设置在 vim 左边显示

" php语法检查
" :
let g:PHP_SYNTAX_CHECK_BIN = '/d/phpStudy/php/php-7.0.12-nts/php'
"  au FileType php call PHPFuncList()
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" go code
imap <F6> <C-x><C-o>


" supertab 自动补全
"let g:SuperTabMappingForward=""
let g:SuperTabMappingForward = "<tab>"
let g:SuperTabMappingBackward= "s-tab"
let g:SuperTabRetainCompletionType=2

" go 的自动语法检查
" None of these worked:
" autocmd BufWritePre,FileType go Fmt
" autocmd BufWritePre,FileType go :Fmt

" php关闭自动折叠
" PIV
let g:DisableAutoPHPFolding = 1

" 自动注释
let mapleader=","


" 自定义快捷键
map <tab> <C-x><C-o>
```

# 2.插件

```
delimitMate/
emmet-vim/
grep/
jedi-vim/
nerdtree/
python-mode/
supertab/
tagbar/
tlib_vim-master/
vim-addon-mw-utils-master/
vim-airline-master/
vim-fugitive-master/
vim-go-1.18/
vim-gocode/
vim-json-master/
vim-markdown/
vim-snazzy-master/
vim-snipmate-master/
```
## 2.1 插件地址


https://github.com/boydos/emmet-vim.git
https://github.com/yegappan/grep.git
https://github.com/davidhalter/jedi-vim.git
https://github.com/scrooloose/nerdtree.git
https://github.com/klen/python-mode.git
https://github.com/ervandew/supertab
https://github.com/Blackrush/vim-gocode.git
https://github.com/plasticboy/vim-markdown.git
