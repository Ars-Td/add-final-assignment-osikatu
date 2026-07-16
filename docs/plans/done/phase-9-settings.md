# Phase 9: 設定・データエクスポート

## 目的

設定画面を実装し、通知設定と CSV/JSON データエクスポート機能を提供する。

---

## 実装内容

### `lib/features/settings/export_service.dart`

| メソッド | 内容 |
|---|---|
| `exportEventsCsv(db)` | 全イベントを CSV 文字列で返す |
| `exportGoodsCsv(db)` | 全グッズを CSV 文字列で返す |
| `exportSavingsCsv(db)` | 全貯金記録を CSV 文字列で返す |
| `exportAllJson(db)` | 全データを JSON 文字列で返す |

Web では `dart:html` の `AnchorElement` でダウンロード、
ネイティブでは `Share.shareXFiles` （share_plus）または
`path_provider` でファイル保存 → `Share` で共有。

> **今フェーズでは Web でのダウンロードを主軸**に実装し、
> ネイティブは `kIsWeb` 分岐で「クリップボードにコピー」にフォールバック。

### `lib/features/settings/pages/settings_page.dart` 更新

セクション構成:
1. **通知設定**
   - 貯金リマインダーのオン/オフ（SwitchListTile）
   - リマインダー時刻（TimePickerで設定）
2. **データエクスポート**
   - イベント履歴を CSV でエクスポート
   - グッズ履歴を CSV でエクスポート
   - 貯金記録を CSV でエクスポート
   - 全データを JSON でエクスポート
3. **アプリ情報**
   - バージョン: 1.0.0
   - 開発者情報

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] `flutter test` で既存テストが引き続きパスすること（全43件）
