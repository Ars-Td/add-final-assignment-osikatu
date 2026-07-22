import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/event/widgets/event_list_tab.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

Widget buildEventListTabApp(int oshiId, AppDatabase db) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: EventListTab(oshiId: oshiId)),
      ),
      GoRoute(
        path: '/oshi/:id/event/new',
        builder: (_, _) => const SizedBox(),
      ),
      GoRoute(
        path: '/oshi/:id/event/:eid',
        builder: (_, _) => const SizedBox(),
      ),
    ],
  );
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late AppDatabase db;
  late int oshiId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.into(db.oshis).insert(OshisCompanion.insert(
          name: 'テスト推し',
          coverColor: 0xFFE91E8C,
          category: 'アイドル',
          createdAt: DateTime.now().toIso8601String(),
        ));
    final oshis = await db.select(db.oshis).get();
    oshiId = oshis.first.id;
  });

  tearDown(() => db.close());

  testWidgets('イベントなしのとき空状態が表示される', (tester) async {
    await tester.pumpWidget(buildEventListTabApp(oshiId, db));
    await tester.pumpAndSettle();

    expect(find.text('イベントはまだありません'), findsOneWidget);
  });

  testWidgets('イベントを登録するとリストに表示される', (tester) async {
    await db.into(db.events).insert(EventsCompanion.insert(
          oshiId: oshiId,
          name: 'テストコンサート',
          date: '2026-08-01',
          category: 'コンサート',
          createdAt: DateTime.now().toIso8601String(),
        ));

    await tester.pumpWidget(buildEventListTabApp(oshiId, db));
    await tester.pumpAndSettle();

    expect(find.text('テストコンサート'), findsOneWidget);
    expect(find.text('2026/08/01　コンサート'), findsOneWidget);
  });
}
