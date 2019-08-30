
" Find functions and classes that do not have docstrings
function! FindUndocumentedFunctions()
	/\(def .*:\_s*\|class .*:\_s*\)\&\(.*def .*:\_s*\"\|class .*:\_s*\"\)\@!
endfunction

" Map to F4
imap <F4> <Esc> :call FindUndocumentedFunctions()<CR>
map <F4> :call FindUndocumentedFunctions()<CR>
