---
name: task-list
description: 個人タスク一覧を表示する。「タスク何ある？」「今のtodo見せて」「task-list」「個人タスク確認」等の依頼時に使用。GitHub Issues とは別の、ローカルファイル(~/.claude-tasks/)で管理する個人ToDoの閲覧専用。
---

# task-list

`~/.claude-tasks/<project>/tasks.md` と `archive.md` を読み、整形してユーザーに表示する。

## 前提

- データ場所: `~/.claude-tasks/<project>/`
- ファイル: `tasks.md` (TODO + DOING) と `archive.md` (DONE履歴)
- フォーマット (Markdown チェックリスト):
  ```md
  # Tasks — <project>

  ## TODO
  - [ ] **<slug>** <title> (<created-date>)

  ## DOING
  - [ ] **<slug>** <title> (<created-date>)
  ```

## 実行手順

1. **プロジェクト名検出**: `git rev-parse --show-toplevel` を Bash で実行し、`basename` でディレクトリ名を取得。例: `oripaone-develop` → そのまま使うか、末尾の `-develop` を除いた `oripaone` を使う。**末尾の `-develop`/`-main`/`-master` は除去する**。
2. **データディレクトリ確認**: `~/.claude-tasks/<project>/` が存在するか LS で確認。
   - 存在しない場合: 「プロジェクト `<project>` のタスクはまだありません。`/task-add` で追加してください」と表示して終了。
3. **tasks.md を読む**: Read tool で `~/.claude-tasks/<project>/tasks.md` を読み込む。
4. **整形して表示**: 以下の形式で出力:
   ```
   📋 oripaone のタスク

   🔵 DOING (1)
     - <slug> — <title> (<date>)

   ⚪ TODO (2)
     - <slug> — <title> (<date>)
     - <slug> — <title> (<date>)
   ```
5. **件数が0の場合**: 「タスクはありません」と表示。
6. **引数 `--archive` 付き**: `archive.md` も読み込み、最近の DONE を10件まで追加表示。

## 引数

- なし: TODO + DOING のみ表示
- `--archive`: archive.md の DONE も追加表示 (最新10件)
- `--all`: すべて表示

## 注意

- ファイルは**読むだけ**。一切編集しない。
- ファイルが存在しないのは正常状態（初回利用時）として扱う。エラーにしない。
- プロジェクト名は cwd の git リポジトリから自動検出。git管理外のディレクトリの場合は `<basename>` をそのまま使う。
