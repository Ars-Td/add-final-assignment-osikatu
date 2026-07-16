import 'package:flutter/material.dart';

/// 汎用確認ダイアログを表示し、ユーザーの選択（true/false/null）を返す。
///
/// ```dart
/// final ok = await showConfirmDialog(
///   context: context,
///   title: '削除',
///   content: 'このデータを削除しますか？',
/// );
/// if (ok == true) { /* 実行 */ }
/// ```
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String cancelLabel = 'キャンセル',
  String confirmLabel = '削除',
  Color confirmColor = Colors.red,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmLabel,
              style: TextStyle(color: confirmColor),
            ),
          ),
        ],
      ),
    );
