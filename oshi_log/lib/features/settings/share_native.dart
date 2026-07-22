import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// ネイティブ用: OS Share シートでファイルを共有する
///
/// bytes を一時ファイルに書き出し、
/// share_plus の Share.shareXFiles で OS の共有ダイアログを開く。
Future<void> shareFile(
  List<int> bytes,
  String filename,
  String mimeType,
) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  await Share.shareXFiles(
    [XFile(file.path, mimeType: mimeType, name: filename)],
    subject: filename,
  );
}

/// Web 用 `downloadFile` と同じシグネチャのスタブ（ネイティブでは使わない）
void downloadFile(List<int> bytes, String filename, String mimeType) {
  // ネイティブでは shareFile を使うため no-op
}
