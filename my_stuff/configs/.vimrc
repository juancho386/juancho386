"los comentarios se hacen con comillas dobles (¿?)
" let mapleader = ","
" el mapleader defult es \

autocmd BufWritePost * :%s/\s\+$//e

autocmd BufWritePost *.tf silent! !terraform fmt %
autocmd BufWritePost *.tf e!
autocmd BufWritePost *.tf redraw!
augroup EnsureNewlineOnSave
  autocmd!
  autocmd BufWritePre * if getline('$') !=# '' | call setline(line('$')+1, '') | endif
augroup END

" Configuración de colores para Diff
highlight DiffAdd ctermfg=Green ctermbg=DarkGreen guifg=#00ff00 guibg=DarkGreen
highlight DiffChange ctermfg=Yellow ctermbg=Brown guifg=#ffff00 guibg=Brown
highlight DiffDelete ctermfg=Red ctermbg=DarkRed guifg=#ff0000 guibg=DarkRed
highlight DiffText ctermfg=Blue ctermbg=DarkBlue guifg=#0000ff guibg=DarkBlue


function! EncryptFile()
	let filename = input("Nombre del archivo encriptado: ")
	if filename == ""
		echo "No se proporcionó un nombre de archivo"
		return
	endif 
	let tmpfile = tempname()
	execute 'write! ' . tmpfile
	execute 'silent !openssl enc -e -aes-256-cbc -pbkdf2 -in ' . tmpfile . ' -out ' . filename . '.aes256cbc'
	call delete(tmpfile)
	echo "Archivo encriptado guardado como " . filename . '.aes256cbc'
endfunction


function! DecryptFile()
	let filename = input("Nombre del archivo encriptado: ",expand("*.aes256cbc"),"file")
	if filename == ""
		echo "No se proporcionó un nombre de archivo"
		return
	endif 
	let tmpfile = tempname()
	execute 'silent !openssl enc -d -aes-256-cbc -pbkdf2 -in ' . filename . ' -out ' . tmpfile
	"if todo bien: echo Archivo desencriptado and ...
	execute 'edit ' . tmpfile
	autocmd BufDelete <buffer> call delete(tmpfile)
	call delete(tmpfile)
endfunction


function! GitDiffSplit()
	let filename = expand('%')
	if filename == ""
		echo "No hay archivo abierto para comparar"
		return
	endif
	let tmpfile = tempname()
	call system('git show HEAD:' . filename . ' > ' . tmpfile)
	" Realiza el vertical diffsplit
	execute 'vertical diffsplit ' . tmpfile
	autocmd BufDelete <buffer> call delete(tmpfile)
endfunction





nnoremap <leader>h :execute 'map <leader>'<cr>
nnoremap <leader>n :set number!<cr>
nnoremap <leader>r :set relativenumber!<cr>
nnoremap <leader>l :set list!<cr>
nnoremap <leader>a :set ai!<cr>

" Split
nnoremap <leader>- :split<cr>
nnoremap <leader>\ :vertical split<cr>
nnoremap <leader><UP> :resize +3<cr>
nnoremap <leader><DOWN> :resize -3<cr>
nnoremap <leader><left> :vertical resize -3<cr>
nnoremap <leader><right> :vertical resize +3<cr>
nnoremap <leader>\| :vertical diffsplit
nnoremap <leader>> <C-w>h:diffput<cr>
nnoremap <leader>< <C-w>l:diffput<cr>

nnoremap <leader>W :call EncryptFile()<CR>
nnoremap <leader>O :call DecryptFile()<CR>
nnoremap <leader>gd :call GitDiffSplit()<CR>

nnoremap <leader><tab> :%s/    /\t/g<CR>

set tabstop=4
set shiftwidth=4
set softtabstop=0
set autowrite autoindent number relativenumber paste splitbelow splitright
set listchars=tab:»·,space:·,eol:$,trail:≈,extends:⌐,precedes:¬

nnoremap _b oBest regards,<Esc>oJuan Nestares<Esc>
nnoremap _e oEzekiel 25:17. "The path of the righteous man is beset on all sides by the inequities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of the darkness. For he is truly his brother's keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know I am the Lord when I lay my vengeance upon you."
nnoremap _s oVerdammte Scheiße!





