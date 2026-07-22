# バグ修正: グッズフィルタ競合・Provider 更新漏れ・非推奨 API

## 修正内容

### BUG 1（高）: グッズの月+カテゴリ複合フィルタが機能しない

**原因:** `goods_providers.dart` のフィルタロジックが `if (filter.isActive)` を先に判定し、
月フィルタが有効な場合はカテゴリフィルタを無視していた。

**修正:**
- `GoodsRepository.getGoodsByMonthAndCategory()` を新規追加
- `goodsListProvider` に `filter.isActive && category != null` の複合条件を追加

**変更ファイル:**
- `lib/features/goods/goods_repository.dart`
- `lib/features/goods/goods_providers.dart`
- `test/repository/goods_repository_test.dart`（テスト追加）

---

### BUG 2（高）: チェックイン後に貯金一覧タブの進捗カードが更新されない

**原因:** `_checkIn()` で `planListProvider` を `invalidate` していなかった。

**修正:** `ref.invalidate(planListProvider(widget.oshiId))` を追加。

**変更ファイル:**
- `lib/features/saving/pages/saving_detail_page.dart`

---

### BUG 3（中）: `download_web.dart` が非推奨の `dart:html` を使用

**原因:** Flutter 3.x / Dart 3.12 で `dart:html` は非推奨。将来の SDK で削除される。

**修正:** `package:web` + `dart:js_interop` に移行。
`pubspec.yaml` に `web: ^1.1.1` を明示追加（ロック済みの推移的依存を直接依存に昇格）。

**変更ファイル:**
- `lib/features/settings/download_web.dart`
- `pubspec.yaml`

---

### BUG 4（低）: `withOpacity()` が非推奨

**修正:** `goods_list_tab.dart:459` の `.withOpacity(0.5)` を `.withValues(alpha: 0.5)` に変更。

**変更ファイル:**
- `lib/features/goods/widgets/goods_list_tab.dart`

---

### BUG 5（低）: `confirm_dialog.dart` で外側の context を `Navigator.pop` に使用

**原因:** `builder: (_) =>` でダイアログ context を捨て、外側の `context` で `Navigator.pop` していた。
マウント済みでない場合に問題になりうる。

**修正:** `builder: (dialogContext) =>` に変更し `Navigator.pop(dialogContext, ...)` を使用。

**変更ファイル:**
- `lib/shared/widgets/confirm_dialog.dart`

## フィルタ優先順位（修正後）

| 月フィルタ | カテゴリ | 適用されるメソッド |
|---|---|---|
| ✓ | ✓ | `getGoodsByMonthAndCategory` |
| ✓ | ✗ | `getGoodsByMonth` |
| ✗ | ✓ | `getGoodsByCategory` |
| ✗ | ✗ | `getGoodsByOshi` |
