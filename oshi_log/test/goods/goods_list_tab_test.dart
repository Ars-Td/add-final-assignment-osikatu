import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oshi_log/features/goods/widgets/goods_list_tab.dart';
import 'package:oshi_log/shared/database/app_database.dart';
import 'package:oshi_log/shared/database/database_provider.dart';

Widget buildGoodsListTabApp(int oshiId, AppDatabase db) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(body: GoodsListTab(oshiId: oshiId)),
      ),
      GoRoute(
        path: '/oshi/:id/goods/new',
        builder: (_, __) => const SizedBox(),
      ),
      GoRoute(
        path: '/oshi/:id/goods/:gid',
        builder: (_, __) => const SizedBox(),
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

  testWidgets('グッズなしのとき空状態が表示される', (tester) async {
    await tester.pumpWidget(buildGoodsListTabApp(oshiId, db));
    await tester.pumpAndSettle();

    expect(find.text('グッズはまだありません'), findsOneWidget);
  });

  testWidgets('グッズを登録するとリストに表示される', (tester) async {
    await db.into(db.goods).insert(GoodsCompanion.insert(
          oshiId: oshiId,
          name: 'テストCD',
          purchaseDate: '2026-08-01',
          category: 'CD',
          amount: 3000,
          createdAt: DateTime.now().toIso8601String(),
        ));

    await tester.pumpWidget(buildGoodsListTabApp(oshiId, db));
    await tester.pumpAndSettle();

    expect(find.text('テストCD'), findsOneWidget);
    expect(find.text('2026/08/01　CD'), findsOneWidget);
  });

  testWidgets('グリッド/リスト切り替えボタンでビューが変わる', (tester) async {
    await db.into(db.goods).insert(GoodsCompanion.insert(
          oshiId: oshiId,
          name: 'テストグッズ',
          purchaseDate: '2026-08-01',
          category: 'アパレル',
          amount: 5000,
          createdAt: DateTime.now().toIso8601String(),
        ));

    await tester.pumpWidget(buildGoodsListTabApp(oshiId, db));
    await tester.pumpAndSettle();

    // 初期状態はリスト表示 → GridView がない
    expect(find.byType(GridView), findsNothing);
    expect(find.byType(ListView), findsOneWidget);

    // グリッド表示に切り替え
    await tester.tap(find.byTooltip('グリッド表示'));
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);

    // リスト表示に戻す
    await tester.tap(find.byTooltip('リスト表示'));
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
  });
}
