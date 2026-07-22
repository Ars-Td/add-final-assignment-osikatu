# グループ推し登録 UI

## 目的

spec.md §3.1「グループ単位・個人単位どちらでも登録可能。グループ登録時、所属メンバーを個別に追加できる」を実装する。

## 完了条件

- [x] `tables.dart` の `Oshis` テーブルに `members` カラム（JSON 配列文字列, nullable）を追加
- [x] `app_database.dart` の `schemaVersion` を 5 に更新し、v4→v5 マイグレーションで `members` カラムを追加
- [x] `oshi_form_page.dart` にグループ/個人切り替えスイッチを追加
- [x] グループ ON 時にメンバー名入力フィールドリストを表示（追加・削除ボタン付き）
- [x] `_save()` で `isGroup` と `members`（JSON）を DB に書き込む
- [x] 編集時に既存の `members` データを復元してフォームに表示
- [x] `oshi_detail_page.dart` のヘッダーにグループアイコンとメンバー一覧を表示
- [x] グループ時は誕生日フィールドを非表示（グループには誕生日不要）

## 変更ファイル

- `lib/shared/database/tables.dart`
- `lib/shared/database/app_database.dart`（schemaVersion: 4 → 5）
- `lib/features/oshi/pages/oshi_form_page.dart`
- `lib/features/oshi/pages/oshi_detail_page.dart`

## スキーマ設計

メンバーを独立テーブルにするのではなく、`Oshis.members` カラムに JSON 配列を格納する軽量設計を採用。

```
Oshis テーブル
  ...既存カラム...
  members TEXT NULL   ← '["田中太郎","山田花子"]' などの JSON 配列
```

メリット:
- マイグレーションが `addColumn` 1 回で済む
- リポジトリ・Provider の変更が不要
- JOIN 不要で高速

デメリット:
- メンバー単独での検索・フィルタはできない（spec 上の要件なし）

## UI 仕様

### フォーム

```
[グループとして登録 ○/●]
グループ名 *: ____________
メンバー
  メンバー 1: ___________  [×]
  メンバー 2: ___________  [×]
  [+ 追加]
カバーカラー: ●
カテゴリ: [アイドル ▼]
※ グループ時は誕生日フィールドを非表示
メモ: ________________
```

### 詳細ページヘッダー

```
[グループアイコン写真]
グループ名
[👥] カテゴリ
メンバーA · メンバーB · メンバーC  ← 最大2行
```

## 注意: build_runner でのコード再生成が必要

`tables.dart` に新しいカラムを追加したため、`app_database.g.dart` の再生成が必要。

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

または Windows 環境から:

```
flutter pub run build_runner build --delete-conflicting-outputs
```

再生成なしにそのままビルドすると `members` カラムが `_$AppDatabase` のコード内に存在せずコンパイルエラーになる。
