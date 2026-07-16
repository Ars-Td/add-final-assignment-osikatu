import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/event/pages/event_detail_page.dart';
import '../../features/event/pages/event_form_page.dart';
import '../../features/goods/pages/goods_detail_page.dart';
import '../../features/goods/pages/goods_form_page.dart';
import '../../features/oshi/pages/oshi_detail_page.dart';
import '../../features/oshi/pages/oshi_form_page.dart';
import '../../features/oshi/pages/oshi_list_page.dart';
import '../../features/saving/pages/saving_detail_page.dart';
import '../../features/saving/pages/saving_plan_form_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/summary/pages/summary_page.dart';
import '../widgets/scaffold_with_bottom_nav.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithBottomNav(navigationShell: navigationShell),
        branches: [
          // --- タブ0: 推し一覧 ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const OshiListPage(),
                routes: [
                  // 推し新規登録
                  GoRoute(
                    path: 'oshi/new',
                    builder: (context, state) => const OshiFormPage(),
                  ),
                  // 推し詳細
                  GoRoute(
                    path: 'oshi/:id',
                    builder: (context, state) => OshiDetailPage(
                      oshiId: int.parse(state.pathParameters['id']!),
                    ),
                    routes: [
                      // 推し編集
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => OshiFormPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                      // イベント新規登録
                      GoRoute(
                        path: 'event/new',
                        builder: (context, state) => EventFormPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                      // イベント詳細
                      GoRoute(
                        path: 'event/:eid',
                        builder: (context, state) => EventDetailPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                          eventId: int.parse(state.pathParameters['eid']!),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) => EventFormPage(
                              oshiId: int.parse(state.pathParameters['id']!),
                              eventId:
                                  int.parse(state.pathParameters['eid']!),
                            ),
                          ),
                        ],
                      ),
                      // グッズ新規登録
                      GoRoute(
                        path: 'goods/new',
                        builder: (context, state) => GoodsFormPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                      // グッズ詳細
                      GoRoute(
                        path: 'goods/:gid',
                        builder: (context, state) => GoodsDetailPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                          goodsId: int.parse(state.pathParameters['gid']!),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) => GoodsFormPage(
                              oshiId: int.parse(state.pathParameters['id']!),
                              goodsId:
                                  int.parse(state.pathParameters['gid']!),
                            ),
                          ),
                        ],
                      ),
                      // 貯金プラン新規登録
                      GoRoute(
                        path: 'saving/new',
                        builder: (context, state) => SavingPlanFormPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                      // 貯金詳細
                      GoRoute(
                        path: 'saving/:sid',
                        builder: (context, state) => SavingDetailPage(
                          oshiId: int.parse(state.pathParameters['id']!),
                          planId: int.parse(state.pathParameters['sid']!),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) => SavingPlanFormPage(
                              oshiId: int.parse(state.pathParameters['id']!),
                              planId:
                                  int.parse(state.pathParameters['sid']!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // --- タブ1: 支出サマリー ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/summary',
                builder: (context, state) => const SummaryPage(),
              ),
            ],
          ),
          // --- タブ2: 設定 ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    // 未定義パスのフォールバック
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('ページが見つかりません: ${state.uri}')),
    ),
  );
});
