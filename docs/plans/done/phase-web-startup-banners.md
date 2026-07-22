# Web 起動時バナー通知（誕生日・イベント前日）

## 目的

spec.md §8 / tasks.md Phase 8 で定義されているが未実装だった以下を実現する。

- 推しの誕生日通知（当日）／ Web は画面内バナーで代替
- イベント前日リマインド通知／ Web は画面内バナーで代替

ネイティブでは `NotificationService` がシステム通知をスケジュールするが、
Web ではブラウザ制約でスケジュール通知が使えない。
代わりにアプリ起動直後（ホーム画面表示時）に DB を参照してバナーを表示する。

## 完了条件

- [x] `WebBannerService` シングルトンを新規作成（`lib/shared/notifications/web_banner_service.dart`）
  - `kIsWeb` ガード（ネイティブでは即リターン）
  - `_shown` フラグで 1 セッション 1 回のみ実行
  - 今日が誕生日の推し → `showBirthdayBanner`
  - 明日がイベント日 → `showEventReminderBanner`
- [x] `OshiListPage` を `ConsumerStatefulWidget` に変換し、`initState` の `addPostFrameCallback` で `WebBannerService.instance.showStartupBanners` を呼び出す

## 変更ファイル

- `lib/shared/notifications/web_banner_service.dart`（新規）
- `lib/features/oshi/pages/oshi_list_page.dart`

## 動作フロー（Web）

```
アプリ起動
  └── OshiListPage が表示される
        └── initState → addPostFrameCallback
              └── WebBannerService.showStartupBanners(context, db)
                    ├── 今日の月日と一致する誕生日の推し → showBirthdayBanner
                    └── 明日の日付に一致するイベント → showEventReminderBanner
```

## 設計上の注意

- `context.mounted` を各 `await` 後にチェックして、ページ遷移後に無効な context でバナーを表示しないようにしている
- 複数の誕生日・イベントがある場合は 3 秒間隔で順番に表示
- `_shown = true` を最初にセットしているため、タブ切り替えや再 build でも重複しない
- テスト環境では `kIsWeb == false` のため即リターンし、テストへの影響はない
