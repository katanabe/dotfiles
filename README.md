# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理する dotfiles。

## セットアップ

```bash
# chezmoi をインストール
brew install chezmoi

# dotfiles を適用
chezmoi init katanabe --apply
```

適用後、`~/.config/chezmoi/chezmoi.toml` を作成してシークレットを設定:

```toml
[data]
npm_token = "your-npm-token"
```

## Homebrew パッケージの復元

```bash
brew bundle --file=~/.config/Brewfile
```

## 管理対象

| ファイル | 用途 |
|---|---|
| `.zshrc` | シェル設定（テンプレート） |
| `.gitconfig` | Git 設定 |
| `.config/starship.toml` | プロンプト（Catppuccin Mocha） |
| `.config/atuin/config.toml` | シェル履歴 |
| `.config/sheldon/plugins.toml` | zsh プラグイン管理 |
| `.config/zellij/config.kdl` | ターミナルマルチプレクサ |
| `.config/zellij/layouts/dev.kdl` | zellij レイアウト |
| `.config/mise/config.toml` | ランタイム管理 |
| `.config/Brewfile` | Homebrew パッケージ一覧 |

## 自動同期

launchd (`com.katanabe.sync-dotfiles`) が毎日 12:00 に以下を実行:

1. `brew bundle dump` — Brewfile を更新
2. `chezmoi re-add` — 変更された dotfiles を取り込み
3. 差分があれば自動 commit & push

ログ: `/tmp/sync-dotfiles.log`

手動実行:

```bash
launchctl start com.katanabe.sync-dotfiles
```
