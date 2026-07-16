import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/event/pages/event_form_page.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

Widget buildEventFormApp({int oshiId = 1, int? eventId, AppDatabase? db}) {
  final testDb = db ?? AppDatabase(NativeDatabase.memory());
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) =>
            EventFormPage(oshiId: oshiId, eventId: eventId),
      ),
    ],
  );
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(testDb)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('新規モードで「イベントを追加」タイトルが表示される', (tester) async {
    await tester.pumpWidget(buildEventFormApp());
    await tester.pumpAndSettle();

    expect(find.text('イベントを追加'), findsOneWidget);
  });

  testWidgets('名前未入力で保存するとバリデーションエラーが表示される', (tester) async {
    await tester.pumpWidget(buildEventFormApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('イベント名を入力してください'), findsOneWidget);
  });

  testWidgets('名前と日付を入力して保存できる', (tester) async {
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

    await tester.pumpWidget(buildEventFormApp(oshiId: oshiId, db: db));
    await tester.pumpAndSettle();

    // イベント名を入力
    await tester.enterText(
        find.widgetWithText(TextFormField, 'イベント名 *'), 'テストコンサート');

    // 日付を選択（カレンダーアイコンをタップ）
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 保存
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final events = await db.select(db.events).get();
    expect(events.length, 1);
    expect(events.first.name, 'テストコンサート');
    await db.close();
  });
}
