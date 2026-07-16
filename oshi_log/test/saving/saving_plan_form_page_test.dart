import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/saving/pages/saving_plan_form_page.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

Widget buildSavingFormApp(
    {int oshiId = 1, int? planId, AppDatabase? db}) {
  final testDb = db ?? AppDatabase(NativeDatabase.memory());
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) =>
            SavingPlanFormPage(oshiId: oshiId, planId: planId),
      ),
    ],
  );
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(testDb)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('新規モードで「貯金プランを追加」タイトルが表示される', (tester) async {
    await tester.pumpWidget(buildSavingFormApp());
    await tester.pumpAndSettle();

    expect(find.text('貯金プランを追加'), findsOneWidget);
  });

  testWidgets('名前未入力で保存するとバリデーションエラーが表示される', (tester) async {
    await tester.pumpWidget(buildSavingFormApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('貯金名を入力してください'), findsOneWidget);
  });

  testWidgets('名前と開始日と日割り額を入力して保存できる', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.into(db.oshis).insert(OshisCompanion.insert(
          name: 'テスト推し',
          coverColor: 0xFFE91E8C,
          category: 'アイドル',
          createdAt: DateTime.now().toIso8601String(),
        ));
    final oshis = await db.select(db.oshis).get();
    final oshiId = oshis.first.id;

    await tester.pumpWidget(buildSavingFormApp(oshiId: oshiId, db: db));
    await tester.pumpAndSettle();

    // 貯金名を入力
    await tester.enterText(
        find.widgetWithText(TextFormField, '貯金名 *'), 'テスト貯金');

    // 1日あたりの貯金額を入力
    await tester.enterText(
        find.widgetWithText(TextFormField, '1日あたりの貯金額 *（円）'), '100');

    // 開始日を選択
    await tester.tap(find.byIcon(Icons.calendar_today).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 保存
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final plans = await db.select(db.savingPlans).get();
    expect(plans.length, 1);
    expect(plans.first.name, 'テスト貯金');
    expect(plans.first.dailyAmount, 100);
    await db.close();
  });
}
