if !exists("g:pep8_command")
    let g:pep8_command = "pycodestyle"
endif


" highlight groups for PEP8
hi PEP8Error ctermfg=15 ctermbg=9
hi PEP8Warn ctermfg=15 ctermbg=11

" Check the PEP8 styling of the file
function! CheckPep8()

	call clearmatches()
    	let pep_report = systemlist(g:pep8_command . " " . bufname("%"))
	
    	for msg in pep_report
        
        	let msg_parts = split(msg, ":")
        	let line_num = msg_parts[1]
        	let char_num = msg_parts[2]
        	let description = msg_parts[3]

        
		let error_type = split(description, " ")[0]
	
        	let bad_line = getline(line_num)
       			
       		let error_char = split(error_type, '\zs')[0]
			
        	if error_char == "E"
			let m = matchadd('PEP8Error', bad_line)      
		else

           		let m = matchadd('PEP8Warn', bad_line)
        	endif

	endfor
endfunction

" Check PEP8 when the file is opened or saved
autocmd BufWinEnter <buffer> call CheckPep8()
autocmd BufWritePost <buffer> call CheckPep8()

" TODO: Put the errors someplace that is readable when wanted
