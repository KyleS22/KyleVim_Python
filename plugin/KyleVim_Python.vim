" Make sure this plugin is runnable

let g:kyle_vim_python_version = "0.4.3"

if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif


filetype plugin on

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')


" Automatic File Headers
autocmd bufnewfile *.py execute "so " . s:plugin_root_dir . "/python_header.txt"
autocmd bufnewfile *.py exe "1," . 10 . "g/File Name:.*/s//File Name: " .expand("%:t")
autocmd bufnewfile *.py exe "1," . 10 . "g/Date:.*/s//Date: " .strftime("%d-%m-%Y")


