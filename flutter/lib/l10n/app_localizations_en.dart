// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sout El-Qaa';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navAdd => 'Add';

  @override
  String get navComplaints => 'Complaints';

  @override
  String get navProfile => 'Profile';

  @override
  String get genericLoading => 'Fetching the latest scoop...';

  @override
  String get genericErrorMessage =>
      'We\'ve got a connection problem... try again, citizen!';

  @override
  String get genericRetry => 'Try Again';

  @override
  String get genericEmptyMessage => 'Nothing here yet, neighbor...';

  @override
  String get placeholderScreenMessage =>
      'Still setting this page up... check back soon 🐠';

  @override
  String get noInternetConnectionMessage =>
      'No internet right now... even Qaa El Hamour residents need wifi! Try again.';

  @override
  String get unauthorizedMessage =>
      'You need to sign in again, citizen — your session ended.';

  @override
  String get authLoginTitle => 'Sign In';
}
