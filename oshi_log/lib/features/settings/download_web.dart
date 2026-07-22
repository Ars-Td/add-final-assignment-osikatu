import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Web 用ダウンロード実装（dart:html 非推奨につき package:web に移行）
void downloadFile(List<int> bytes, String filename, String mimeType) {
  final uint8List = Uint8List.fromList(bytes);
  final blob = web.Blob(
    [uint8List.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = filename;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
