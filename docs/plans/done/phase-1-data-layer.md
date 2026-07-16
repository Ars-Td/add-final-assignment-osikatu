# Phase 1: データ層 実装プラン

**作成日:** 2026年7月16日  
**対象タスク:** tasks.md Phase 1-1 / 1-2 / 1-3

---

## 1-1. データモデル定義（drift Table クラス）

drift では `Table` を継承したクラスでスキーマを定義し、`build_runner` でデータクラスを自動生成する。

### テーブル一覧

| クラス名 | テーブル名 | 概要 |
|---|---|---|
| `Oshis` | `oshis` | 推し情報 |
| `Events` | `events` | イベント情報 |
| `EventExpenses` | `event_expenses` | イベント支出内訳 |
| `Goods` | `goods` | グッズ情報 |
| `SavingPlans` | `saving_plans` | 貯金プラン |
| `SavingRecords` | `saving_records` | 貯金記録 |

### カラム設計

**Oshis**
- id: INTEGER PK autoIncrement
- name: TEXT NOT NULL
- iconPath: TEXT nullable
- coverColor: INTEGER NOT NULL (Color値)
- birthday: TEXT nullable (ISO 8601)
- category: TEXT NOT NULL
- memo: TEXT nullable
- isGroup: BOOLEAN NOT NULL DEFAULT false
- createdAt: TEXT NOT NULL
- lastViewedAt: TEXT nullable

**Events**
- id: INTEGER PK autoIncrement
- oshiId: INTEGER NOT NULL FK→oshis
- name: TEXT NOT NULL
- date: TEXT NOT NULL
- venue: TEXT nullable
- category: TEXT NOT NULL
- totalAmount: INTEGER NOT NULL DEFAULT 0
- memo: TEXT nullable
- createdAt: TEXT NOT NULL

**EventExpenses**
- id: INTEGER PK autoIncrement
- eventId: INTEGER NOT NULL FK→events
- label: TEXT NOT NULL (チケット/交通費/宿泊費/その他)
- amount: INTEGER NOT NULL

**Goods**
- id: INTEGER PK autoIncrement
- oshiId: INTEGER NOT NULL FK→oshis
- name: TEXT NOT NULL
- purchaseDate: TEXT NOT NULL
- category: TEXT NOT NULL
- amount: INTEGER NOT NULL
- shop: TEXT nullable
- quantity: INTEGER NOT NULL DEFAULT 1
- imagePath: TEXT nullable
- memo: TEXT nullable
- createdAt: TEXT NOT NULL

**SavingPlans**
- id: INTEGER PK autoIncrement
- oshiId: INTEGER NOT NULL FK→oshis
- name: TEXT NOT NULL
- startDate: TEXT NOT NULL
- goalDate: TEXT nullable
- goalAmount: INTEGER nullable
- dailyAmount: INTEGER NOT NULL
- createdAt: TEXT NOT NULL

**SavingRecords**
- id: INTEGER PK autoIncrement
- planId: INTEGER NOT NULL FK→saving_plans
- date: TEXT NOT NULL (UNIQUE per plan)
- amount: INTEGER NOT NULL
- createdAt: TEXT NOT NULL

---

## 1-2. AppDatabase（drift 接続）

- `lib/shared/database/app_database.dart` に `AppDatabase` クラスを定義
- `kIsWeb` で判定:
  - Web: `DriftIsolate` + wasm バックエンド（将来対応。現在は`WebDatabase`等）
  - 非Web: `NativeDatabase` + `path_provider`
- Riverpod の `Provider` で DI

---

## 1-3. リポジトリ層

各 feature ディレクトリ内に `*_repository.dart` を配置。

- `OshiRepository`: CRUD + 並び替え（登録順/名前順/最近閲覧順）
- `EventRepository`: CRUD + 月フィルタ + 推しごと集計
- `GoodsRepository`: CRUD + カテゴリ/月フィルタ + 集計
- `SavingRepository`: CRUD + 月集計 + ストリーク計算

---

## 完了条件

- [ ] `dart analyze lib/` でエラーなし
- [ ] 各 Repository のユニットテストがすべて通ること
