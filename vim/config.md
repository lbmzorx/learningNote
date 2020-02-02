# 1.�ļ�����

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
set fileencoding=gb18030
set fileencodings=utf-8,gb18030,utf-16,big5

set langmenu=zh_CN
let $LANG='zh_CH.UTF-8'
language messages zh_CN.UTF-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
source $VIMRUNTIME/mswin.vim
behave mswin

" �ر�����
set vb t_vb=

"1 ��������
set encoding=utf-8
set cindent "C ���
set fileformats=unix "�ļ�����ѡ��unix
set showcmd " չʾ����
set showmode "�ڵײ���ʾ����ǰ��������ģʽ���ǲ���ģʽ
set mouse=  " �ر����
set wrap " �����Զ����У� һ�в�������չʾ

" ��������
set noerrorbells
set novisualbell
set t_vb=
set so=5 " ���ù���ڵ�5��������ʾ

"3 ����
set autoindent "���»س�������һ�е��������Զ�����һ�е���������һ��
set smartindent "��������ʱʹ�������Զ�����
set expandtab	"���� Tab ���ڲ�ͬ�ı༭��������һ�£��������Զ��� Tab תΪ�ո�
set softtabstop=4 "Tab תΪ���ٸ��ո�
set shiftwidth=4 "���ı��ϰ���>>������һ����������<<��ȡ��һ������������==��ȡ��ȫ��������ʱ��ÿһ�����ַ���

"4 ��۵�
set tabstop=4
"set cursorline "������ڵĵ�ǰ�и���
"set textwidth=120 "�����п���һ����ʾ���ٸ��ַ�
set colorcolumn=120 "������ʾ��120���ַ�
"hi ColorColumn guifg=#8eb9f5 
				"��ʾ����ɫ ��Ҫ����colorscheme ����
set laststatus=2 "��ʾ״̬�� (Ĭ��ֵΪ 1, �޷���ʾ״̬��)
set ruler    	"��״̬����ʾ���ĵ�ǰλ�ã�λ����һ����һ��
set guifont=Monaco:h14 "��������ʹ�С

"5 ����
set showmatch "�������Բ���š������š�������ʱ���Զ�������Ӧ����һ��Բ���š������źʹ�����
set hlsearch "������ʾ �������ַ����ǣ��ҵ��������ʾ��
set noincsearch "�������������ַ���ͬʱ�Ϳ�ʼ�����Ѿ�����Ĳ���
set smartcase "Сд���� ���Դ�Сд���д�д��ȷƥ��
" set incsearch "�������������ַ���ͬʱ�Ϳ�ʼ�����Ѿ�����Ĳ���
"set ignorecase "����ʱ���Դ�Сд

"6 �༭
" set spell spelllang=en_us "��Ӣ�ﵥ�ʵ�ƴд���
set history=1000 "��Ҫ��ס���ٴ���ʷ����
set autoread "���ļ����ӡ�����ڱ༭�������ļ������ⲿ�ı䣨���类��ı༭���༭�ˣ����ͻᷢ����ʾ
set listchars=tab:�0�3��,trail:�� " �����β�ж���Ŀո񣨰��� Tab �����������ý�����Щ�ո���ʾ�ɿɼ���С����
set list
set wildmenu				   "����ģʽ�£��ײ�����ָ��� Tab ���Զ���ȫ����һ�ΰ��� Tab������ʾ����ƥ��Ĳ���ָ����嵥
set wildmode=longest:list,full "�ڶ��ΰ��� Tab��������ѡ�����ָ�
" vim�˸����backspace���޷�ʹ�õĽ������ https://www.jianshu.com/p/159b01325e61
" https://blog.csdn.net/u011475134/article/details/76216145
" indent: �������:set indent,:set ai ���Զ������������˸�����ֶ�������ɾ���������������ѡ�������Ӧ��
" eol:�������ģʽ�����п�ͷ����ͨ���˸���ϲ����У���Ҫ����eol��
" start��Ҫ��ɾ���˴β���ǰ�����룬�����������
set nocompatible " ��Ҫʹ��vi�ļ���ģʽ������vim�Լ���
set backspace=indent,eol,start "

filetype indent on
filetype on


" 6 ���
execute pathogen#infect()
syntax on
filetype plugin on
filetype plugin indent on

" Bundle 'majutsushi/tagbar'
" tagbar ʹ��tagbar���
" https://www.oschina.net/news/78490/vim-editor-plugins-for-software-developers-1
" https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
"
" ��� snazzy ����
" https://github.com/connorholyday/vim-snazzy
colorscheme snazzy
"let g:SnazzyTransparent = 1
set background=dark

nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_right=1
let g:tagbar_ctags_bin='/d/ProgramFiles/ctags/ctags'
let g:tagbar_width = 30

" NERDTree
" https://segmentfault.com/a/1190000015143474
map <F3> :NERDTreeToggle<CR>
let NERDTreeWinSize=40

" php�﷨���
" :
let g:PHP_SYNTAX_CHECK_BIN = '/d/phpStudy/php/php-7.0.12-nts/php'
"  au FileType php call PHPFuncList()
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" go code
imap <F6> <C-x><C-o>


" supertab �Զ���ȫ
"let g:SuperTabMappingForward=""
let g:SuperTabMappingForward = "<tab>"
let g:SuperTabMappingBackward= "s-tab"
let g:SuperTabRetainCompletionType=2

" go ���Զ��﷨���
" None of these worked:
" autocmd BufWritePre,FileType go Fmt
" autocmd BufWritePre,FileType go :Fmt

" php�ر��Զ��۵�
" PIV
let g:DisableAutoPHPFolding = 1

" �Զ�ע��
let mapleader=","


" �Զ����ݼ�
map <tab> <C-x><C-o>
```

# 2.���

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
## 2.1 �����ַ


https://github.com/boydos/emmet-vim.git
https://github.com/yegappan/grep.git
https://github.com/davidhalter/jedi-vim.git
https://github.com/scrooloose/nerdtree.git
https://github.com/klen/python-mode.git
https://github.com/ervandew/supertab
https://github.com/Blackrush/vim-gocode.git
https://github.com/plasticboy/vim-markdown.git
