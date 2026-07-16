# Phase 10: UI仕上げ・テスト・リリース準備

## 目的

アプリを完成品として仕上げる。ダークモード・スプラッシュ画面・追加テスト・権限設定を行う。

---

## 実装内容

### 10-1. UI ブラッシュアップ

- **ダークモード対応**: `ThemeMode` を StateProvider で管理し、設定画面から切り替え可能にする
- **テーマ**: `ColorScheme.fromSeed` で統一（ピンク系）
- **スプラッシュ画面**: ロゴ + アプリ名 + アニメーション → 1.5秒後にホームへ遷移
- **空状態・エラー状態**: 既存の `EmptyStateView` / `AppBarLoadingIndicator` で統一済み

### 10-2. テスト追加

- `SummaryRepository` のユニットテスト
- `ExportService` のユニットテスト（CSV/JSON フォーマット確認）

### 10-3. リリース準備

- `AndroidManifest.xml` の権限確認（カメラ・通知・インターネット）
- `Info.plist` の権限確認（カメラ・フォトライブラリ・通知）
- `tasks.md` の全フェーズを完了マークに更新

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] `flutter test` で全テストがパスすること（全58件）
