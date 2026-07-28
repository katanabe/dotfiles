---
name: task-done
description: 個人タスクを完了にして archive.md に移動する。「タスク完了」「これ終わった」「task-done」「個人タスク済」等の依頼時に使用。GitHub Issues とは別の、ローカルファイル(~/.claude-tasks/)で管理する個人ToDoのクローズ専用。
---

# task-done

指定スラグのタスクを `tasks.md` から削除し、`archive.md` の DONE セクションに移動する。

## 前提

- データ場所: `~/.claude-tasks/<project>/`
- `tasks.md`: TODO + DOING (アクティブなタスク)
- `archive.md`: DONE (完了履歴)

## 引数

- `<slug>` (必須): 完了するタスクのスラグ。例: `e2e-concurrency-control`
- `--keep` (オプション): tasks.md から削除せず、`- [x]` でチェックだけ入れる (archive.md には移さない)

## 実行手順

1. **プロジェクト名検出**: `git rev-parse --show-toplevel` を Bash で実行し、`basename` で取得。末尾の `-develop`/`-main`/`-master` は除去。
2. **tasks.md を Read** で読む。
3. **対象スラグの行を検索**:
   - `**<slug>**` で部分一致検索
   - 見つからない場合: 「❌ スラグ `<slug>` はタスクに見つかりません。`/task-list` で確認してください」と表示して終了
   - 複数ヒットした場合: 候補を全て表示し、ユーザーに確認を促して終了
4. **行を抽出して保管**: 該当行のテキスト全体（例: `- [ ] **e2e-concurrency-control** E2E concurrency制御 (2026-04-15)`）を保持
5. **tasks.md から削除**: Edit tool で該当行を空文字に置換 (改行も含めて削除)。
6. **archive.md に追記**: Read で archive.md を読み、Edit で `## DONE` セクションの直後 (または既存DONE行の末尾) に以下を挿入:
   ```
   - [x] **<slug>** <title> (created: <original-date>, done: <today>)
   ```
   元のタイトルと作成日は手順4で抽出した行から取り出す。完了日は今日の日付 (`date +%Y-%m-%d`)。
7. **結果報告**: 「✅ 完了: `<slug>` → archive.md に移動しました」と1行で表示。

## `--keep` 動作

- tasks.md の `- [ ]` を `- [x]` に変えるだけ。archive.md には触らない。
- 「あとでまとめて整理したい」場合に便利。

## 注意

- スラグの大文字小文字は厳密一致 (生成時は常に小文字なので通常問題にならない)
- DOING セクションのタスクも対象。両セクション横断で検索する
- 削除前に該当行を必ず保管すること（archive.md への記録に使う）
- 1回の呼び出しで1タスクのみ完了。複数完了は複数回呼び出す
