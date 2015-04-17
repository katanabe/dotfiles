""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  General                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" startify 
NeoBundle 'mhinz/vim-startify'


" vimproc
" - スクリプトの非同期実行
NeoBundle 'Shougo/vimproc.vim', {
            \'build': {
            \     'windows' : 'make -f make_wingw32.mak',
            \     'cygwin'  : 'make -f make_cygwin.mak',
            \     'mac'     : 'make -f make_mac.mak',
            \     'unix'    : 'make -f make_unix.mak',
            \    },
            \ }


" Unite
" - Unite本体
NeoBundle 'Shougo/unite.vim'
" - gitインタフェース
NeoBundle 'yuku-t/unite-git'
" - ソースのアウトライン表示
NeoBundle 'Shougo/unite-outline', {
            \ 'autoload' : {
            \   'filetypes' : ['c', 'cpp', 'markdown']
            \   }
            \ }
" - UniteMRU
NeoBundle 'Shougo/neomru.vim'
" - Uniteでhelp
NeoBundle 'Shougo/unite-help', {
            \ 'disabled' : 0
            \ }
" - Uniteでカラースキーム
NeoBundle 'ujihisa/unite-colorscheme'


" status bar
" - lightline 用のカラースキーム
NeoBundle 'cocopon/lightline-hybrid.vim'
" - ステータスバーをかっこ良く
NeoBundle 'itchyny/lightline.vim'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Color Scheme                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle "tomasr/molokai"



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Programming                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" YCM
"  - コード補完スクリプト
NeoBundle 'Valloric/YouCompleteMe', {
            \ 'build_commands' : 'cmake',
            \ 'build' : {
            \   'mac' : './install.sh --clang-completer',
            \   'unix' : './install.sh --clang-completer',
            \   },
            \ }


" Snippet
" - スニペット管理
NeoBundle 'SirVer/ultisnips'
" - デフォルトスニペット
NeoBundle 'honza/vim-snippets', {
            \ 'disabled' : 1,
            \ }


" Filer
" - ファイラ
NeoBundle 'Shougo/vimfiler', {'depends': 'Shougo/unite.vim'}


" Visual
" - ウィンドウ選択をビジュアルに
NeoBundle 't9md/vim-choosewin'


" document
" - リファレンスを見るためのプラグイン
NeoBundle 'thinca/vim-ref'


" Editor
" - surroundの変更を簡単に
NeoBundle 'tpope/vim-surround'
" - いろんな便利関数
" TODO: 関数リストがほしい
NeoBundle 'tpope/vim-unimpaired'
" - インデントを見やすくする
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {
            \ 'autoload' : {
            \   'filetypes' : ['python'],
            \   },
            \ }
" - 古くからある整形ツール
NeoBundle 'Align', {
            \ 'disabled' : 1,
            \ }
" - 使いやすそうな整形ツール
NeoBundle 'junegunn/vim-easy-align'
" - 他でも依存されてる整形ツール
NeoBundle 'godlygeek/tabular'
" - サポートされてるプラグインを.でリピートできるように
NeoBundle 'tpope/vim-repeat.git'
" - コメント追加/削除
NeoBundle 'tpope/vim-commentary'
" - レジスタの履歴を取得・再利用
NeoBundle 'LeafCage/yankround.vim'
" - バイナリエディタ
NeoBundle 'Shougo/vinarise.vim'
" - マークの表示
NeoBundle 'kshenoy/vim-signature'


" Motion
" - 簡単に移動ができるようにする
NeoBundle 'Lokaltog/vim-easymotion'
" - 置換対象がハイライトされて、プレビューされるように
NeoBundle 'osyo-manga/vim-over'
" - fの移動をもっと便利に
NeoBundle 'rhysd/clever-f.vim'


" Programming
" - シンタックスチェック
NeoBundleLazy 'scrooloose/syntastic', {
            \ 'autoload' : {
            \   'filetypes' : ['c', 'cpp', 'python']
            \   },
            \ }
