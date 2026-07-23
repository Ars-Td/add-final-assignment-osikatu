import 'dart:io';
import 'dart:typed_data';

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
/// iconData (Uint8List) → iconPath → 頭文字 の優先順で表示する。
/// Web ではリロード後も消えないよう iconData を優先する。
class OshiCircleAvatar extends StatelessWidget {
  final String? iconPath;
  /// Web 用: DB に保存した画像バイナリ（リロード後も表示可能）
  final Uint8List? iconData;
  final String name;
  final Color coverColor;
  final double radius;

  const OshiCircleAvatar({
    super.key,
    required this.iconPath,
    this.iconData,
    required this.name,
    required this.coverColor,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? image = iconData != null
        ? MemoryImage(iconData!)
        : buildOshiIconImage(iconPath);
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
