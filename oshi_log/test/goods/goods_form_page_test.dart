import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/goods/pages/goods_form_page.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

Widget buildGoodsFormApp({int oshiId = 1, int? goodsId, AppDatabase? db}) {
  final testDb = db ?? AppDatabase(NativeDatabase.memory());
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) =>
            GoodsFormPage(oshiId: oshiId, goodsId: goodsId),
      ),
    ],
  );
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(testDb)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('新規モードで「グッズを追加」タイトルが表示される', (tester) async {
    await tester.pumpWidget(buildGoodsFormApp());
    await tester.pumpAndSettle();

    expect(find.text('グッズを追加'), findsOneWidget);
  });

  testWidgets('名前未入力で保存するとバリデーションエラーが表示される', (tester) async {
    await tester.pumpWidget(buildGoodsFormApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('グッズ名を入力してください'), findsOneWidget);
  });

  testWidgets('名前と購入日と金額を入力して保存できる', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    // テスト用の推しを事前に登録
    await db.into(db.oshis).insert(OshisCompanion.insert(
          name: 'テスト推し',
          coverColor: 0xFFE91E8C,
          category: 'アイドル',
          createdAt: DateTime.now().toIso8601String(),
        ));
    final oshis = await db.select(db.oshis).get();
    final oshiId = oshis.first.id;

    await tester.pumpWidget(buildGoodsFormApp(oshiId: oshiId, db: db));
    await tester.pumpAndSettle();

    // グッズ名を入力
    await tester.enterText(
        find.widgetWithText(TextFormField, 'グッズ名 *'), 'テストCD');

    // 金額を入力
    await tester.enterText(
        find.widgetWithText(TextFormField, '金額 *（円）'), '3000');

    // 購入日を選択（カレンダーアイコンをタップ）
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 保存
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final goodsList = await db.select(db.goods).get();
    expect(goodsList.length, 1);
    expect(goodsList.first.name, 'テストCD');
    expect(goodsList.first.amount, 3000);
    await db.close();
  });
}
