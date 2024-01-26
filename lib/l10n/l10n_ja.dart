import 'l10n.dart';

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get visitors_basic_info => '来場者の基本情報';

  @override
  String get report_screen => '報告画面';

  @override
  String get today_visitors => '本日の来場者数';

  @override
  String get last_month_visitors => '先月の来場者数';

  @override
  String get viewing_area => 'エリア観覧中';

  @override
  String get under_negotiation => '商談中';

  @override
  String get reservations_today => '本日の予約件数';

  @override
  String get reservations_left => '残りの来場予定件数';

  @override
  String get monthly_visitors => '月ごとの来場者数推移「@ 年」';

  @override
  String get first_time_visitors => '初回';

  @override
  String get non_first_time_visitors => '初回ではない';

  @override
  String get count => '名';

  @override
  String get subject => '件';
}
