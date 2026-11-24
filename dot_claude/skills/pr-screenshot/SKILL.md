---
name: pr-screenshot
description: PR の本文やコメントに、スクリーンショットや画面録画を貼るときに使う。gh の --attach で画像を上げ、本文の参照を GitHub の URL に置き換える手順。「PRにスクショつけて」「スクショをPRに貼って」「PR作成時に画像を添付して」等の依頼時や、PR 作成で画面の証拠を出すときに使用。
---

# pr-screenshot

`gh pr create` / `gh pr edit` / `gh pr comment` の `--attach` で画像を上げる。
ブラウザでの GitHub ログインや Playwright は使わない。

## 手順

1. 本文に、画像を相対パスで書く

   ```markdown
   ![管理者・編集画面](./owner-edit.png)
   ```

2. 同じファイルを `--attach` で渡す

   ```bash
   gh pr create --base develop --title "..." --body-file /tmp/pr/body.md \
     --attach /tmp/pr/owner-edit.png
   ```

3. 本文の参照が `https://github.com/user-attachments/assets/...` に置き換わったことを確かめる

   ```bash
   gh pr view <番号> --json body -q .body | grep user-attachments
   ```

## 挙動

- 本文の相対パスは、`--body-file` のディレクトリから解決する。見つからなければ作業ディレクトリから探す
- 本文で参照していないファイルは、本文の末尾に足される
- alt は `--attach '<file>#<alt>'` で渡せる。本文に書いた alt があれば、そちらが残る
- 1回のコマンドで 50 ファイルまで
- 一部の画像だけ失敗しても、PR は更新される。このとき終了コードは 0 以外になる。足りない画像は `gh pr edit --attach` で足す

## 注意

- 既存 PR で `--body` / `--body-file` を付けると、本文全体が置き換わる。bot の追記を消さないよう、先に `gh pr view <番号> --json body -q .body` で今の本文を取り、そこに画像の参照を足してから渡す
- `--body` も `--body-file` も付けずに `gh pr edit --attach` すると、今の本文の末尾に画像が足される
- 非公開リポジトリの画像は、ログインしないと見えない。表示は GitHub の画面で確かめる

## 前提

- gh 2.103.3 の `--help` で `--attach` があることを確認済み
- `gh pr create --help | grep attach` で何も出なければ、`brew upgrade gh` する
