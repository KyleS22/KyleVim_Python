
" Allow the pycodestyle command to be overwritten in the user's vimrc
if !exists("g:pep8_command")
    let g:pep8_command = "pycodestyle"
endif

" Allow the pyflake command to be overwritten  in the user's vimrc
if !exists("g:pyflake_command")
	let g:pyflake_command = "pyflakes"
endif

" highlight groups for PEP8
hi PyFlakeError ctermfg=232 ctermbg=124
hi PEP8Warn ctermfg=15 ctermbg=11

" Check the PEP8 styling of the file
function! CheckPep8()

    	let pep_report = systemlist(g:pep8_command . " " . bufname("%"))
	
    	for msg in pep_report
        
        	let msg_parts = split(msg, ":")
        	let line_num = msg_parts[1]
        	let char_num = msg_parts[2]
        	let description = msg_parts[3]

        
		let error_type = split(description, " ")[0]
	
        	let bad_line = getline(line_num)
       			
			

           	let m = matchadd('PEP8Warn', bad_line)

	endfor
endfunction

" Check for python syntax errors
function CheckPythonSyntax()
	
	let flake_report = systemlist(g:pyflake_command . " " . bufname("%"))

	for msg in flake_report
		
		echo msg	
		let msg_parts = split(msg, ":")

		let line_num = msg_parts[1]
		let description = msg_parts[2]

		let bad_line = getline(line_num)
		
		let m = matchadd('PyFlakeError', bad_line)
	endfor

endfunction

function RunCodeChecks()
	call clearmatches()

	call CheckPep8()
	call CheckPythonSyntax()
endfunction

" Check PEP8 when the file is opened or saved
autocmd BufWinEnter <buffer> call RunCodeChecks()
autocmd BufWritePost <buffer> call RunCodeChecks()

" TODO: Put the errors someplace that is readable when wanted
