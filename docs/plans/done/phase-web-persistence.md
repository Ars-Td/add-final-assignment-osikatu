# Web 永続化対応（drift/wasm）

## 目的

`app_database.dart` で Web ビルド時に `NativeDatabase.memory()`（インメモリ）を使っていた問題を解消し、
ページリロード後もデータが失われないよう IndexedDB / OPFS に永続化する。

## 完了条件

- [x] `drift_flutter` パッケージを追加
- [x] `sqlite3.wasm`（sqlite3 3.4.0）を `web/` に配置
- [x] `drift_worker.js`（drift 2.34.2）を `web/` に配置
- [x] `app_database.dart` で `driftDatabase()` を使用し Web/ネイティブを自動切り替え

## 変更内容

### pubspec.yaml

```yaml
drift_flutter: ^0.2.4
```

### web/ ディレクトリ

```
web/
├── sqlite3.wasm        ← sqlite3 3.4.0 リリースから取得
├── drift_worker.js     ← drift 2.34.2 リリースから取得
├── favicon.png
├── index.html
└── manifest.json
```

### lib/shared/database/app_database.dart

`NativeDatabase.memory()` を廃止し `drift_flutter` の `driftDatabase()` に変更。

```dart
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'oshi_log',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
```

`driftDatabase()` は自動的に以下を選択する：
- Web: `WasmDatabase`（OPFS → IndexedDB にフォールバック）
- iOS/Android: `NativeDatabase`（SQLite ファイル）

テストコードは `AppDatabase(NativeDatabase.memory())` でオーバーライドするため変更不要。

## 実行コマンド（Windows 環境）

```
flutter pub get
flutter run -d chrome --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp
```

COOP/COEP ヘッダーがある場合は OPFS（高速）、ない場合は IndexedDB（やや低速だが永続化は保証）にフォールバックする。
