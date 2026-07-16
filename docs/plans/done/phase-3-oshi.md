# Phase 3: 推し管理機能 実装プラン

**作成日:** 2026年7月16日  
**対象タスク:** tasks.md Phase 3-1 / 3-2 / 3-3

---

## Provider 設計

```
databaseProvider        → AppDatabase（シングルトン）
oshiRepositoryProvider  → OshiRepository(db)
oshiListProvider        → Stream<List<Oshi>>（watchAllOshis）
oshiSortProvider        → StateProvider<OshiSort>（登録順/名前順/最近閲覧順）
```

## 画面設計

### 3-2. 推し一覧画面（OshiListPage）
- StreamProvider でリアクティブ表示
- カード: アイコン画像・名前・カバーカラー
- ソート切り替え（AppBar の PopupMenuButton）
- 空状態 Widget（データなし時）
- FAB → `/oshi/new`

### 3-1. 推し登録・編集フォーム（OshiFormPage）
- 名前（必須）
- アイコン画像（image_picker: ギャラリー / カメラ）
- カバーカラー（flutter_colorpicker）
- 誕生日（DatePicker）
- カテゴリ（DropdownButtonFormField）
- メモ（TextField）
- 保存ボタン → insertOshi / updateOshi

### 3-3. 推し詳細画面（OshiDetailPage）
- カバーカラーのグラデーションヘッダー
- アイコン・名前・カテゴリ表示
- タブ: イベント / グッズ / 貯金（スケルトン）
- AppBar: 編集・削除メニュー

## 完了条件

- [ ] `dart analyze lib/` エラーなし
- [ ] ウィジェットテストがすべて通ること
