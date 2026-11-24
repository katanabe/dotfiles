---
name: pr-screenshot
description: PR の本文やコメントに、スクリーンショットや画面録画を付けるときに使う。スクショが無ければ、PR で変えた画面を開発サーバーで開いて Playwright で撮る。撮った画像は gh の --attach で上げ、本文の参照を GitHub の URL に置き換える。「PRにスクショつけて」「スクショをPRに貼って」「PR作成時に画像を添付して」等の依頼時や、PR 作成で画面の証拠を出すときに使用。
---

# pr-screenshot

PR に画面の証拠を付ける。
スクショが無ければ撮り、`gh` の `--attach` で上げる。
GitHub へのアップロードに、ブラウザでのログインは使わない。

## 1. 撮る（スクショが無いとき）

### 何を撮るか決める

- PR の差分から、変わった画面と、変わった表示の条件を拾う
- 条件ごとに1枚撮る。ロールで表示が変わるなら、ロールごとに撮る
- 何を撮るかをユーザーに見せてから撮る。条件が多いときは、PR に貼る3枚前後を選んでもらう

### 準備

- PR のブランチを開いている checkout（worktree なら worktree 側）で、変えたアプリの開発サーバーを起動する。長く動くので、バックグラウンドで起動する
- ローカル DB に、撮りたい条件のデータがあるかを SQL で確かめる。足りなければ、作ってよいかをユーザーに聞く
- 画面が 500 を返したり、一覧が空になったりしたら、開発サーバーのログで原因の SQL エラーを見る。ローカル DB のマイグレーション遅れなら、まだ当たっていないマイグレーションの中身を見てから当てる

### Playwright で撮る

- 新しく入れず、リポジトリにある Playwright を使う

  ```js
  import { chromium } from "<checkout>/node_modules/.pnpm/playwright@<版>/node_modules/playwright/index.mjs";
  ```

- `browser.newContext({ recordVideo: { dir } })` で録画も残す。画像で伝わらない操作の流れを、あとから確かめられる
- `page.on("response")` で API の呼び出しを記録する。どの API が呼ばれたかも、画像と並べて証拠にできる
- 入力欄は `input[name="..."]` で指定する。ラベルとの関連付けが無い画面では、`getByLabel` が見つけられない
- 画像は `/tmp/<作業名>/<ロール>-<条件>.png` のように、何の画面か分かる名前で保存する
- 撮った画像は Read で開き、狙った表示が写っているかを確かめてからユーザーに見せる

### oripaone の場合

- admin の開発サーバーは `pnpm dev --filter=admin` で、ポートは 3001
- 開発環境のログイン画面は、パスワード欄に入力した時点で送信される。ログインボタンは押さず、`page.waitForURL` で `/signin` から離れるのを待つ
- シードのアカウントはパスワードがすべて `kecakinc1`。ロールごとに `admin@oripaone.jp`（管理者）、`operator@oripaone.jp`（運用者）、`gacha_operator@oripaone.jp`（ガチャ運用者）などがある
- ローカル DB はコンテナ `supabase_db_oripaone`。`docker exec -i supabase_db_oripaone psql -U postgres -At -c "<SQL>"` で読める
- マイグレーション遅れは `pnpm exec dotenvx run -f .env -f .env.local --overload --ignore=MISSING_ENV_FILE -- supabase migration up --local` で当てる
- 管理画面のドロワーは URL のクエリで開く。たとえば作成は `?new=1`、編集は `?id=<ID>&edit=1`

## 2. 上げる

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

### 挙動

- 本文の相対パスは、`--body-file` のディレクトリから解決する。見つからなければ作業ディレクトリから探す
- 本文で参照していないファイルは、本文の末尾に足される
- alt は `--attach '<file>#<alt>'` で渡せる。本文に書いた alt があれば、そちらが残る
- 1回のコマンドで 50 ファイルまで
- 一部の画像だけ失敗しても、PR は更新される。このとき終了コードは 0 以外になる。足りない画像は `gh pr edit --attach` で足す

### 注意

- 既存 PR で `--body` / `--body-file` を付けると、本文全体が置き換わる。bot の追記を消さないよう、先に `gh pr view <番号> --json body -q .body` で今の本文を取り、そこに画像の参照を足してから渡す
- `--body` も `--body-file` も付けずに `gh pr edit --attach` すると、今の本文の末尾に画像が足される
- `/tmp` など、リポジトリの外で `gh pr` を実行するときは `-R <owner>/<repo>` を付ける
- 非公開リポジトリの画像は、ログインしないと見えない。表示は GitHub の画面で確かめてもらう

### 前提

- gh 2.103.3 の `--help` で `--attach` があることを確認済み
- `gh pr create --help | grep attach` で何も出なければ、`brew upgrade gh` する

## 3. 片付ける

- 起動した開発サーバーは、ユーザーに確かめてから止める
- ローカル DB にデータを足したときは、何を足したかを報告する
