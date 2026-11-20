// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Story App';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Sign in to share your stories with friends';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get registerPrompt => 'Don\'t have an account?';

  @override
  String get registerLink => 'Register';

  @override
  String get emailEmpty => 'Email cannot be empty';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordEmpty => 'Password cannot be empty';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerSubtitle => 'Create your account to start sharing';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Enter your full name';

  @override
  String get nameEmpty => 'Name cannot be empty';

  @override
  String get registerButton => 'REGISTER';

  @override
  String get loginPrompt => 'Already have an account?';

  @override
  String get loginLink => 'Login';

  @override
  String get registerSuccess => 'Account created successfully. Please login.';

  @override
  String get storiesTitle => 'Story App';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get emptyStories => 'No stories available yet. Be the first to share!';

  @override
  String get retry => 'Try Again';

  @override
  String get loadingStories => 'Loading stories...';

  @override
  String get errorLoadingStories => 'Failed to load stories';

  @override
  String get addNewStory => 'Add New Story';

  @override
  String get detailStoryTitle => 'Detail Story';

  @override
  String get uploadedOn => 'Uploaded on';

  @override
  String get loadingDetail => 'Loading story details...';

  @override
  String get errorLoadingDetail => 'Failed to load story details';

  @override
  String get newStoryTitle => 'New Story';

  @override
  String get imageUploadPreview => 'Image Upload Preview';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Write your story description...';

  @override
  String get descriptionEmpty => 'Description cannot be empty';

  @override
  String get uploadStory => 'UPLOAD STORY';

  @override
  String get uploadingStory => 'Uploading your story...';

  @override
  String get uploadSuccess => 'Story uploaded successfully!';

  @override
  String get uploadFailed => 'Failed to upload story';

  @override
  String get imageNotSelected => 'Please select an image first';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get success => 'Success';

  @override
  String get language => 'Language';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get english => 'English';

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorTimeout =>
      'Connection timed out. Please check your network and try again.';

  @override
  String get errorServer =>
      'Server is currently unavailable. Please try again later.';

  @override
  String get errorInvalidCredentials =>
      'The email or password you entered is incorrect.';

  @override
  String get errorEmailAlreadyInUse =>
      'This email is already registered. Please use another email or log in.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get pickLocation => 'Pick Location';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get tapMapToPickLocation => 'Tap on the map to pick a location';

  @override
  String get locationTagged => 'Location Tagged';

  @override
  String get addLocation => 'Add Location (Optional)';

  @override
  String get locationSelected => 'Location selected';

  @override
  String get removeLocation => 'Remove Location';

  @override
  String get mapLocation => 'Map Location';

  @override
  String get loadMoreStories => 'Load more stories...';

  @override
  String get noMoreStories => 'No more stories to load';

  @override
  String get freeTierBanner =>
      'Free Tier — Upgrade to Pro for unlimited features';

  @override
  String get locationPickerAvailableOnPaid =>
      'Location picker is available on paid version';

  @override
  String get mapDetailTitle => 'Location Detail';

  @override
  String get openFullMap => 'Open Full Map';

  @override
  String get recenterMap => 'Recenter';

  @override
  String get mapType => 'Map Type';

  @override
  String get whatsOnYourMind => 'What\'s happening? Start a thread...';

  @override
  String get upload => 'Upload';

  @override
  String get locationTaggedBadge => 'Location tagged';

  @override
  String get startThreadTitle => 'Start Thread';

  @override
  String get postButton => 'Post';

  @override
  String get you => 'You';

  @override
  String get publicAudience => 'Public';

  @override
  String get threadComposerHint => 'Tell us what is happening...';

  @override
  String get attachStoryPhoto => 'Attach Story Photo';

  @override
  String get searchingAddress => 'Searching location address...';

  @override
  String get locationAttached => 'Location Attached';

  @override
  String get openMap => 'Open Map';

  @override
  String get fullAddress => 'Full Address';

  @override
  String get addressNotFound => 'Address not found';

  @override
  String get proFeature => 'Pro Feature';

  @override
  String get locationOnlyOnProNotice =>
      'Attaching location is only available in Story App Pro';

  @override
  String get loginTagline =>
      'See what\'s happening and share your story with the world.';

  @override
  String get registerTagline =>
      'Join today to start sharing exciting stories and threads.';

  @override
  String get back => 'Back';

  @override
  String get currentLocation => 'My Location';

  @override
  String get gpsDisabled =>
      'Location service (GPS) is disabled. Please enable GPS.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';
}
