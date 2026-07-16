import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/router/app_router.dart';

void main() {
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
    return MaterialApp.router(
      title: '推しログ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E8C)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
