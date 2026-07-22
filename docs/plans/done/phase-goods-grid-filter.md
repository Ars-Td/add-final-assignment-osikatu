# グッズ一覧 グリッド表示・フィルタ対応

## 目的

spec.md §5.2 で定義されている「グリッド / リスト 表示切り替え」「カテゴリ・月・期間フィルタリング」を実装する。

## 完了条件

- [x] `goods_providers.dart` に `GoodsViewMode`, `GoodsSort`, `GoodsMonthFilter`, `GoodsMonthFilterProvider`, `GoodsSortProvider`, `GoodsViewModeProvider`, `GoodsCategoryFilterProvider` を追加
- [x] `goodsListProvider` をソート・フィルタ対応に刷新
- [x] `goods_list_tab.dart` にツールバー（月フィルタ / カテゴリ / ソート / グリッド切り替え）を実装
- [x] `_GoodsGridView` / `_GoodsGridCard` でグリッドビューを実装（2カラム、写真サムネイル表示）
- [x] `goods_list_tab_test.dart` にグリッド/リスト切り替えテストを追加

## 変更ファイル

- `lib/features/goods/goods_providers.dart`
- `lib/features/goods/widgets/goods_list_tab.dart`
- `test/goods/goods_list_tab_test.dart`

## 実装の要点

### ツールバー構成

```
[全期間チップ] [カテゴリチップ]   [並び替え] [グリッド/リスト] [追加]
```

### グリッドビュー

- `GridView.builder` + `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)`
- `childAspectRatio: 0.82` でカード縦長配置
- 写真あり → `photoPaths` の先頭画像をサムネイルに表示（`imagePath` レガシー互換あり）
- 写真なし → `primaryContainer` 背景 + ショッピングバッグアイコン

### フィルタ動作

| フィルタ | 優先順位 |
|---|---|
| 月フィルタ | 最高（カテゴリより優先） |
| カテゴリフィルタ | 月フィルタなし時に適用 |
| ソート | 常時適用 |

### テスト追加

`グリッド/リスト切り替えボタンでビューが変わる` テストを追加。
`find.byTooltip('グリッド表示')` → tap → `find.byType(GridView)` で検証。
