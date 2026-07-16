/// ネイティブ / テスト環境用スタブ
/// ダウンロード機能は何もしない（クリップボードコピーで代替）
void downloadFile(List<int> bytes, String filename, String mimeType) {
  // no-op on non-web
}
