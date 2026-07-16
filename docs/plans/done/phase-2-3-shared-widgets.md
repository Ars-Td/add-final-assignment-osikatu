# Phase 2-3: 共通Widget・ユーティリティ

## 目的

複数の画面で重複しているUIパターンを `lib/shared/` に共通化し、保守性を高める。

---

## 共通化する内容

### 1. `lib/shared/utils/format_utils.dart`
- `formatAmount(int amount) → String`
  - `event_detail_page.dart`・`event_list_tab.dart` の `_formatAmount`/`_fmt` を統合

### 2. `lib/shared/widgets/confirm_dialog.dart`
- `showConfirmDialog({title, content, confirmLabel, confirmColor}) → Future<bool?>`
  - `oshi_detail_page.dart` / `event_detail_page.dart` の `_confirmDelete` を統合

### 3. `lib/shared/widgets/empty_state_view.dart`
- `EmptyStateView({icon, message, actionLabel, onAction})`
  - `oshi_detail_page.dart` の `_TabPlaceholder`
  - `event_list_tab.dart` の空状態表示を統合

### 4. `lib/shared/widgets/app_bar_loading_indicator.dart`
- `AppBarLoadingIndicator()` ― AppBar actions 用の小さい CPI ウィジェット
  - `event_form_page.dart` の Padding+SizedBox+CPI を統合

---

## 置き換え対象ファイル

| ファイル | 置き換え内容 |
|---|---|
| `features/oshi/pages/oshi_detail_page.dart` | `_confirmDelete` → `showConfirmDialog`, `_TabPlaceholder` → `EmptyStateView` |
| `features/event/pages/event_detail_page.dart` | `_confirmDelete` → `showConfirmDialog`, `_formatAmount` → `formatAmount` |
| `features/event/pages/event_form_page.dart` | AppBar CPI → `AppBarLoadingIndicator` |
| `features/event/widgets/event_list_tab.dart` | 空状態 → `EmptyStateView`, `_fmt` → `formatAmount` |

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] `flutter test` で既存テストが引き続きパスすること（全33件）
