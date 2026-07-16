import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// アイコンパスから ImageProvider を返す共通ヘルパー。
///
/// - Web  : blob URL または http URL → NetworkImage
/// - ネイティブ: ファイルパス → FileImage
/// - null または空文字: null を返す（頭文字フォールバック用）
ImageProvider? buildOshiIconImage(String? path) {
  if (path == null || path.isEmpty) return null;
  if (kIsWeb) {
    // Web の image_picker は blob: URL を返す
    return NetworkImage(path);
  }
  return FileImage(File(path));
}

/// 推しアイコンの CircleAvatar。
/// iconPath がある場合は画像、ない場合は coverColor＋頭文字を表示する。
class OshiCircleAvatar extends StatelessWidget {
  final String? iconPath;
  final String name;
  final Color coverColor;
  final double radius;

  const OshiCircleAvatar({
    super.key,
    required this.iconPath,
    required this.name,
    required this.coverColor,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final image = buildOshiIconImage(iconPath);
    return CircleAvatar(
      radius: radius,
      backgroundColor: coverColor.withValues(alpha: 0.2),
      backgroundImage: image,
      child: image == null
          ? Text(
              name.isNotEmpty ? name[0] : '?',
              style: TextStyle(
                color: coverColor,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.7,
              ),
            )
          : null,
    );
  }
}
