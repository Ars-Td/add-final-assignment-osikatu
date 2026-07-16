# Phase 2-2: ナビゲーション 実装プラン

**作成日:** 2026年7月16日  
**対象タスク:** tasks.md Phase 2-2

---

## ルート設計

ボトムナビゲーションは StatefulShellRoute で 3 タブ構成。

| タブ | パス | 画面 |
|---|---|---|
| 推し一覧 | `/` | OshiListPage |
| 支出サマリー | `/summary` | SummaryPage |
| 設定 | `/settings` | SettingsPage |

### ネストルート

```
/                     → OshiListPage
/oshi/new             → OshiFormPage（新規）
/oshi/:id             → OshiDetailPage
/oshi/:id/edit        → OshiFormPage（編集）
/oshi/:id/event/new   → EventFormPage
/oshi/:id/event/:eid  → EventDetailPage
/oshi/:id/event/:eid/edit → EventFormPage（編集）
/oshi/:id/goods/new   → GoodsFormPage
/oshi/:id/goods/:gid  → GoodsDetailPage
/oshi/:id/goods/:gid/edit → GoodsFormPage（編集）
/oshi/:id/saving/new  → SavingPlanFormPage
/oshi/:id/saving/:sid → SavingDetailPage
/summary              → SummaryPage
/settings             → SettingsPage
```

## ファイル構成

```
lib/
  shared/
    router/
      app_router.dart   # go_router の定義（Riverpod Provider）
  features/
    oshi/
      pages/
        oshi_list_page.dart
        oshi_detail_page.dart
        oshi_form_page.dart
    event/
      pages/
        event_detail_page.dart
        event_form_page.dart
    goods/
      pages/
        goods_detail_page.dart
        goods_form_page.dart
    saving/
      pages/
        saving_detail_page.dart
        saving_plan_form_page.dart
    summary/
      pages/
        summary_page.dart
    settings/
      pages/
        settings_page.dart
  shared/
    widgets/
      scaffold_with_bottom_nav.dart  # StatefulShellRoute 用シェル
```

## 完了条件

- [ ] `flutter test` でナビゲーションのウィジェットテストが通ること
- [ ] `dart analyze lib/` でエラーなし
- [ ] 3 タブ間を遷移できること（手動確認）
