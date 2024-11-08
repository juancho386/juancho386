"los comentarios se hacen con comillas dobles (¿?)
" let mapleader = ","
" el mapleader defult es \

nnoremap <leader>h :execute 'map <leader>'<cr>
nnoremap <leader>1 :set number!<cr>
nnoremap <leader>2 :set relativenumber!<cr>
nnoremap <leader>3 :set list!<cr>
nnoremap <leader>4 :set ai!<cr>

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

set tabstop=4
set shiftwidth=4
set softtabstop=0
set autoindent number relativenumber paste ai splitbelow splitright
set listchars=tab:»·,space:·,eol:$,trail:≈,extends:⌐,precedes:¬

nnoremap gbye oBest regards,<Esc>oJuan Nestares<Esc>
nnoremap gezequiel oEzekiel 25:17. "The path of the righteous man is beset on all sides by the inequities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of the darkness. For he is truly his brother's keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know I am the Lord when I lay my vengeance upon you."

