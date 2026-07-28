---
name: task-add
description: 個人タスクを追加する。「タスク追加」「これToDoに入れて」「task-add」「個人タスク登録」等の依頼時に使用。GitHub Issues とは別の、ローカルファイル(~/.claude-tasks/)で管理する個人ToDoの新規登録。
---

# task-add

新しいタスクを `~/.claude-tasks/<project>/tasks.md` の TODO セクションに追加する。

## 前提

- データ場所: `~/.claude-tasks/<project>/tasks.md`
- フォーマット (Markdown チェックリスト):
  ```md
  - [ ] **<slug>** <title> (<created-date>)
  ```

## 引数

- `<title>` (必須): タスクのタイトル。日本語OK。複数語の場合はクォートで囲むか、引数全体をタイトルとして扱う。
- `--slug <slug>` (オプション): スラグを明示指定。未指定時は自動生成。
- `--doing` (オプション): 追加と同時に DOING セクションに入れる。

## 実行手順

1. **プロジェクト名検出**: `git rev-parse --show-toplevel` を Bash で実行し、`basename` でディレクトリ名取得。末尾の `-develop`/`-main`/`-master` は除去。例: `oripaone-develop` → `oripaone`。
2. **データディレクトリ確認**: `~/.claude-tasks/<project>/` が存在しない場合は `mkdir -p` で作成し、空の `tasks.md` (`# Tasks — <project>\n\n## TODO\n\n## DOING\n`) と `archive.md` (`# Archive — <project>\n\n## DONE\n`) を初期化。
3. **スラグ生成** (`--slug` 未指定時):
   - タイトルを**英語に翻訳**してケバブケース化する
   - ルール: 小文字英数字のみ、単語間はハイフン (`-`) 区切り、3〜5語程度に収める
   - 例:
     - `"E2E concurrency制御"` → `e2e-concurrency-control`
     - `"401ハンドラのレースコンディション修正"` → `fix-401-handler-race-condition`
     - `"Stripe fingerprint凍結回避"` → `avoid-stripe-fingerprint-freeze`
     - `"PR description確認"` → `verify-pr-description`
   - 既に同名スラグが tasks.md or archive.md にある場合は末尾に `-2`, `-3` を付与
4. **日付取得**: 現在日付を `YYYY-MM-DD` 形式で取得 (`date +%Y-%m-%d`)。
5. **tasks.md を Read** で読む。
6. **TODOセクションに追記**: Edit tool で `## TODO` 直後の行（または既存タスクの末尾）に新しい行を挿入:
   ```
   - [ ] **<slug>** <title> (<date>)
   ```
   `--doing` 指定時は `## DOING` セクションに追加。
7. **結果報告**: 「✅ 追加: `<slug>` — <title>」と1行で表示。

## 注意

- スラグ生成時、英訳が困難な固有名詞（人名・サービス名等）はそのまま小文字で残す
- タイトルに `(`, `)`, `*`, `_` 等のMarkdown特殊文字が含まれる場合はそのまま記述（パース上問題なし）
- ファイル不在時は自動初期化する (エラーにしない)
- 1回の呼び出しで1タスクのみ追加。複数追加は複数回呼び出す
- スラグ重複チェックは tasks.md と archive.md の両方を見る
