import 'dart:convert';

/// photoPaths カラム（JSON 文字列）とパスリストを相互変換するユーティリティ。
///
/// DB に保存する形式: `'["path1","path2"]'`
/// null または空 JSON は空リストとして扱う。

/// JSON 文字列 → パスリスト
List<String> decodePhotoPaths(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is List) {
      return decoded.cast<String>();
    }
  } catch (_) {}
  return [];
}

/// パスリスト → JSON 文字列（空リストは null を返す）
String? encodePhotoPaths(List<String> paths) {
  if (paths.isEmpty) return null;
  return jsonEncode(paths);
}
