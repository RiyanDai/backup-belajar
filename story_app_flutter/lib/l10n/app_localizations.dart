import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Story App'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to share your stories with friends'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @registerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get registerPrompt;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerLink;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailEmpty;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start sharing'**
  String get registerSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get nameHint;

  /// No description provided for @nameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameEmpty;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get registerButton;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get loginPrompt;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully. Please login.'**
  String get registerSuccess;

  /// No description provided for @storiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Story App'**
  String get storiesTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @emptyStories.
  ///
  /// In en, this message translates to:
  /// **'No stories available yet. Be the first to share!'**
  String get emptyStories;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// No description provided for @loadingStories.
  ///
  /// In en, this message translates to:
  /// **'Loading stories...'**
  String get loadingStories;

  /// No description provided for @errorLoadingStories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load stories'**
  String get errorLoadingStories;

  /// No description provided for @addNewStory.
  ///
  /// In en, this message translates to:
  /// **'Add New Story'**
  String get addNewStory;

  /// No description provided for @detailStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Detail Story'**
  String get detailStoryTitle;

  /// No description provided for @uploadedOn.
  ///
  /// In en, this message translates to:
  /// **'Uploaded on'**
  String get uploadedOn;

  /// No description provided for @loadingDetail.
  ///
  /// In en, this message translates to:
  /// **'Loading story details...'**
  String get loadingDetail;

  /// No description provided for @errorLoadingDetail.
  ///
  /// In en, this message translates to:
  /// **'Failed to load story details'**
  String get errorLoadingDetail;

  /// No description provided for @newStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Story'**
  String get newStoryTitle;

  /// No description provided for @imageUploadPreview.
  ///
  /// In en, this message translates to:
  /// **'Image Upload Preview'**
  String get imageUploadPreview;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write your story description...'**
  String get descriptionHint;

  /// No description provided for @descriptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Description cannot be empty'**
  String get descriptionEmpty;

  /// No description provided for @uploadStory.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD STORY'**
  String get uploadStory;

  /// No description provided for @uploadingStory.
  ///
  /// In en, this message translates to:
  /// **'Uploading your story...'**
  String get uploadingStory;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Story uploaded successfully!'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload story'**
  String get uploadFailed;

  /// No description provided for @imageNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Please select an image first'**
  String get imageNotSelected;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please check your network and try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server is currently unavailable. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password you entered is incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please use another email or log in.'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @pickLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pickLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @tapMapToPickLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to pick a location'**
  String get tapMapToPickLocation;

  /// No description provided for @locationTagged.
  ///
  /// In en, this message translates to:
  /// **'Location Tagged'**
  String get locationTagged;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location (Optional)'**
  String get addLocation;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location selected'**
  String get locationSelected;

  /// No description provided for @removeLocation.
  ///
  /// In en, this message translates to:
  /// **'Remove Location'**
  String get removeLocation;

  /// No description provided for @mapLocation.
  ///
  /// In en, this message translates to:
  /// **'Map Location'**
  String get mapLocation;

  /// No description provided for @loadMoreStories.
  ///
  /// In en, this message translates to:
  /// **'Load more stories...'**
  String get loadMoreStories;

  /// No description provided for @noMoreStories.
  ///
  /// In en, this message translates to:
  /// **'No more stories to load'**
  String get noMoreStories;

  /// No description provided for @freeTierBanner.
  ///
  /// In en, this message translates to:
  /// **'Free Tier — Upgrade to Pro for unlimited features'**
  String get freeTierBanner;

  /// No description provided for @locationPickerAvailableOnPaid.
  ///
  /// In en, this message translates to:
  /// **'Location picker is available on paid version'**
  String get locationPickerAvailableOnPaid;

  /// No description provided for @mapDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Detail'**
  String get mapDetailTitle;

  /// No description provided for @openFullMap.
  ///
  /// In en, this message translates to:
  /// **'Open Full Map'**
  String get openFullMap;

  /// No description provided for @recenterMap.
  ///
  /// In en, this message translates to:
  /// **'Recenter'**
  String get recenterMap;

  /// No description provided for @mapType.
  ///
  /// In en, this message translates to:
  /// **'Map Type'**
  String get mapType;

  /// No description provided for @whatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening? Start a thread...'**
  String get whatsOnYourMind;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @locationTaggedBadge.
  ///
  /// In en, this message translates to:
  /// **'Location tagged'**
  String get locationTaggedBadge;

  /// No description provided for @startThreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Thread'**
  String get startThreadTitle;

  /// No description provided for @postButton.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postButton;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @publicAudience.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get publicAudience;

  /// No description provided for @threadComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what is happening...'**
  String get threadComposerHint;

  /// No description provided for @attachStoryPhoto.
  ///
  /// In en, this message translates to:
  /// **'Attach Story Photo'**
  String get attachStoryPhoto;

  /// No description provided for @searchingAddress.
  ///
  /// In en, this message translates to:
  /// **'Searching location address...'**
  String get searchingAddress;

  /// No description provided for @locationAttached.
  ///
  /// In en, this message translates to:
  /// **'Location Attached'**
  String get locationAttached;

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get openMap;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get addressNotFound;

  /// No description provided for @proFeature.
  ///
  /// In en, this message translates to:
  /// **'Pro Feature'**
  String get proFeature;

  /// No description provided for @locationOnlyOnProNotice.
  ///
  /// In en, this message translates to:
  /// **'Attaching location is only available in Story App Pro'**
  String get locationOnlyOnProNotice;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'See what\'s happening and share your story with the world.'**
  String get loginTagline;

  /// No description provided for @registerTagline.
  ///
  /// In en, this message translates to:
  /// **'Join today to start sharing exciting stories and threads.'**
  String get registerTagline;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get currentLocation;

  /// No description provided for @gpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location service (GPS) is disabled. Please enable GPS.'**
  String get gpsDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
