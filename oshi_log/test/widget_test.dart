import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/main.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

void main() {
  testWidgets('アプリが起動して推しログのタイトルが表示される', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const OshiLogApp(),
      ),
    );
    await tester.pump();
    // MaterialApp.router の title は AppBar などに直接表示されないため、
    // OshiListPage の AppBar タイトルで確認する
    expect(find.text('推し一覧'), findsOneWidget);
    await db.close();
  });
}
