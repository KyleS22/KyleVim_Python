" Make sure this plugin is runnable


if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif

if exists('g:KyleVim_Python_plugin_loaded')
	finish
endif


let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')

filetype plugin on

" PEP8 file settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix


" Syntax highlighting for self"
:syn keyword pythonBuiltin self



" TODO: Remove this and replace with vimscript functions to call python
" functionality
"
" Load the python modules
python3 << EOF

import sys
from os.path import normpath, join
import vim

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '../..', 'python'))
sys.path.insert(0, python_root_dir)

import kyle_vim_python
import auto_docstring
EOF


" Auto docstrings
" Insert an auto populated docstring at lineNum
function! InsertDocstring(lineNum)
	python3 import sys
	python3 sys.argv = [vim.eval('a:lineNum')]
	python3 auto_docstring.insert_docstring(sys.argv[0])
endfunction

command! -nargs=1 InsertDocstring call InsertDocstring(<f-args>)

" Map <C-b> to insert docstring for the current function
nnoremap <C-b> :call InsertDocstring(line("."))<CR>
inoremap <C-b> <ESC>:call InsertDocstring(line("."))<CR>I


let g:KyleVim_Python_plugin_loaded = 1
