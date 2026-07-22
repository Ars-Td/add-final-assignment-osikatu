# 月次サマリー カテゴリ別棒グラフ

## 目的

spec.md §6.1「内訳をカテゴリ別に円グラフ / 棒グラフで表示（イベント費・グッズ費）」を実装する。

既存の推しごと円グラフに加え、カテゴリ別（イベント費・グッズ費）棒グラフを月次タブに追加する。

## 完了条件

- [x] `SummaryRepository` に `getMonthlyCategoryBreakdown(year, month)` を追加
  - イベント費（events.totalAmount の合計）
  - グッズ費（goods.amount × quantity の合計）
- [x] `CategoryAmount` データクラスを `summary_repository.dart` に定義
- [x] `summary_providers.dart` に `monthlyCategoryProvider` を追加
- [x] `summary_page.dart` の月次タブに `_CategoryBarSection` ウィジェットを追加
- [x] `summary_repository_test.dart` にカテゴリ別テストを追加

## 変更ファイル

- `lib/features/summary/summary_repository.dart`
- `lib/features/summary/summary_providers.dart`
- `lib/features/summary/pages/summary_page.dart`
- `test/summary/summary_repository_test.dart`

## 月次タブの表示順

```
[年月セレクター]
[総支出カード]
[カテゴリ別棒グラフ] ← 新規追加
  イベント費 ■ / グッズ費 ■
[推しごと円グラフ]（既存）
```

## 実装の要点

### 棒グラフ設定

- `BarChart` 2本（イベント費・グッズ費）
- 幅 40px、上角丸 6px
- イベント費: インディゴ `#5C6BC0` / グッズ費: ティール `#26A69A`
- タップでツールチップ（金額表示）
- データなし（両方 0）のときは非表示

### カラーパレット

| カテゴリ | カラー |
|---|---|
| イベント費 | `Color(0xFF5C6BC0)` インディゴ |
| グッズ費 | `Color(0xFF26A69A)` ティール |
