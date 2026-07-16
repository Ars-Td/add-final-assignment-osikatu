# Phase 8: 通知機能

## 目的

4種類の通知（貯金リマインダー・誕生日・イベント前日・目標達成）を実装する。
Web では `kIsWeb` で判定し、画面内バナーで代替する。

---

## 実装方針

### ネイティブ（iOS / Android）
- `flutter_local_notifications` でスケジュール通知
- `main()` 内で初期化・権限要求

### Web
- `kIsWeb == true` のときはシステム通知の代わりに **画面内バナー** を表示
- バナーは `OverlayEntry` または `ScaffoldMessenger.showSnackBar` で実装

---

## 実装内容

### `lib/shared/notifications/notification_service.dart`
- `NotificationService` シングルトン
- `initialize()` — ネイティブのみ初期化・通知許可要求
- `showBirthdayNotification(name)` — 誕生日通知
- `showSavingReminder()` — 貯金リマインダー
- `showEventReminder(eventName)` — イベント前日通知
- `showGoalAchieved(planName)` — 目標達成通知
- `scheduleDailySavingReminder(hour, minute)` — 毎日指定時刻にリマインダー（ネイティブのみ）
- `cancelAll()` — 全通知キャンセル

### `lib/shared/notifications/in_app_banner.dart`
- `showInAppBanner(context, message, {icon})` — Web 用画面内バナー表示
  - `ScaffoldMessenger.of(context).showSnackBar` ベースで実装
  - アイコン・メッセージを表示

### `lib/shared/notifications/notification_providers.dart`
- `notificationServiceProvider` — NotificationService のシングルトン Provider

### `main.dart` 更新
- `WidgetsFlutterBinding.ensureInitialized()`
- `NotificationService().initialize()` を呼び出す

### 通知トリガー箇所の統合
| 箇所 | 通知種別 |
|---|---|
| `SavingDetailPage._checkIn()` | 貯金目標達成（`total >= goalAmount` のとき） |

---

## 完了条件

- [x] `dart analyze lib/` エラーなし
- [x] `flutter test` で既存テストが引き続きパスすること（全43件）
