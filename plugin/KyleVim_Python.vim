" Make sure this plugin is runnable

let g:kyle_vim_python_version = "0.0.0"

if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif


filetype plugin on


