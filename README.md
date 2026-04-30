# dotfiles

[chezmoi](https://www.chezmoi.io/) + [sheldon](https://github.com/rossmacarthur/sheldon) で管理する dotfiles。

## セットアップ

```bash
# Homebrew をインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# chezmoi をインストール
brew install chezmoi

# dotfiles を適用
chezmoi init katanabe --apply

# Homebrew パッケージを復元
brew bundle --file=~/.config/Brewfile

# zsh プラグインをインストール
sheldon lock
```

## マシン固有の設定・シークレット

シークレットや 1 台限定の値は `~/.zshrc.local`(chezmoi 追跡外)に置く。dotfiles リポに値が混ざらない代わりに、ファイル自体は平文で `$HOME` 配下に存在し、AI コーディングツール・エディタ・バックアップから読み取られる経路は塞がれていない。**シークレット系は macOS Keychain に登録し、`.zshrc.local` にはルックアップ行だけ書く**。漏洩した値を「無かったこと」にする手段はないので(取れるのは revoke 一択)、ディスクに平文を残さないのが最も早い対策。

`~/.zshrc.local` は `dot_zshrc.tmpl` の末尾で `[ -f ~/.zshrc.local ] && source ~/.zshrc.local` により自動 source される。

### シークレット: macOS Keychain 経由 (推奨)

`security` コマンドで Keychain に登録し、`.zshrc.local` ではルックアップだけ書く。値はディスク上に平文で残らない。

**初回登録 (1 回だけ)**:

```bash
security add-generic-password -U -a "$USER" -s github-pat -w
# Password: と聞かれたら値を貼り付け（コマンド履歴・ログに残らない）
```

- `-s <service>` は Keychain 内の識別名(例: `github-pat`, `openai-api-key`)
- `-w` を **値なし** で渡すと対話プロンプトになる ─ 値が argv に入らないので `ps` / `history` / シェルログに残らない
- `-U` は既存エントリの上書き許可(更新時にも同じコマンドが使える)

**`.zshrc.local` ではルックアップだけ書く**:

```bash
export NPM_TOKEN="$(security find-generic-password -s github-pat -a "$USER" -w 2>/dev/null)"
export OPENAI_API_KEY="$(security find-generic-password -s openai-api-key -a "$USER" -w 2>/dev/null)"
```

`2>/dev/null` で「Keychain にエントリが無いマシン」では空文字フォールバック ─ エラー停止せず shell の起動を壊さない。

**初回のみ macOS の許可ダイアログ**: 新ターミナルで初めて lookup が走る時、Keychain Access が「Terminal が `<service>` にアクセスを要求」と聞いてくる。「常に許可」を選ぶと以降出ない。間違えて「拒否」した場合は Keychain Access.app で当該エントリの ACL を編集するか、`security delete-generic-password -s <service>` で消して登録からやり直し。

**動作確認**:

```bash
[ -n "$NPM_TOKEN" ] && echo "NPM_TOKEN set (length: ${#NPM_TOKEN})" || echo "NPM_TOKEN empty"
```

値そのものを `echo` しないこと(シェル履歴に残るため)。

### シークレットでない設定: 平文でよい

ホスト名・パス・ローカルポート番号など、**漏れても無害な値**はそのまま `export` で OK:

```bash
# 例: ~/.zshrc.local
export RAILS_DEV_PORT=3001
export DOTFILES_HOSTNAME_OVERRIDE="laptop-2"
```

### ルール

- 全マシンで共通の設定 → `dot_zshrc.tmpl`(chezmoi 管理)
- 1 台でしか使わない・**漏れても無害**な値 → `~/.zshrc.local` に平文 export
- 1 台でしか使わない・**シークレット** → Keychain に登録 + `.zshrc.local` にルックアップ行
- 平文シークレットを `~/.zshrc.local` に書くのは **禁止**(`$HOME` の read 権限を持つ任意のプロセスから読める ─ AI コーディングツール、エディタ、バックアップ、誤共有スクリーンショット等)

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
    ├── Brewfile                            # Homebrew パッケージ一覧
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

### ローカルの変更をプッシュ

```bash
# Brewfile を現在のインストール状態で更新
brew bundle dump --file=~/.config/Brewfile --force

# chezmoi に反映してプッシュ
chezmoi re-add
chezmoi git add .
chezmoi git commit -- -m "update dotfiles"
chezmoi git push
```

## 自動同期

launchd (`com.katanabe.sync-dotfiles`) が毎日 12:00 に以下を実行:

1. `brew bundle dump` — Brewfile を更新
2. `chezmoi re-add` — 変更された dotfiles を取り込み
3. 差分があれば自動 commit & push
4. `git pull` — リモートの変更を取得
5. `chezmoi apply` — リモートの変更をディスクに反映

```bash
# ログ確認
cat /tmp/sync-dotfiles.log

# 手動実行
launchctl start com.katanabe.sync-dotfiles
```
