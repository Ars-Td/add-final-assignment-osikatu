# Phase 6: 支出サマリー

## 目的

イベント・グッズの支出データを集計し、月次・年次・推しごとのサマリーをグラフ付きで表示する。

---

## データ集計設計

### SummaryRepository（新規）

| メソッド | 内容 |
|---|---|
| `getMonthlyTotal(year, month)` | 指定月の全支出合計 |
| `getMonthlyByOshi(year, month)` | 指定月の推しごと支出 Map<oshiId, amount> |
| `getYearlyMonthly(year)` | 年間月別支出 List<(month, amount)> |
| `getOshiTotal(oshiId)` | 推しへの累計支出 |
| `getOshiMonthly(oshiId, year)` | 推しの年間月別支出 |

集計対象:
- イベント: `events.totalAmount`
- グッズ: `goods.amount * goods.quantity`

---

## Provider 設計

```dart
// 現在選択中の年月
final selectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);

// 月次合計
final monthlyTotalProvider = FutureProvider<int>

// 月次推しごと内訳
final monthlyByOshiProvider = FutureProvider<List<_OshiAmount>>

// 年間月別推移
final yearlyMonthlyProvider = FutureProvider<List<int>> // index=月-1

// 推し一覧（サマリー用）
final oshiListForSummaryProvider = FutureProvider<List<Oshi>>
```

---

## 画面設計

### SummaryPage

`DefaultTabController(length: 2)` で以下タブを切り替え:

**タブ1: 月次サマリー**
- 年月セレクター（前月/翌月ボタン）
- 総支出額（大きく表示）
- 推しごと内訳（PieChart または BarChart）
  - fl_chart の `PieChartData` を使用
  - 凡例（推し名・金額・割合）

**タブ2: 年次サマリー**
- 年セレクター（前年/翌年ボタン）
- 年間総支出額
- 月別棒グラフ（BarChart）
  - 1〜12月の棒グラフ
  - タップで月次サマリーへ遷移

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] `flutter test` で既存テストが引き続きパスすること（全38件）
