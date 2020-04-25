zz   光标移动到屏幕中间  有用
:set rnu  设置 相对行号，不太用  set nornu

" 分屏
:res  +5 分屏时候左右窗口增加

" tab标签页切换
map tn :tabnex<CR>  "下一个标签  与 gt 相同
map tk :-tabnex<CR> "前一个 标签
map tj :+tabnex<CR> " 后一个 标签
map th :tabfir<CR> "最前面一个 标签
map tl :tablast<CR> "最后面一个 标签

let &t_ut='' " 某些终端配色不对
" 终端下 不同模式光标样式
let &t_SI= "\<Esc>]50;CursorShap=1\x7"
let &t_SR= "\<Esc>]50;CursorShap=2\x7"
let &t_EI= "\<Esc>]50;CursorShap=0\x7"

set autochdir "  'autochdir' 'acd' 'noautochdir' 'noacd'
"  When on, Vim will change the current working directory whenever you
" open a file, switch buffers, delete a buffer or open/close a window.
