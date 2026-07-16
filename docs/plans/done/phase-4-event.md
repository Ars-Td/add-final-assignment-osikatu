# Phase 4: イベント管理機能

## 目的

推し詳細ページのイベントタブ・ルートから、イベントの登録・閲覧・編集・削除ができるようにする。

---

## Provider 設計

```
eventRepositoryProvider  → EventRepository(db)
eventListProvider(oshiId) → FutureProvider.family<List<Event>, int>
eventByIdProvider(id)    → FutureProvider.family<Event?, int>
eventExpensesProvider(eventId) → FutureProvider.family<List<EventExpense>, int>
```

---

## 画面設計

### 4-1. EventFormPage（登録・編集フォーム）

- ルート: `/oshi/:id/event/new`, `/oshi/:id/event/:eid/edit`
- フィールド:
  - イベント名（必須）
  - 日付（DatePicker、必須）
  - 場所・会場（任意）
  - カテゴリ（DropdownButtonFormField: コンサート/舞台/握手会/配信/その他）
  - 支出金額 合計（数値入力 ※内訳の自動合算で上書きも可）
  - 内訳リスト（チケット代/交通費/宿泊費/その他、ラベル＋金額、追加・削除）
  - メモ（任意、3行）
- 保存ロジック:
  - 新規: `insertEvent` → `insertExpense`×n
  - 編集: `updateEvent` → `deleteExpensesByEvent` → `insertExpense`×n
  - 保存後 `context.pop()`

### 4-2. EventDetailPage（詳細）

- ルート: `/oshi/:id/event/:eid`
- 表示内容:
  - AppBar（イベント名 + 編集/削除メニュー）
  - カテゴリバッジ
  - 日付
  - 場所・会場
  - 支出合計（大きめ表示）
  - 内訳一覧（ListTile）
  - メモ
- 削除: 確認ダイアログ → `deleteEvent` → `context.pop()`

### 4-3. EventListView（OshiDetailPage のイベントタブ内）

- `OshiDetailPage` のイベントタブ `_TabPlaceholder` を置き換える
- `eventListProvider(oshiId)` でリアクティブ表示
- 新しい順で ListView 表示
- 空状態: 「イベントはまだありません」+ FAB でフォームへ
- 各アイテム: 日付 / イベント名 / カテゴリ / 金額 → タップで詳細へ

---

## テスト計画

### test/event/event_form_page_test.dart
1. 新規モードで「イベントを追加」タイトルが表示される
2. 名前・日付未入力で保存するとバリデーションエラーが表示される
3. 名前と日付を入力して保存できる（DBに1件登録される）

### test/event/event_detail_page_test.dart
1. イベントデータが正しく表示される（名前・日付・金額）
2. 削除確認ダイアログが表示される

### test/event/event_list_tab_test.dart
1. イベントなしのとき空状態が表示される
2. イベントを登録するとリストに表示される

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] 上記ウィジェットテストがすべて通ること