" - ファイルのスイッチを簡単に
"   例) cpp ファイルから hpp ファイルとか
NeoBundleLazy 'kana/vim-altr', {
            \ 'autoload' : {
            \   'filetypes': ['c', 'cpp', 'python']
            \   },
            \ }


" Git/Gist
" - git の wrapper, git add -p とかをグラフィカルに
NeoBundle 'tpope/vim-fugitive'
" - 差分があるときに行番号のところに表示
NeoBundle 'airblade/vim-gitgutter'
" - git の履歴をグラフィカルに
NeoBundle 'gregsexton/gitv', {
            \ 'depends' : 'tpope/vim-fugitive',
            \ }
" - Gist投稿
NeoBundle "mattn/gist-vim"
" TODO : vim-gistaっていうgist検索のプラグインもよさそう


" C/C++
" - clang-formatを使ったフォーマッティング
NeoBundleLazy 'rhysd/vim-clang-format', {
            \ 'external_commands' : 'clang-format',
            \ 'autoload' : {
            \   'filetypes' : ['c', 'cpp', 'objc']
            \   },
            \ 'depends' : ['kana/vim-operator-user', 'Shougo/vimproc.vim']
            \ }


" javascript
NeoBundleLazy 'pangloss/vim-javascript', {
            \ 'autoload': {
            \   'filetypes': ['javascript']
            \   }
            \ }
NeoBundleLazy 'briancollins/vim-jst', {
            \ 'autoload': {
            \   'filetypes': ['jst', 'ejs']
            \   },
            \ 'depends': 'pangloss/vim-javascript'
            \ }
NeoBundleLazy 'groenewege/vim-less', {
            \ 'autoload': {
            \   'filetypes': ['less']
            \   }
            \ }
NeoBundleLazy 'digitaltoad/vim-jade', {
            \ 'autoload': {
            \   'filetypes': ['jade']
            \   }
            \ }
NeoBundleLazy 'cakebaker/scss-syntax.vim', {
            \ 'autoload': {
            \   'filetypes': ['scss']
            \   }
            \ }
NeoBundleLazy 'kchmck/vim-coffee-script', {
            \ 'autoload': {
            \   'filetypes': ['coffee']
            \   }
            \ }


" Ruby
NeoBundleLazy 'vim-ruby/vim-ruby', {
            \ 'autoload': {
            \   'filetypes': ['ruby', 'eruby', 'haml']
            \   }
            \ }
NeoBundleLazy 'ruby-matchit', {
            \ 'autoload': {
            \   'filetypes': ['ruby', 'eruby', 'haml']
            \   }
            \ }
NeoBundleLazy 'skwp/vim-rspec', {
            \ 'autoload': {
            \   'filetypes': ['ruby']
            \   }
            \ }
NeoBundleLazy 'Keithbsmiley/rspec.vim', {
            \ 'autoload': {
            \   'filetypes': ['ruby']
            \   }
            \ }
NeoBundleLazy 'taka84u9/vim-ref-ri', {
            \ 'depends': ['Shougo/unite.vim', 'thinca/vim-ref'],
            \ 'autoload': {
            \   'filetypes': ['ruby', 'eruby', 'haml']
            \   }
            \ }
NeoBundleLazy 'tpope/vim-rails', {
            \ 'autoload' : {
            \   'filetypes' : ['ruby']
            \   }
            \ }


" Go
" - golang の便利プラグイン
NeoBundleLazy 'fatih/vim-go', {
            \ 'autoload' : {'filetypes' : ['go']},
            \ }
NeoBundleLazy 'rhysd/vim-go-impl', {
            \ 'autoload' : {'filetypes' : ['go']},
            \ }


" html
" - zen-coding
NeoBundleLazy 'mattn/emmet-vim', {
            \ 'autoload': {
            \   'filetypes': ['html', 'erb']
            \   },
            \ }


" Perl
NeoBundleLazy 'petdance/vim-perl', {
            \ 'autoload': {
            \   'filetypes': ['perl'],
            \   },
            \ }


" Document
" - 古いみたいなので使わないようにした
NeoBundleLazy 'tpope/vim-markdown', {
            \ 'disabled' : 1, 
            \ 'autoload': {
            \   'filetypes': ['markdown'],
            \   }
            \ }
