# 貯金目標達成時のお祝いアニメーション

## 目的

spec.md §7.3「目標達成時に達成通知 / お祝いアニメーション」を実装する。

既存の「目標達成」カード表示・バナー通知に加え、画面全体に紙吹雪アニメーションを追加する。

## 完了条件

- [x] `_ConfettiOverlay` ウィジェット（`AnimatedBuilder` + `CustomPaint`）を実装
- [x] `_ConfettiPainter` で 80 個のパーティクルを自前描画
- [x] `_PlanBodyState` に `AnimationController`（2.8 秒）を追加
- [x] `_checkIn` で目標達成時に `_confettiCtrl.forward(from: 0.0)` を呼び出す
- [x] `Stack` + `_ConfettiOverlay` で body 全体をラップ

## 変更ファイル

- `lib/features/saving/pages/saving_detail_page.dart`

## 実装の要点

### アニメーション仕様

外部パッケージ（`confetti` 等）を使わず `dart:math` + `CustomPainter` で自前実装。
Web / iOS / Android 全プラットフォームで動作する。

| パラメータ | 値 |
|---|---|
| パーティクル数 | 80個 |
| アニメーション時間 | 2.8秒 |
| フェードアウト開始 | progress 70% 以降 |
| 紙片サイズ | 6〜14px（ランダム） |
| 揺れ | sin 波で水平方向に ±12px |
| 回転 | ランダムな速度で回転 |

### カラーパレット

| 色 | カラー |
|---|---|
| ピンク（推しログ基調色） | `#E91E8C` |
| ゴールド | `#FFD700` |
| ティール | `#26A69A` |
| インディゴ | `#5C6BC0` |
| オレンジ | `#FF7043` |
| グリーン | `#66BB6A` |
| パープル | `#AB47BC` |

### 起動タイミング

```dart
// _checkIn() 内
_confettiCtrl.forward(from: 0.0); // 毎回先頭から再生
```

目標達成は基本1回のみだが、`from: 0.0` を指定することで
テストや再確認時も再生できる。

### 既存の達成表示との併用

- `Icon(Icons.celebration)` + アンバー色カード（既存）← 変更なし
- バナー通知 / システム通知（既存）← 変更なし
- 紙吹雪アニメーション（今回追加）← 上記に重ねて表示
