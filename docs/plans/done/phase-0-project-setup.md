# Phase 0: プロジェクト立ち上げ 実装プラン

**作成日:** 2026年7月16日  
**対象タスク:** tasks.md Phase 0-1 / 0-2 / 0-3

---

## 0-1. Flutter プロジェクト作成

- `flutter create oshi_log` をワークスペースルート直下に実行
- 作成後、不要なデフォルトファイルを削除
  - `lib/main.dart` の内容を空にして書き直す
  - `test/widget_test.dart` を削除

## 0-2. パッケージ導入（pubspec.yaml）

追加パッケージ:

| パッケージ | 用途 |
|---|---|
| `flutter_riverpod` | 状態管理 |
| `drift` | ローカル DB（全Platform対応） |
| `drift_dev` | drift コード生成（dev_dependencies） |
| `build_runner` | コード生成（dev_dependencies） |
| `sqlite3_flutter_libs` | iOS / Android 向け SQLite |
| `go_router` | ナビゲーション |
| `fl_chart` | グラフ描画 |
| `image_picker` | 画像選択 |
| `flutter_local_notifications` | 通知（Web は代替） |
| `flutter_colorpicker` | カラーピッカー |
| `csv` | CSV エクスポート |
| `font_awesome_flutter` | アイコン |

## 0-3. プロジェクト構成設計

feature-first ディレクトリ構成:

```
lib/
  features/
    oshi/           # 推し管理
    event/          # イベント管理
    goods/          # グッズ管理
    summary/        # 支出サマリー
    saving/         # 推し貯金
    notification/   # 通知
    settings/       # 設定
  shared/
    widgets/        # 共通 Widget
    theme/          # テーマ・カラーパレット
    database/       # drift DB 設定
  main.dart
```

## 完了条件

- [ ] `flutter run -d chrome` でデフォルト画面が起動すること
- [ ] `flutter analyze` でエラーがないこと
