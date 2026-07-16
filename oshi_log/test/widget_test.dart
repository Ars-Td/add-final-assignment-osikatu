import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:oshi_log/main.dart';

void main() {
  testWidgets('アプリが起動して推しログのタイトルが表示される', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: OshiLogApp()),
    );
    expect(find.text('推しログ'), findsOneWidget);
  });
}
