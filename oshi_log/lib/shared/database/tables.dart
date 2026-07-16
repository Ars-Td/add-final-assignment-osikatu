import 'package:drift/drift.dart';

/// 推しテーブル
class Oshis extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconPath => text().nullable()();
  IntColumn get coverColor => integer()();
  TextColumn get birthday => text().nullable()();
  TextColumn get category => text()(); // アイドル/俳優/VTuber/アニメ/その他
  TextColumn get memo => text().nullable()();
  BoolColumn get isGroup => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get lastViewedAt => text().nullable()();
}

/// イベントテーブル
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get oshiId => integer().references(Oshis, #id)();
  TextColumn get name => text()();
  TextColumn get date => text()(); // ISO 8601
  TextColumn get venue => text().nullable()();
  TextColumn get category => text()(); // コンサート/舞台/握手会/配信/その他
  IntColumn get totalAmount => integer().withDefault(const Constant(0))();
  TextColumn get memo => text().nullable()();
  /// 写真パスの JSON 配列（例: '["path1","path2"]'）。null = 写真なし
  TextColumn get photoPaths => text().nullable()();
  TextColumn get createdAt => text()();
}

/// イベント支出内訳テーブル
class EventExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id)();
  TextColumn get label => text()(); // チケット/交通費/宿泊費/その他
  IntColumn get amount => integer()();
}

/// グッズテーブル
class Goods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get oshiId => integer().references(Oshis, #id)();
  TextColumn get name => text()();
  TextColumn get purchaseDate => text()(); // ISO 8601
  TextColumn get category => text()(); // CD/Blu-ray/写真集/アパレル/アクセサリー/雑貨/その他
  IntColumn get amount => integer()();
  TextColumn get shop => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get createdAt => text()();
}

/// 貯金プランテーブル
class SavingPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get oshiId => integer().references(Oshis, #id)();
  TextColumn get name => text()();
  TextColumn get startDate => text()(); // ISO 8601
  TextColumn get goalDate => text().nullable()();
  IntColumn get goalAmount => integer().nullable()();
  IntColumn get dailyAmount => integer()();
  TextColumn get createdAt => text()();
}

/// 貯金記録テーブル
class SavingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(SavingPlans, #id)();
  TextColumn get date => text()(); // ISO 8601 (YYYY-MM-DD)
  IntColumn get amount => integer()();
  TextColumn get createdAt => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {planId, date},
      ];
}
