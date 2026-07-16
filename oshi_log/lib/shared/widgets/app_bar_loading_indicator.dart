import 'package:flutter/material.dart';

/// AppBar の actions 内で使うローディングインジケーター。
/// フォームの保存処理中などに `TextButton('保存')` の代わりに表示する。
class AppBarLoadingIndicator extends StatelessWidget {
  const AppBarLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
