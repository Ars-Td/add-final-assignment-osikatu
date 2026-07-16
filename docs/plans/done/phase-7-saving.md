# Phase 7: 推し貯金機能

## 目的

推しごとに貯金プランを作成し、毎日チェックインして累計額・進捗・カレンダーヒートマップで可視化する。

---

## Provider 設計

```dart
savingRepositoryProvider → SavingRepository(db)
planListProvider(oshiId)  → FutureProvider.family<List<SavingPlan>, int>
planByIdProvider(planId)  → FutureProvider.family<SavingPlan?, int>
recordsProvider(planId)   → FutureProvider.family<List<SavingRecord>, int>
totalAmountProvider(planId) → FutureProvider.family<int, int>
streakProvider(planId)    → FutureProvider.family<int, int>
```

---

## 画面設計

### 7-1. SavingPlanFormPage（プラン登録・編集）

- ルート: `/oshi/:id/saving/new`, `/oshi/:id/saving/:sid/edit`
- フィールド:
  - 貯金名（必須）
  - 開始日（DatePicker、必須）
  - 目標日（DatePicker、任意）
  - 目標金額（数値、任意）
  - 1日あたりの基本貯金額（必須）
- 保存後 `context.pop()`

### 7-2. SavingDetailPage（詳細・チェックイン）

- ルート: `/oshi/:id/saving/:sid`
- 上部: AppBar（プラン名 + 編集/削除メニュー）
- セクション1 — 進捗
  - 累計貯金額 / 目標金額（目標があれば）
  - LinearProgressIndicator（目標額に対する進捗）
  - 連続貯金日数（ストリーク）バッジ
- セクション2 — 今日のチェックイン
  - 金額フィールド（デフォルト = dailyAmount）
  - 「今日も貯金した！」ボタン（今日済みなら無効化）
- セクション3 — カレンダーヒートマップ
  - 当月のカレンダー表示（貯金した日を色付け）
  - 月ナビゲーション（前月/翌月）
- セクション4 — 月別合計
  - 過去3ヶ月の合計額リスト

### 7-3. SavingListTab（OshiDetailPage の貯金タブ）

- `EmptyStateView` を置き換え
- `planListProvider(oshiId)` で一覧表示
- 各プランカード: プラン名・累計額・進捗バー・ストリーク

---

## テスト計画

### test/saving/saving_plan_form_page_test.dart
1. 新規モードで「貯金プランを追加」タイトルが表示される
2. 名前未入力で保存するとバリデーションエラーが表示される
3. 名前と開始日と日割り額を入力して保存できる

### test/saving/saving_list_tab_test.dart
1. プランなしのとき空状態が表示される
2. プランを登録するとリストに表示される

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] 上記ウィジェットテストがすべて通ること（全43件）
