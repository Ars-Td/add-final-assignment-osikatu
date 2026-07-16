import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/main.dart';

void main() {
  Widget buildApp() => const ProviderScope(child: OshiLogApp());

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
