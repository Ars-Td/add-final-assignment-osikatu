import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/main.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

void main() {
  Widget buildApp() {
    final db = AppDatabase(NativeDatabase.memory());
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const OshiLogApp(),
    );
  }

  testWidgets('起動時に推し一覧タブが表示される', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('推し一覧'), findsWidgets);
  });

  testWidgets('ボトムナビゲーションが3タブ表示される', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('推し'), findsOneWidget);
    expect(find.text('サマリー'), findsOneWidget);
    expect(find.text('設定'), findsOneWidget);
  });

  testWidgets('サマリータブに切り替えられる', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('サマリー'));
    await tester.pumpAndSettle();

    expect(find.text('支出サマリー'), findsWidgets);
  });

  testWidgets('設定タブに切り替えられる', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsWidgets);
  });
}
