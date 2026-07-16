import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/notifications/notification_service.dart';
import 'shared/router/app_router.dart';

/// テーマモード（ライト / ダーク / システム）
final themeModeProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// アプリ全体のシードカラー
const _seedColor = Color(0xFFE91E8C);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  runApp(
    const ProviderScope(
      child: OshiLogApp(),
    ),
  );
}

class OshiLogApp extends ConsumerWidget {
  const OshiLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: '推しログ',
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
