# dotfiles

[chezmoi](https://www.chezmoi.io/) + [sheldon](https://github.com/rossmacarthur/sheldon) で管理する dotfiles。

## セットアップ

```bash
# chezmoi をインストール
brew install chezmoi

# dotfiles を適用
chezmoi init katanabe --apply

# Homebrew パッケージを復元（共有）
brew bundle --file=~/.config/Brewfile

# マシン固有パッケージ（任意）
# cp ~/.config/Brewfile.local.example ~/.config/Brewfile.local
# # docker-desktop / rancher はマシンごとに片方だけ残す
# brew bundle --file=~/.config/Brewfile.local

# zsh プラグインをインストール
sheldon lock
```

適用後、`~/.config/chezmoi/chezmoi.toml` を作成してシークレットを設定:

```toml
[data]
npm_token = "your-npm-token"
```

## ディレクトリ構成

```
.
├── dot_zshrc.tmpl                          # シェル設定（テンプレート）
├── dot_gitconfig                           # Git 設定
├── dot_local/bin/
│   └── executable_sync-dotfiles          # 自動同期スクリプト
├── private_Library/private_LaunchAgents/
│   └── com.katanabe.sync-dotfiles.plist  # launchd 定義（毎日 12:00）
└── dot_config/
    ├── Brewfile                            # 共有 Homebrew パッケージ一覧
    ├── Brewfile.local.example              # マシン固有パッケージの雛形
    ├── starship.toml                       # プロンプト（Catppuccin Mocha）
    ├── private_atuin/private_config.toml   # シェル履歴
    ├── ghostty/config                      # ターミナル
    ├── mise/config.toml                    # ランタイム管理
    ├── sheldon/plugins.toml                # zsh プラグイン管理
    └── zellij/
        ├── config.kdl                      # ターミナルマルチプレクサ
        └── layouts/dev.kdl                 # zellij レイアウト
```

## ツール構成

```
chezmoi ─── dotfiles の配布・同期・GitHub 管理
sheldon ─── zsh プラグイン + ツール初期化
  ├── starship    (プロンプト)
  ├── zoxide      (ディレクトリ移動)
  ├── atuin       (シェル履歴)
  ├── fzf         (ファジー検索)
  ├── zsh-autosuggestions
  └── zsh-syntax-highlighting
Homebrew Bundle ─── パッケージ一覧の記録・復元
launchd ─── 毎日 12:00 に自動同期
```

## 手動更新

### dotfiles を最新に同期（pull → apply）

```bash
chezmoi update
brew bundle --file=~/.config/Brewfile
```

### マシン固有パッケージ（Brewfile.local）

`docker-desktop` と `rancher` のようにマシン間で排他なものは共有 Brewfile に書かない。

```bash
cp ~/.config/Brewfile.local.example ~/.config/Brewfile.local
# このマシン用の行だけ残す
brew bundle --file=~/.config/Brewfile.local
```

`~/.config/Brewfile.local` は chezmoi 非管理。git にも載せない。

### ローカルの変更をプッシュ

```bash
# Brewfile を現在のインストール状態で更新
brew bundle dump --file=~/.config/Brewfile --force
# sync-dotfiles と同じく、Brewfile.local / 排他 runtime は共有側から除去する

# chezmoi に反映してプッシュ
chezmoi re-add
chezmoi git add .
chezmoi git commit -- -m "update dotfiles"
chezmoi git push
```

## 自動同期

launchd (`com.katanabe.sync-dotfiles`) が毎日 12:00 に以下を実行:

1. `git pull --rebase` → `chezmoi apply` — リモートの変更を先に取り込む
2. `brew bundle dump` — 共有 Brewfile を更新
3. `Brewfile.local` 記載分と `docker-desktop` / `rancher` を共有 Brewfile から除去
4. `chezmoi re-add` — 変更された dotfiles を取り込み
5. 差分があれば自動 commit & push（conflict marker があれば中止）

```bash
# ログ確認
cat /tmp/sync-dotfiles.log

# 手動実行
launchctl start com.katanabe.sync-dotfiles
```
