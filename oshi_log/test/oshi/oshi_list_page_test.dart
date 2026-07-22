import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/oshi/pages/oshi_list_page.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

/// テスト用 AppDatabase（インメモリ）でオーバーライドしたアプリを返す
Widget buildTestApp({AppDatabase? db}) {
  final testDb = db ?? AppDatabase(NativeDatabase.memory());
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const OshiListPage(),
      ),
      GoRoute(path: '/oshi/new', builder: (_, _) => const SizedBox()),
      GoRoute(path: '/oshi/:id', builder: (_, _) => const SizedBox()),
    ],
  );
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(testDb),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('データなしのとき空状態ビューが表示される', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('推しがまだいません'), findsOneWidget);
  });

  testWidgets('推しを登録するとカードが表示される', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.into(db.oshis).insert(OshisCompanion.insert(
      name: 'テスト推し',
      coverColor: 0xFFE91E8C,
      category: 'アイドル',
      createdAt: '2026-07-16T00:00:00.000Z',
    ));

    await tester.pumpWidget(buildTestApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('テスト推し'), findsOneWidget);
    expect(find.text('アイドル'), findsOneWidget);
    await db.close();
  });

  testWidgets('FABが表示される', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('推しを追加'), findsOneWidget);
  });

  testWidgets('ソートメニューが開く', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();

    expect(find.text('登録順'), findsOneWidget);
    expect(find.text('名前順'), findsOneWidget);
    expect(find.text('最近閲覧順'), findsOneWidget);
  });
}
