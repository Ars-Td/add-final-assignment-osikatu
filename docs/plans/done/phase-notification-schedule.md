# 誕生日通知・イベント前日通知の自動スケジューリング

## 目的

spec.md §8 で定義されている通知のうち、スケジューリングが未実装だった以下 2 件を実装する。

- 推しの誕生日通知（当日 8:00 に毎年繰り返し）
- イベント前日リマインド通知（前日 20:00 に 1 回）

## 完了条件

- [x] `NotificationService` に `scheduleBirthdayNotification` / `cancelBirthdayNotification` を追加
- [x] `NotificationService` に `scheduleEventReminder` / `cancelEventReminder` を追加
- [x] `OshiRepository` に `getOshisWithBirthday()` を追加
- [x] `EventRepository` に `getUpcomingEvents({required String from})` を追加
- [x] `main.dart` 起動時に全推しの誕生日通知・今後のイベント前日通知を再スケジュール
- [x] `oshi_form_page.dart` 保存時に誕生日通知を更新（誕生日削除時はキャンセル）
- [x] `oshi_detail_page.dart` 推し削除時に誕生日通知をキャンセル
- [x] `event_form_page.dart` 保存時にイベント前日通知をスケジュール
- [x] `event_detail_page.dart` イベント削除時に前日通知をキャンセル

## 変更ファイル

- `lib/shared/notifications/notification_service.dart`
- `lib/features/oshi/oshi_repository.dart`
- `lib/features/event/event_repository.dart`
- `lib/main.dart`
- `lib/features/oshi/pages/oshi_form_page.dart`
- `lib/features/oshi/pages/oshi_detail_page.dart`
- `lib/features/event/pages/event_form_page.dart`
- `lib/features/event/pages/event_detail_page.dart`

## 通知 ID 設計

| 通知種別 | ID 範囲 |
|---|---|
| 貯金リマインダー | 10 (固定) |
| 誕生日通知 | 100 + (oshiId % 900)　→ 100〜999 |
| イベント前日通知 | 1000 + (eventId % 9000)　→ 1000〜9999 |

## 動作仕様（ネイティブ）

### 誕生日通知
- `matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime` で毎年繰り返し
- 当年の誕生日が過ぎていたら来年にスケジュール
- 推し登録・編集時に即座に再スケジュール
- 推し削除時にキャンセル

### イベント前日通知
- イベント日の前日 20:00 に 1 回だけスケジュール
- 通知時刻が過去の場合はスキップ
- イベント登録・編集時に再スケジュール
- イベント削除時にキャンセル

## Web の扱い

`kIsWeb == true` のため全スケジュール処理はスキップ。バナー通知（既存実装）で代替。
`main.dart` の `_scheduleAllNotifications()` も `if (!kIsWeb)` でガード済み。
