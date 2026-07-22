# エクスポート: OS Share シート対応

## 目的

spec.md §9.2「エクスポートファイルの共有 UI（Share シート）」を実装する。

ネイティブ（iOS / Android）では `share_plus` を使って OS の共有ダイアログを表示し、
メール・AirDrop・ファイルアプリ等にエクスポートできるようにする。

## 完了条件

- [x] `pubspec.yaml` に `share_plus: ^10.1.4` を追加
- [x] `lib/features/settings/share_native.dart` を新規作成（ネイティブ用共有実装）
- [x] `export_service.dart` の条件付きインポートを `share_native.dart` / `download_web.dart` に変更
- [x] `export_service.dart` の `downloadOrCopy` でネイティブ時に `shareFile()` を呼び出す

## 変更ファイル

- `pubspec.yaml`
- `lib/features/settings/export_service.dart`
- `lib/features/settings/share_native.dart`（新規）
- `lib/features/settings/download_web.dart`（参照のみ、変更なし）

## アーキテクチャ

条件付きインポートで Web / ネイティブを自動切り替え：

```
export_service.dart
  import 'share_native.dart'          // ネイティブ: shareFile() を提供
    if (dart.library.js_interop)       // Web 判定
      'download_web.dart';            // Web: downloadFile() を提供
```

| 環境 | 使用ファイル | 動作 |
|---|---|---|
| Web | `download_web.dart` | Blob + `<a download>` でブラウザダウンロード |
| iOS / Android | `share_native.dart` | 一時ファイル書き出し + OS Share シート |

## share_plus の使用方法

```dart
await SharePlus.instance.shareXFiles(
  [XFile(file.path, mimeType: mimeType, name: filename)],
  subject: filename,
);
```

`shareXFiles` は iOS では Share シート、Android では Intent Chooser を表示する。
ユーザーはメール・メッセージ・AirDrop・Dropbox・Files 等から送信先を選択できる。

## 旧実装との比較

| | 旧実装 | 新実装 |
|---|---|---|
| ネイティブ | クリップボードコピー | OS Share シート |
| Web | ブラウザダウンロード | 変更なし |
