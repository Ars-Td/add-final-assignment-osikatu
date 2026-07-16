# CLAUDE.md

## プロジェクト概要

**Oshi Log（推しログ）** — 推し活専用の活動記録 × 家計簿 Flutter アプリ。
対応プラットフォーム: **Web（主軸）/ iOS / Android**
仕様: `docs/spec.md` / タスク: `docs/tasks.md`

---

## 技術スタック

| レイヤー | 技術 |
|---|---|
| フレームワーク | Flutter (Dart) |
| 状態管理 | flutter_riverpod |
| ローカル DB | drift（全Platform対応 SQLite ORM） |
| ナビゲーション | go_router |
| グラフ | fl_chart |
| 通知 | flutter_local_notifications（Web は UI バナー代替） |
| その他 | image_picker / flutter_colorpicker / csv / font_awesome_flutter |

> **Web 対応の注意点**
> - `sqflite` は Web 非対応のため `drift` に変更（drift/wasm バックエンドで IndexedDB に永続化）
> - `flutter_local_notifications` のスケジュール通知は Web 非対応。`kIsWeb` でプラットフォーム判定し、Web では画面内バナー通知で代替する

---

## ディレクトリ構成方針

```
lib/
  features/<feature>/   # feature-first 構成
  shared/               # 共通 Widget・テーマ
docs/
  spec.md               # 仕様書
  tasks.md              # タスクリスト
  plans/                # 実装 plan ファイル（未完了）
  plans/done/           # 完了済み plan ファイル
```

---

## 開発ルール

- **git**: `main` へ直接コミット。コミットメッセージは日本語
- **TDD**: t_wada 式 TDD（red → green → refactor）で実装
- **plan ファイル**: 実装前に `docs/plans/` に作成し、完了後は `docs/plans/done/` へ移動

---

## 完了報告フォーマット

各タスク完了時は以下を報告すること。

```
## 対応内容
（2〜3行で簡潔に）

## 主な変更ファイル
- path/to/file

## 使用ツール
- （skills / MCP など）

## 次にやるべきこと
- （具体的に1〜3件）
```
