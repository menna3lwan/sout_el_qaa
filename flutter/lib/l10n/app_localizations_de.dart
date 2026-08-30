// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sout El-Qaa';

  @override
  String get navHome => 'Start';

  @override
  String get navMap => 'Karte';

  @override
  String get navAdd => 'Neu';

  @override
  String get navComplaints => 'Beschwerden';

  @override
  String get navProfile => 'Profil';

  @override
  String get genericLoading => 'Wir holen die neuesten Infos...';

  @override
  String get genericErrorMessage =>
      'Verbindungsproblem... bitte noch einmal versuchen!';

  @override
  String get genericRetry => 'Erneut versuchen';

  @override
  String get genericEmptyMessage => 'Hier ist noch nichts, Nachbar...';

  @override
  String get placeholderScreenMessage =>
      'Diese Seite wird noch vorbereitet... schau bald wieder vorbei 🐠';

  @override
  String get noInternetConnectionMessage =>
      'Gerade kein Internet... selbst die Bewohner von Qaa El Hamour brauchen WLAN! Bitte erneut versuchen.';

  @override
  String get unauthorizedMessage =>
      'Bitte erneut anmelden — deine Sitzung ist abgelaufen.';

  @override
  String get genericCancel => 'Abbrechen';

  @override
  String get genericConfirm => 'Bestätigen';

  @override
  String get genericNext => 'Weiter';

  @override
  String get genericBack => 'Zurück';

  @override
  String get genericSave => 'Speichern';

  @override
  String get genericOptional => 'Optional';

  @override
  String get validationRequired => 'Dieses Feld ist erforderlich';

  @override
  String get validationInvalidEmail => 'Diese E-Mail sieht nicht richtig aus';

  @override
  String get validationPasswordTooShort =>
      'Das Passwort muss mindestens 8 Zeichen haben';

  @override
  String get validationPasswordTooWeak =>
      'Das Passwort muss Buchstaben und Ziffern enthalten';

  @override
  String get validationPasswordMismatch =>
      'Die Passwörter stimmen nicht überein';

  @override
  String get validationTooLong => 'Das ist länger als erlaubt';

  @override
  String get authLoginTitle => 'Anmelden';

  @override
  String get authEmailLabel => 'E-Mail';

  @override
  String get authPasswordLabel => 'Passwort';

  @override
  String get authLoginButton => 'Anmelden';

  @override
  String get authNoAccountPrompt => 'Noch kein Konto?';

  @override
  String get authRegisterLink => 'Jetzt registrieren';

  @override
  String get authRegisterTitle => 'Neues Konto';

  @override
  String get authUsernameLabel => 'Benutzername';

  @override
  String get authConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get authRegisterButton => 'Konto erstellen';

  @override
  String get authHaveAccountPrompt => 'Schon ein Konto?';

  @override
  String get authLoginLink => 'Anmelden';

  @override
  String homeGreeting(String name) {
    return 'Guten Morgen, Bürger $name!';
  }

  @override
  String homeLocationLine(String street) {
    return 'Qaa El Hamour, $street';
  }

  @override
  String get homeCategoriesHeading => 'Beschwerdekategorien';

  @override
  String get homeSubmitComplaintCta => 'Neue Beschwerde einreichen';

  @override
  String get homeSearchHint => 'Nach einer Beschwerde suchen...';

  @override
  String get homeTrendingHeading => 'Meistbeachtete Beschwerden';

  @override
  String get homeTrendingSubheading =>
      'Was die Bewohner von Qaa El Hamour beschäftigt';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String get homeSameProblemCta => 'Ich habe dasselbe Problem';

  @override
  String homeSameProblemCount(int count) {
    return '+$count';
  }

  @override
  String get homeRecentActivityHeading =>
      'Beschwerden, die deine Stimme brauchen';

  @override
  String get homeUrgentBadge => 'Dringend';

  @override
  String homeViewsCount(int count) {
    return '$count Aufrufe';
  }

  @override
  String homeLikesCount(int count) {
    return '$count Likes';
  }

  @override
  String get complaintsFilterAll => 'Alle';

  @override
  String get complaintsFilterMine => 'Meine';

  @override
  String get complaintsFilterResolved => 'Gelöst';

  @override
  String get complaintsEmptyMessage =>
      'In diesem Bereich gibt es noch keine Beschwerden';

  @override
  String get complaintDetailsAppBarTitle => 'Beschwerdedetails';

  @override
  String get detailsTitle => 'Status der Beschwerde';

  @override
  String get detailsSectionHeading => 'Details';

  @override
  String get statusReceivedLabel => 'Eingegangen';

  @override
  String get statusInReviewLabel => 'In Prüfung';

  @override
  String get statusResolvedLabel => 'Gelöst';

  @override
  String get commentsHeading => 'Kommentare';

  @override
  String get commentInputHint => 'Schreib deinen Kommentar, Nachbar...';

  @override
  String get commentSubmit => 'Senden';

  @override
  String get commentsEmptyMessage => 'Noch keine Kommentare — sei der Erste';

  @override
  String get locationLabel => 'Standort';

  @override
  String get severityFlavorHigh => 'Nationale Katastrophe';

  @override
  String get severityFlavorMedium => 'Keine Kleinigkeit';

  @override
  String get severityFlavorLow => 'Nur ein Hinweis';

  @override
  String complaintReportsCount(int count) {
    return '$count Meldungen';
  }

  @override
  String complaintDislikesCount(int count) {
    return '$count Dislikes';
  }

  @override
  String get createComplaintTitle => 'Beschwerde einreichen';

  @override
  String get createComplaintTitleShort => 'Beschwerde senden';

  @override
  String get stepFillTitle => 'Angaben zur Beschwerde';

  @override
  String get fieldTitleLabel => 'Titel der Beschwerde';

  @override
  String get fieldTitleHint => 'Einen kurzen Titel schreiben';

  @override
  String get fieldDescriptionLabel => 'Beschreibung';

  @override
  String get fieldDescriptionHint => 'Erzähl uns, was nicht stimmt...';

  @override
  String descriptionCounter(int current, int max) {
    return '$current/$max';
  }

  @override
  String get stepCategoryTitle => 'Kategorie';

  @override
  String get stepLocationTitle => 'Standort';

  @override
  String get pickLocationOnMapButton => 'Standort auf der Karte wählen';

  @override
  String get locationSelectedLabel => 'Gewählter Standort';

  @override
  String get stepSeverityTitle => 'Schweregrad';

  @override
  String get severityHighLabel => 'Hoch';

  @override
  String get severityMediumLabel => 'Mittel';

  @override
  String get severityLowLabel => 'Niedrig';

  @override
  String get attachPhotoButton => 'Foto hinzufügen';

  @override
  String get removePhotoLabel => 'Foto entfernen';

  @override
  String get submitComplaintButton => 'Beschwerde senden';

  @override
  String get createComplaintReviewTitle => 'Beschwerde vor dem Senden prüfen';

  @override
  String get createComplaintReviewSubtitle =>
      'Sichergehen, dass alles stimmt, bevor die Bewohner sie sehen';

  @override
  String get createComplaintCancelButton => 'Beschwerde abbrechen';

  @override
  String get createComplaintEditButton => 'Beschwerde bearbeiten';

  @override
  String get successTitle =>
      'Deine Beschwerde hat den Meeresboden erreicht! 🎉';

  @override
  String get successMessage =>
      'Erfolgreich gesendet, und Thaddäus hat sie erhalten 😂';

  @override
  String get successViewComplaintButton => 'Beschwerde ansehen';

  @override
  String get successBackToHomeButton => 'Zurück zum Start';

  @override
  String get mapTitle => 'Karte';

  @override
  String get mapViewDetailsButton => 'Details ansehen';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsFilterAll => 'Alle';

  @override
  String get notificationsFilterComplaints => 'Beschwerden';

  @override
  String get notificationsFilterReactions => 'Reaktionen';

  @override
  String get notificationsFilterGeneral => 'Allgemein';

  @override
  String get notificationsMarkAllRead => 'Alle als gelesen markieren';

  @override
  String get notificationsEmptyMessage =>
      'Keine neuen Benachrichtigungen, Nachbar';

  @override
  String get profilePersonalInfoMenu => 'Persönliche Daten';

  @override
  String get profileMyComplaintsMenu => 'Meine Beschwerden';

  @override
  String get profileFavoritesMenu => 'Favoriten';

  @override
  String get profileSettingsMenu => 'Einstellungen';

  @override
  String get profileLogoutMenu => 'Abmelden';

  @override
  String get profileStatSubmitted => 'Beschwerde';

  @override
  String get profileStatResolved => 'Geschlossen';

  @override
  String get profileStatPoints => 'Blasen';

  @override
  String get profilePageTitle => 'Profil';

  @override
  String get profileCurrentLevelLabel => 'Aktuelle Stufe';

  @override
  String get profileProgressToNextLabel => 'bis zum nächsten Rang';

  @override
  String profileNextRankCaption(int points, String rank) {
    return 'Sammle noch $points Blasen, um \"$rank\" zu erreichen';
  }

  @override
  String get profileMaxRankCaption =>
      'Du hast den höchsten Rang von Qaa El Hamour erreicht! 🏆';

  @override
  String get profileRankQaaResident => 'Qaa-Bewohner';

  @override
  String get profileRankStreetWatcher => 'Straßenwächter';

  @override
  String get profileRankSeaRescuer => 'Meeresretter';

  @override
  String get profileRankQaaHero => 'Held des Qaa';

  @override
  String get profileRankQaaLegend => 'Legende von Qaa El Hamour';

  @override
  String get myComplaintsTitle => 'Meine Beschwerden';

  @override
  String get logoutConfirmTitle => 'Abmelden';

  @override
  String get logoutConfirmMessage => 'Möchtest du dich wirklich abmelden?';

  @override
  String get logoutConfirmYes => 'Ja, abmelden';

  @override
  String get logoutConfirmCancel => 'Nein, zurück';

  @override
  String get relativeTimeNow => 'Gerade eben';

  @override
  String relativeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Minuten',
      one: 'vor 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String relativeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String relativeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String relativeWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Wochen',
      one: 'vor 1 Woche',
    );
    return '$_temp0';
  }

  @override
  String relativeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Monaten',
      one: 'vor 1 Monat',
    );
    return '$_temp0';
  }

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get languageNameAr => 'العربية';

  @override
  String get languageNameEn => 'English';

  @override
  String get languageNameDe => 'Deutsch';
}
