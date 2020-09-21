" GENERAL
set fenc=utf-8  " 文字コードを UTF-8 に設定
set nrformats=  " すべての数を10進数として扱う
set nobackup  " ファイルを上書きする前にバックアップを作ることを無効化
set noswapfile  " スワップファイルを作成しない
set autoread  " 編集中のファイルが変更されたら自動で読み直す
set showcmd  " ウィンドウの右下にまだ実行していない入力中のコマンドを表示
set virtualedit=block  " vim の矩形選択で文字がなくても右へ進める
set ambiwidth=double  " 全角文字専用の設定
set wildmenu  " wildmenuオプションを有効(vimバーからファイルを選択できる)
set noerrorbells  " エラーメッセージの表示時にビープ音を鳴らさない

set number  " 行番号の表示
set colorcolumn=80  " 80 桁を表示する
set cmdheight=2  " メッセージ表示欄を 2 行確保
set laststatus=2  " ステータス行を常に表示
set ruler  " 画面右下のカーソル位置表示
set display=lastline  " 省略されずに表示
set list  " 不可視文字を表示する
set listchars=tab:^\ ,trail:~  " 行末のスペースを可視化
set history=10000  " コマンドラインの履歴を10000件保存する
set guioptions-=T  " ツールバーを非表示にする
set guioptions+=a  " yでコピーした時にクリップボードに入る
set guioptions-=m  " メニューバーを非表示にする
set guioptions+=R  " 右スクロールバーを非表示
set nofoldenable  " 検索にマッチした行以外を折りたたむ(フォールドする)機能
set clipboard=unnamed,autoselect  " ヤンクでクリップボードにコピー
set showmatch  " 対応する括弧を強調表示


" SEARCH
set hlsearch  " 検索結果をハイライト表示
set ignorecase  " 検索するときに大文字小文字を区別しない
set incsearch  " 検索がファイル末まで進んだら、ファイル先頭から再び検索
set smartcase  " 小文字で検索すると大文字と小文字を無視して検索
set wrapscan  " 検索時に最後まで行ったら最初に戻る
set rtp+=/usr/local/opt/fzf  " vim 内で fzf を使う


" TAB
set expandtab  " タブ文字を半角スペースにする
set softtabstop=2  " タブキー押下時に挿入される文字幅を指定
set tabstop=2  " ファイル内にあるタブ文字の表示幅
set shiftwidth=2  " インデント幅


" INDENT
filetype plugin indent on  " filetype によって設定を変える
set autoindent  " 前の行と同じインデント
set cinoptions+=:0  " インデント方法の変更


" COLOR
colorscheme iceberg  " colorscheme を iceberg に設定
highlight ColorColumn ctermbg=7
hi Comment ctermfg=3
syntax on  " syntax highlight


" OTHERS
" テンプレートを読み込む
let g:sonictemplate_vim_template_dir = [
      \ '~/.vim/template'
      \]
autocmd BufNewFile *.py 0r $HOME/.vim/template/python.txt  " template for Python

" auto reload .vimrc
augroup source-vimrc
  autocmd!
  autocmd BufWritePost *vimrc source $MYVIMRC | set foldmethod=marker
  autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
augroup END

" auto comment off
augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END

nmap <Esc><Esc> :noh <CR>
noremap ZZ <Nop>
noremap ZQ <Nop>
noremap Q <Nop>
noremap <Space>h ^
noremap <Space>l $
nnoremap <Space>/ *

" s で削除した文字をヤンクしない
nnoremap s "_s

inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>

abbrev sbp3 #!/usr/bin/env python3
