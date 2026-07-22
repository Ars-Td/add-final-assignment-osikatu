import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/oshi/pages/oshi_form_page.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

Widget buildFormApp({int? oshiId, AppDatabase? db}) {
  final testDb = db ?? AppDatabase(NativeDatabase.memory());
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => OshiFormPage(oshiId: oshiId),
      ),
    ],
  );
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(testDb)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('新規モードで「推しを追加」タイトルが表示される', (tester) async {
    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    expect(find.text('推しを追加'), findsOneWidget);
  });

  testWidgets('名前未入力で保存するとバリデーションエラーが表示される', (tester) async {
    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('名前を入力してください'), findsOneWidget);
  });

  testWidgets('名前を入力して保存できる', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(buildFormApp(db: db));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, '名前 *'), 'テスト推し');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final oshis = await db.select(db.oshis).get();
    expect(oshis.length, 1);
    expect(oshis.first.name, 'テスト推し');
    await db.close();
  });
}