" - シンタックスハイライトとか
" - filetypeがmkdになるので、使わないようにする
NeoBundleLazy 'plasticboy/vim-markdown', {
            \ 'disabled' : 1,
            \ 'depends' : ['godlygeek/tabular'],
            \ 'autoload': {
            \   'filetypes': ['markdown'],
            \   }
            \ }
" - markdownのプレビュー
NeoBundleLazy 'kannokanno/previm', {
            \ 'autoload': {
            \   'filetypes': ['markdown']
            \   },
            \ 'depends': 'tyru/open-browser.vim'
            \ }
" - jsonのプレビュー
NeoBundleLazy 'elzr/vim-json', {
            \ 'autoload' : {
            \   'filetypes' : ['javascript'],
            \   },
            \ }
" - Ansible のための yaml settings
NeoBundleLazy 'chase/vim-ansible-yaml', {
            \ 'autoload' : {
            \   'filetypes' : ['yaml'],
            \   },
            \ }


" Misc
" - ローカルファイルのvimを読むようにする
NeoBundle 'thinca/vim-localrc'

" - プログラムを簡単に実行してくれる
NeoBundleLazy 'thinca/vim-quickrun', {
            \ 'autoload': {
            \   'filetypes': [
            \       'ruby', 'python', 'perl', 'sh', 'go', 'cpp', 'c'
            \   ]},
            \ }
" - シェル環境
NeoBundleLazy 'Shougo/vimshell', {
            \ 'depends' : 'Shougo/vimproc.vim',
            \ 'autoload' : {
            \   'mappings' : ['<Plug>(vimshell_)'],
            \   'commands' : [
            \       'VimShell',
            \       'VimShellInteractive',
            \       'VimShellSendString'
            \       ],
            \   },
            \ }
" - TODOの一覧とかを表示してくれる
NeoBundleLazy 'vim-scripts/TaskList.vim', {
            \ 'autoload' : {
            \   'mappings' : ['<Plug>TaskList'], 
            \   },
            \ }
" - ctagの一覧などの表示
NeoBundleLazy 'majutsushi/tagbar', {
            \ 'build_commands' : 'brew',
            \ 'autoload': {
            \   'commands': ['TagbarToggle'],
            \   },
            \ 'build' : {
            \   'mac': 'brew install ctags',
            \   },
            \ }
" - 単語をマークしてハイライトしてくれる
NeoBundleLazy 't9md/vim-quickhl', {
            \ 'autoload' : {
            \   'mappings' : ['<Plug>(quickhl-'],
            \   },
            \ }
" - メモ管理
NeoBundle 'glidenote/memolist.vim', {
            \ 'depends': 'fuenor/qfixgrep'
            \ }
" - ファイルタイプ別にテンプレートを選べる
NeoBundle 'mattn/sonictemplate-vim'
" - 集中モード
NeoBundleLazy 'junegunn/goyo.vim', {
            \ 'disabled' : 0,
            \ 'autoload' : {
            \   'commands' : ['Goyo'],
            \   },
            \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Others/Misc                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" - はてブロ投稿
NeoBundle 'moznion/hateblo.vim', {
            \ 'depends': ['mattn/webapi-vim', 'Shougo/unite.vim'],
            \ }

" - TwitterClient
NeoBundleLazy 'basyura/TweetVim', {
            \ 'autoload' : {
            \   'commands' : [
            \       'TweetVimHomeTimeline',
            \       'TweetVimSay',
            \       ]
            \   },
            \ 'depends' : [
            \   'tyru/open-browser.vim',
            \   'basyura/twibill.vim',
            \   'mattn/webapi-vim',
            \   'h1mesuke/unite-outline',
            \   'basyura/bitly.vim',
            \   'Shougo/unite.vim',
            \   'mattn/favstar-vim',
            \   ],
            \ 'external_commands' : 'curl',
            \ }

" - Hackernews on vim
NeoBundle 'ryanss/vim-hackernews'

" others
NeoBundle 'vim-jp/vimdoc-ja'

