" Make sure this plugin is runnable

let g:kyle_vim_python_version = "0.0.0"

if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif

if exists('g:KyleVim_Python_plugin_loaded')
	finish
endif


let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')

filetype plugin on

" --------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
" --------------------------------------------------------------------------------
set expandtab           " enter spaces when tab is pressed
set textwidth=120       " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
"set autoindent          " copy indent from current line when starting a new line
filetype indent plugin on
set smartindent

" Syntax highlighting for self"
:syn keyword pythonBuiltin self

" Load the python modules
python3 << EOF

import sys
from os.path import normpath, join
import vim

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '../..', 'python'))
sys.path.insert(0, python_root_dir)

import kyle_vim_python

EOF


let g:KyleVim_Python_plugin_loaded = 1
