# フォントサイズ変更設定

## 目的

spec.md §11「アクセシビリティ対応（フォントスケール）」および tasks.md Phase 9-1「フォントサイズ変更設定」を実装する。

## 完了条件

- [x] `PreferencesService` に `getFontScale()` / `setFontScale()` を追加（キー: `font_scale`）
- [x] `settings_page.dart` に `fontScaleProvider`（StateProvider<double>）を追加
- [x] `main.dart` 起動時に SharedPreferences からフォントスケールを読み込み Provider に注入
- [x] `OshiLogApp` の `MaterialApp.router` に `builder` を追加し `MediaQuery.textScaler` を上書き
- [x] `settings_page.dart` に `_FontSizeSection` ウィジェットを追加（SegmentedButton で選択）

## 変更ファイル

- `lib/shared/services/preferences_service.dart`
- `lib/features/settings/pages/settings_page.dart`
- `lib/main.dart`

## 実装の要点

### フォントスケール選択肢

| ラベル | スケール | 説明 |
|---|---|---|
| 小 | 0.85 | やや小さめ |
| 標準 | 1.0 | デフォルト（初期値） |
| 大 | 1.15 | やや大きめ |
| 特大 | 1.3 | さらに大きく |

### 適用方法

```dart
// MaterialApp.router の builder で全画面に適用
builder: (context, child) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(fontScale),
    ),
    child: child!,
  );
},
```

Flutter 3.x の `TextScaler.linear()` を使用（非推奨の `textScaleFactor` は使わない）。

### UI

- `SegmentedButton<double>` で 4 段階を選択
- プレビューテキストで即座に変化を確認できる
- 選択時は即座に `fontScaleProvider` を更新（再描画）し、`PreferencesService` に永続化
- 次回起動時に `main.dart` で読み込み → Provider に overrideWith で注入
