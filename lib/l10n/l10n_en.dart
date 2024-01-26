import 'l10n.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get visitors_basic_info => 'Basic information of visitors';

  @override
  String get report_screen => 'Report screen';

  @override
  String get today_visitors => 'Today\'s visitors';

  @override
  String get last_month_visitors => 'Last month\'s visitors';

  @override
  String get viewing_area => 'Viewing the area';

  @override
  String get under_negotiation => 'Under negotiation';

  @override
  String get reservations_today => 'Today\'s reservations';

  @override
  String get reservations_left => 'Reservations left';

  @override
  String get monthly_visitors => 'Monthly visitors「Year @」';

  @override
  String get first_time_visitors => 'First-time';

  @override
  String get non_first_time_visitors => 'Non-first-time';

  @override
  String get count => '...';

  @override
  String get subject => '...';
}
