import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/oshi/pages/oshi_list_page.dart';
import 'package:oshi_log/main.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';
import 'package:oshi_log/shared/router/app_router.dart';

void main() {
  testWidgets('アプリが起動して推し一覧が表示される', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    // スプラッシュをスキップして直接 / へ
    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const OshiListPage()),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          routerProvider.overrideWithValue(testRouter),
        ],
        child: const OshiLogApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('推し一覧'), findsOneWidget);
    await db.close();
  });
}
