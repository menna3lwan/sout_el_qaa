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
  String get genericCancel => 'Cancel';

  @override
  String get genericConfirm => 'Confirm';

  @override
  String get genericNext => 'Next';

  @override
  String get genericBack => 'Back';

  @override
  String get genericSave => 'Save';

  @override
  String get genericOptional => 'Optional';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationInvalidEmail => 'That email doesn\'t look right';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordTooWeak =>
      'Password must contain letters and digits';

  @override
  String get validationPasswordMismatch => 'Passwords don\'t match';

  @override
  String get validationTooLong => 'That\'s longer than allowed';

  @override
  String get authLoginTitle => 'Sign In';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authLoginButton => 'Sign In';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account yet?';

  @override
  String get authRegisterLink => 'Register now';

  @override
  String get authRegisterTitle => 'New Account';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authRegisterButton => 'Create Account';

  @override
  String get authHaveAccountPrompt => 'Already have an account?';

  @override
  String get authLoginLink => 'Sign in';

  @override
  String homeGreeting(String name) {
    return 'Good morning, citizen $name!';
  }

  @override
  String get homeCategoriesHeading => 'Complaint Categories';

  @override
  String get homeSubmitComplaintCta => 'Submit New Complaint';

  @override
  String get homeSearchHint => 'Search for a complaint...';

  @override
  String get homeTrendingHeading => 'Most Engaged Complaints';

  @override
  String get homeTrendingSubheading => 'See what\'s on Qaa El Hamour\'s mind';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeSameProblemCta => 'I have the same problem';

  @override
  String homeSameProblemCount(int count) {
    return '+$count';
  }

  @override
  String get homeRecentActivityHeading => 'Complaints That Need Your Voice';

  @override
  String get homeUrgentBadge => 'Urgent';

  @override
  String homeViewsCount(int count) {
    return '$count views';
  }

  @override
  String homeLikesCount(int count) {
    return '$count likes';
  }

  @override
  String get complaintsFilterAll => 'All';

  @override
  String get complaintsFilterMine => 'Mine';

  @override
  String get complaintsFilterResolved => 'Resolved';

  @override
  String get complaintsEmptyMessage => 'No complaints in this section yet';

  @override
  String get detailsTitle => 'Complaint Status';

  @override
  String get detailsSectionHeading => 'Details';

  @override
  String get statusReceivedLabel => 'Received';

  @override
  String get statusInReviewLabel => 'In Review';

  @override
  String get statusResolvedLabel => 'Resolved';

  @override
  String get commentsHeading => 'Comments';

  @override
  String get commentInputHint => 'Write your comment, neighbor...';

  @override
  String get commentSubmit => 'Send';

  @override
  String get commentsEmptyMessage => 'No comments yet — be the first';

  @override
  String get locationLabel => 'Location';

  @override
  String get createComplaintTitle => 'Submit a Complaint';

  @override
  String get createComplaintTitleShort => 'Submit Complaint';

  @override
  String get stepFillTitle => 'Complaint Details';

  @override
  String get fieldTitleLabel => 'Complaint Title';

  @override
  String get fieldTitleHint => 'Write a short title';

  @override
  String get fieldDescriptionLabel => 'Description';

  @override
  String get fieldDescriptionHint => 'Tell us what\'s wrong...';

  @override
  String descriptionCounter(int current, int max) {
    return '$current/$max';
  }

  @override
  String get stepCategoryTitle => 'Category';

  @override
  String get stepLocationTitle => 'Location';

  @override
  String get pickLocationOnMapButton => 'Pick Location on Map';

  @override
  String get locationSelectedLabel => 'Selected location';

  @override
  String get stepSeverityTitle => 'Severity';

  @override
  String get severityHighLabel => 'High';

  @override
  String get severityMediumLabel => 'Medium';

  @override
  String get severityLowLabel => 'Low';

  @override
  String get attachPhotoButton => 'Add Photo';

  @override
  String get removePhotoLabel => 'Remove Photo';

  @override
  String get submitComplaintButton => 'Submit Complaint';

  @override
  String get createComplaintReviewTitle =>
      'Review your complaint before sending';

  @override
  String get createComplaintReviewSubtitle =>
      'Make sure everything\'s right before it reaches the residents';

  @override
  String get createComplaintCancelButton => 'Cancel Complaint';

  @override
  String get createComplaintEditButton => 'Edit Complaint';

  @override
  String get successTitle => 'Your complaint made it to the seafloor! 🎉';

  @override
  String get successMessage =>
      'Sent successfully, and Squidward received it 😂';

  @override
  String get successViewComplaintButton => 'View Complaint';

  @override
  String get successBackToHomeButton => 'Back to Home';

  @override
  String get mapTitle => 'Map';

  @override
  String get mapViewDetailsButton => 'View Details';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsFilterComplaints => 'Complaints';

  @override
  String get notificationsFilterReactions => 'Reactions';

  @override
  String get notificationsFilterGeneral => 'General';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsEmptyMessage => 'No new notifications, neighbor';

  @override
  String get profilePersonalInfoMenu => 'Personal Info';

  @override
  String get profileMyComplaintsMenu => 'My Complaints';

  @override
  String get profileFavoritesMenu => 'Favorites';

  @override
  String get profileSettingsMenu => 'Settings';

  @override
  String get profileLogoutMenu => 'Log Out';

  @override
  String get profileStatSubmitted => 'Submitted';

  @override
  String get profileStatResolved => 'Resolved';

  @override
  String get profileStatPoints => 'Points';

  @override
  String get myComplaintsTitle => 'My Complaints';

  @override
  String get logoutConfirmTitle => 'Log Out';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to log out, citizen?';

  @override
  String get logoutConfirmYes => 'Yes, log me out';

  @override
  String get logoutConfirmCancel => 'No, take me back';
}
