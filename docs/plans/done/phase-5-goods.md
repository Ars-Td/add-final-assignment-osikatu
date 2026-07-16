# Phase 5: グッズ管理機能

## 目的

推し詳細ページのグッズタブ・ルートから、グッズの登録・閲覧・編集・削除ができるようにする。

---

## Provider 設計

```
goodsRepositoryProvider  → GoodsRepository(db)
goodsListProvider(oshiId) → FutureProvider.family<List<Good>, int>
goodsByIdProvider(id)    → FutureProvider.family<Good?, int>
```

---

## 画面設計

### 5-1. GoodsFormPage（登録・編集フォーム）

- ルート: `/oshi/:id/goods/new`, `/oshi/:id/goods/:gid/edit`
- フィールド:
  - グッズ名（必須）
  - 購入日（DatePicker、必須）
  - カテゴリ（DropdownButtonFormField: CD/Blu-ray/写真集/アパレル/アクセサリー/雑貨/その他）
  - 金額（数値入力、必須）
  - 数量（数値入力、デフォルト1）
  - 購入場所（任意）
  - メモ（任意、3行）
- 保存ロジック:
  - 新規: `insertGoods`
  - 編集: `updateGoods`
  - 保存後 `context.pop()`

### 5-2. GoodsDetailPage（詳細）

- ルート: `/oshi/:id/goods/:gid`
- 表示内容:
  - AppBar（グッズ名 + 編集/削除メニュー）
  - カテゴリバッジ
  - 購入日
  - 購入場所
  - 金額・数量・合計
  - メモ
- 削除: 確認ダイアログ → `deleteGoods` → `context.pop()`

### 5-3. GoodsListTab（OshiDetailPage のグッズタブ内）

- `OshiDetailPage` のグッズタブ `EmptyStateView` を置き換える
- `goodsListProvider(oshiId)` でリアクティブ表示
- 購入日の新しい順で ListView 表示
- 空状態: 「グッズはまだありません」+ ボタン
- 各アイテム: 購入日 / グッズ名 / カテゴリ / 金額 → タップで詳細へ

---

## テスト計画

### test/goods/goods_form_page_test.dart
1. 新規モードで「グッズを追加」タイトルが表示される
2. 名前未入力で保存するとバリデーションエラーが表示される
3. 名前と購入日と金額を入力して保存できる（DBに1件登録される）

### test/goods/goods_list_tab_test.dart
1. グッズなしのとき空状態が表示される
2. グッズを登録するとリストに表示される

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] 上記ウィジェットテストがすべて通ること（全38件）
