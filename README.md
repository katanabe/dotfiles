# dotfiles

[chezmoi](https://www.chezmoi.io/) + [sheldon](https://github.com/rossmacarthur/sheldon) で管理する dotfiles。

## セットアップ

```bash
# chezmoi をインストール
brew install chezmoi

# dotfiles を適用
chezmoi init katanabe --apply

# Homebrew パッケージを復元
brew bundle --file=~/.config/Brewfile

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
└── dot_config/
    ├── Brewfile                            # Homebrew パッケージ一覧
    ├── starship.toml                       # プロンプト（Catppuccin Mocha）
    ├── private_atuin/private_config.toml   # シェル履歴
    ├── gh/private_config.yml               # GitHub CLI
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

## 自動同期

launchd (`com.katanabe.sync-dotfiles`) が毎日 12:00 に以下を実行:

1. `brew bundle dump` — Brewfile を更新
2. `chezmoi re-add` — 変更された dotfiles を取り込み
3. 差分があれば自動 commit & push

```bash
# ログ確認
cat /tmp/sync-dotfiles.log

# 手動実行
launchctl start com.katanabe.sync-dotfiles
```
