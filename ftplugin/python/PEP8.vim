
" Allow the pycodestyle command to be overwritten in the user's vimrc
if !exists("g:pep8_command")
    let g:pep8_command = "pycodestyle"
endif

" Allow the pyflake command to be overwritten  in the user's vimrc
if !exists("g:pyflake_command")
	let g:pyflake_command = "pyflakes"
endif

set number

if !exists('g:KyleVim_Python_Disable_NumberHl')
	set cursorline
        hi cursorline cterm=none ctermbg=none
endif

" highlight groups for PEP8
hi PyFlakeError ctermfg=0 ctermbg=124
hi PEP8Warn ctermfg=0 ctermbg=11
hi PEP8Gut ctermfg=11 ctermbg=none
sign define warn text=8 texthl=PEP8Gut
" Check the PEP8 styling of the file
function! CheckPep8()

    	let pep_report = systemlist(g:pep8_command . " " . bufname("%"))
	
    	for msg in pep_report
        	
		" Add the message to the quickfix list
		caddexpr msg

		" Split the message into useful parts
        	let msg_parts = split(msg, ":")

		if len(msg_parts) < 3

			continue
		endif

        	let line_num = msg_parts[1]
        	let char_num = msg_parts[2]
		

		" Get the offending line	
        	let bad_line = getline(line_num)
       			
		" Highlight the offending line
           	"let m = matchadd('PEP8Warn', bad_line)
		exe ":sign place 2 line=" . line_num ." name=warn file=" . expand("%:p")

	endfor
endfunction

" Check for python syntax errors
function! CheckPythonSyntax()
	
	let flake_report = systemlist(g:pyflake_command . " " . bufname("%"))
	
	for msg in flake_report
	
		" Make sure the message is valid
		if stridx(msg, bufname("%")) > -1
						
			let msg_parts = split(msg, ":")
			
			" Get the offending line number
			let line_num = msg_parts[1]
			let description = msg_parts[2]
			
	
			" Jenk fix for bug in flake8
			if description =~ "undefined name 'IOException'"
				continue
			endif
			
			" Add the message to the quickfix list	
			caddexpr msg

			" Get the offending line
			let bad_line = getline(line_num)
			let bad_line = CleanLine(bad_line)

			" Add highlighting to the offending line	
			"let m = matchadd('PyFlakeError', bad_line)\
			exe ":sign place 2 line=" . line_num ." name=Vu_error file=" . expand("%:p")

		endif
	endfor

endfunction

" Clean the bad line for instances of ']', which apparently messes up
" matchadd()
function! CleanLine(line)
	
	return substitute(a:line, "]", "\\\\]", "")

endfunction


function! RunCodeChecks()
	
	if !filereadable(bufname("%"))
		return
	endif

	call clearmatches()
	cexpr []
	exe "sign unplace * file=" . expand("%:p")

	call CheckPep8()
	call CheckPythonSyntax()
endfunction

" Check PEP8 when the file is opened or saved
autocmd BufWinEnter <buffer> call RunCodeChecks()
autocmd BufWritePost <buffer> call RunCodeChecks()

" Remove unwanted whitespace
autocmd BufWritePre <buffer> %s/\s\+$//e


" 79 character column line
if !exists("g:KyleVimPython_Disable_ColorCol") && exists('+colorcolumn')
        set colorcolumn=79
endif


