import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PawSense'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Play smarter. Learn your cat.'**
  String get appTagline;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get actionArchive;

  /// No description provided for @actionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again. If the problem continues, restart the app.'**
  String get errorGenericBody;

  /// No description provided for @introWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PawSense'**
  String get introWelcomeTitle;

  /// No description provided for @introWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Personalised play for your cat. PawSense learns which prey, movement, and pace your cat enjoys, adapts every session, and helps you pair your own spoken cues with successful play.'**
  String get introWelcomeBody;

  /// No description provided for @introPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get introPrivacyTitle;

  /// No description provided for @introPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this device. No account, no cloud, no advertising, and no analytics. Photos, voice recordings, and play history never leave the app, and you can export or delete them at any time.'**
  String get introPrivacyBody;

  /// No description provided for @introSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm, short, and safe'**
  String get introSafetyTitle;

  /// No description provided for @introSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'Sessions are short with a hard five-minute cap, sounds are soft, and there are no flashing effects. Supervise play, use a stable stand, and finish with a physical toy your cat can really catch. PawSense is enrichment, not veterinary advice.'**
  String get introSafetyBody;

  /// No description provided for @introCreateFirstCat.
  ///
  /// In en, this message translates to:
  /// **'Create your first cat'**
  String get introCreateFirstCat;

  /// No description provided for @pickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s playing?'**
  String get pickerTitle;

  /// No description provided for @pickerAddCat.
  ///
  /// In en, this message translates to:
  /// **'Add cat'**
  String get pickerAddCat;

  /// No description provided for @pickerMixedSession.
  ///
  /// In en, this message translates to:
  /// **'Mixed session'**
  String get pickerMixedSession;

  /// No description provided for @pickerMixedSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For several cats together. Nothing is saved to any individual profile.'**
  String get pickerMixedSessionSubtitle;

  /// No description provided for @pickerManageProfiles.
  ///
  /// In en, this message translates to:
  /// **'Manage profiles'**
  String get pickerManageProfiles;

  /// No description provided for @pickerEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No cats yet'**
  String get pickerEmptyTitle;

  /// No description provided for @pickerEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a profile to start personalised play.'**
  String get pickerEmptyBody;

  /// No description provided for @manageTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage profiles'**
  String get manageTitle;

  /// No description provided for @manageReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to change the order shown on the picker.'**
  String get manageReorderHint;

  /// No description provided for @manageArchivedSection.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get manageArchivedSection;

  /// No description provided for @manageArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive {name}?'**
  String manageArchiveConfirmTitle(String name);

  /// No description provided for @manageArchiveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} disappears from the picker but keeps all history, recordings, and preferences. You can restore the profile at any time.'**
  String manageArchiveConfirmBody(String name);

  /// No description provided for @manageDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete {name}?'**
  String manageDeleteConfirmTitle(String name);

  /// No description provided for @manageDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes {name}\'s profile, photo, voice recordings, every play session, and all learned preferences. This cannot be undone.'**
  String manageDeleteConfirmBody(String name);

  /// No description provided for @manageDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get manageDeleteConfirmAction;

  /// No description provided for @manageEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing to manage yet.'**
  String get manageEmptyBody;

  /// No description provided for @wizardTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New cat'**
  String get wizardTitleNew;

  /// No description provided for @wizardTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get wizardTitleEdit;

  /// No description provided for @wizardStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String wizardStepIndicator(int current, int total);

  /// No description provided for @wizardPriorNote.
  ///
  /// In en, this message translates to:
  /// **'Your answers only set gentle starting points. PawSense trusts what your cat actually does over what anyone expects.'**
  String get wizardPriorNote;

  /// No description provided for @wizardStepNamePhoto.
  ///
  /// In en, this message translates to:
  /// **'Name and photo'**
  String get wizardStepNamePhoto;

  /// No description provided for @wizardStepAbout.
  ///
  /// In en, this message translates to:
  /// **'About your cat'**
  String get wizardStepAbout;

  /// No description provided for @wizardStepExperience.
  ///
  /// In en, this message translates to:
  /// **'Play experience'**
  String get wizardStepExperience;

  /// No description provided for @wizardStepSenses.
  ///
  /// In en, this message translates to:
  /// **'Senses'**
  String get wizardStepSenses;

  /// No description provided for @wizardStepBodyTreats.
  ///
  /// In en, this message translates to:
  /// **'Body and treats'**
  String get wizardStepBodyTreats;

  /// No description provided for @wizardStepGoalNotes.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get wizardStepGoalNotes;

  /// No description provided for @wizardStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get wizardStepReview;

  /// No description provided for @wizardNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get wizardNameLabel;

  /// No description provided for @wizardNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Tiger'**
  String get wizardNameHint;

  /// No description provided for @wizardNameError.
  ///
  /// In en, this message translates to:
  /// **'Please give your cat a name.'**
  String get wizardNameError;

  /// No description provided for @wizardPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get wizardPhotoAdd;

  /// No description provided for @wizardPhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get wizardPhotoChange;

  /// No description provided for @wizardPhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get wizardPhotoRemove;

  /// No description provided for @wizardAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age group'**
  String get wizardAgeLabel;

  /// No description provided for @ageKitten.
  ///
  /// In en, this message translates to:
  /// **'Kitten'**
  String get ageKitten;

  /// No description provided for @ageYoungAdult.
  ///
  /// In en, this message translates to:
  /// **'Young adult'**
  String get ageYoungAdult;

  /// No description provided for @ageAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get ageAdult;

  /// No description provided for @ageSenior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get ageSenior;

  /// No description provided for @ageUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get ageUnknown;

  /// No description provided for @wizardBodySizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Approximate body size'**
  String get wizardBodySizeLabel;

  /// No description provided for @bodySmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get bodySmall;

  /// No description provided for @bodyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get bodyMedium;

  /// No description provided for @bodyLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get bodyLarge;

  /// No description provided for @wizardEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy level'**
  String get wizardEnergyLabel;

  /// No description provided for @energyLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get energyLow;

  /// No description provided for @energyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get energyMedium;

  /// No description provided for @energyHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get energyHigh;

  /// No description provided for @wizardExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Screen-play experience'**
  String get wizardExperienceLabel;

  /// No description provided for @experienceNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get experienceNone;

  /// No description provided for @experienceSome.
  ///
  /// In en, this message translates to:
  /// **'Some'**
  String get experienceSome;

  /// No description provided for @experienceFrequent.
  ///
  /// In en, this message translates to:
  /// **'Frequent'**
  String get experienceFrequent;

  /// No description provided for @wizardFavouritePreyLabel.
  ///
  /// In en, this message translates to:
  /// **'Favourite real-world toy or prey'**
  String get wizardFavouritePreyLabel;

  /// No description provided for @preyMouse.
  ///
  /// In en, this message translates to:
  /// **'Mouse'**
  String get preyMouse;

  /// No description provided for @preyMothBug.
  ///
  /// In en, this message translates to:
  /// **'Moth or bug'**
  String get preyMothBug;

  /// No description provided for @preyFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get preyFish;

  /// No description provided for @preyFeather.
  ///
  /// In en, this message translates to:
  /// **'Feather'**
  String get preyFeather;

  /// No description provided for @preyBall.
  ///
  /// In en, this message translates to:
  /// **'Ball'**
  String get preyBall;

  /// No description provided for @preyOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get preyOther;

  /// No description provided for @preyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get preyUnknown;

  /// No description provided for @wizardSoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Sound sensitivity'**
  String get wizardSoundLabel;

  /// No description provided for @soundEnjoys.
  ///
  /// In en, this message translates to:
  /// **'Enjoys sound'**
  String get soundEnjoys;

  /// No description provided for @soundNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get soundNeutral;

  /// No description provided for @soundStartled.
  ///
  /// In en, this message translates to:
  /// **'Easily startled'**
  String get soundStartled;

  /// No description provided for @soundUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get soundUnknown;

  /// No description provided for @wizardTreatLabel.
  ///
  /// In en, this message translates to:
  /// **'Treat motivation'**
  String get wizardTreatLabel;

  /// No description provided for @treatLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get treatLow;

  /// No description provided for @treatMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get treatMedium;

  /// No description provided for @treatHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get treatHigh;

  /// No description provided for @treatUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get treatUnknown;

  /// No description provided for @wizardMobilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobility considerations'**
  String get wizardMobilityLabel;

  /// No description provided for @mobilityNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get mobilityNone;

  /// No description provided for @mobilityLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited movement'**
  String get mobilityLimited;

  /// No description provided for @mobilitySenior.
  ///
  /// In en, this message translates to:
  /// **'Senior-friendly needed'**
  String get mobilitySenior;

  /// No description provided for @wizardVisionLabel.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get wizardVisionLabel;

  /// No description provided for @visionNone.
  ///
  /// In en, this message translates to:
  /// **'None known'**
  String get visionNone;

  /// No description provided for @visionReduced.
  ///
  /// In en, this message translates to:
  /// **'Reduced vision'**
  String get visionReduced;

  /// No description provided for @visionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get visionUnknown;

  /// No description provided for @wizardHearingLabel.
  ///
  /// In en, this message translates to:
  /// **'Hearing'**
  String get wizardHearingLabel;

  /// No description provided for @hearingNone.
  ///
  /// In en, this message translates to:
  /// **'None known'**
  String get hearingNone;

  /// No description provided for @hearingReduced.
  ///
  /// In en, this message translates to:
  /// **'Reduced hearing'**
  String get hearingReduced;

  /// No description provided for @hearingUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get hearingUnknown;

  /// No description provided for @wizardGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Main goal'**
  String get wizardGoalLabel;

  /// No description provided for @goalPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get goalPlay;

  /// No description provided for @goalEnrichment.
  ///
  /// In en, this message translates to:
  /// **'Mental enrichment'**
  String get goalEnrichment;

  /// No description provided for @goalCueTraining.
  ///
  /// In en, this message translates to:
  /// **'Verbal cue training'**
  String get goalCueTraining;

  /// No description provided for @goalGentleActivity.
  ///
  /// In en, this message translates to:
  /// **'Gentle activity'**
  String get goalGentleActivity;

  /// No description provided for @wizardNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get wizardNotesLabel;

  /// No description provided for @wizardNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything worth remembering about how this cat plays.'**
  String get wizardNotesHint;

  /// No description provided for @wizardReviewIntro.
  ///
  /// In en, this message translates to:
  /// **'Ready to create {name}\'s profile. These answers set gentle starting points and can be changed later.'**
  String wizardReviewIntro(String name);

  /// No description provided for @wizardCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get wizardCreateAction;

  /// No description provided for @wizardSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get wizardSaveAction;

  /// No description provided for @homeCalibrationNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Calibration not started'**
  String get homeCalibrationNotStarted;

  /// No description provided for @homeCalibrationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Calibration in progress'**
  String get homeCalibrationInProgress;

  /// No description provided for @homeCalibrationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Calibrated'**
  String get homeCalibrationCompleted;

  /// No description provided for @homeCalibrationSkipped.
  ///
  /// In en, this message translates to:
  /// **'Calibration skipped'**
  String get homeCalibrationSkipped;

  /// No description provided for @homePlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get homePlay;

  /// No description provided for @homePlaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adaptive free play'**
  String get homePlaySubtitle;

  /// No description provided for @homeTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get homeTrain;

  /// No description provided for @homeTrainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Touch training with your voice'**
  String get homeTrainSubtitle;

  /// No description provided for @homeCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Calibrate'**
  String get homeCalibrate;

  /// No description provided for @homeCalibrateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short, balanced first session'**
  String get homeCalibrateSubtitle;

  /// No description provided for @homeInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get homeInsights;

  /// No description provided for @homeInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What PawSense has learned'**
  String get homeInsightsSubtitle;

  /// No description provided for @homeHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeHistory;

  /// No description provided for @homeHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent sessions'**
  String get homeHistorySubtitle;

  /// No description provided for @homeVoiceCues.
  ///
  /// In en, this message translates to:
  /// **'Voice cues'**
  String get homeVoiceCues;

  /// No description provided for @homeVoiceCuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record Touch, Good, and All done'**
  String get homeVoiceCuesSubtitle;

  /// No description provided for @homeEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeEditProfile;

  /// No description provided for @homeEditProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire and photo'**
  String get homeEditProfileSubtitle;

  /// No description provided for @mixedTitle.
  ///
  /// In en, this message translates to:
  /// **'Mixed session'**
  String get mixedTitle;

  /// No description provided for @mixedInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Mixed sessions are for several cats playing together. PawSense keeps the data separate and never updates any individual cat\'s preferences from a mixed session.'**
  String get mixedInfoBody;

  /// No description provided for @placeholderComingTitle.
  ///
  /// In en, this message translates to:
  /// **'Not built yet'**
  String get placeholderComingTitle;

  /// No description provided for @placeholderComingBody.
  ///
  /// In en, this message translates to:
  /// **'This part of PawSense arrives in a later build phase.'**
  String get placeholderComingBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSessionSection.
  ///
  /// In en, this message translates to:
  /// **'Session defaults'**
  String get settingsSessionSection;

  /// No description provided for @settingsDefaultDuration.
  ///
  /// In en, this message translates to:
  /// **'Default session length'**
  String get settingsDefaultDuration;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute} other{{minutes} minutes}}'**
  String durationMinutes(int minutes);

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Game sounds'**
  String get settingsSound;

  /// No description provided for @settingsSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soft prey and capture sounds during play. Individual cats marked as easily startled always start silent.'**
  String get settingsSoundSubtitle;

  /// No description provided for @settingsRewardSection.
  ///
  /// In en, this message translates to:
  /// **'Real-world treat reminders'**
  String get settingsRewardSection;

  /// No description provided for @settingsRewardDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Treats are optional. Keep the total within your cat\'s normal daily diet. PawSense is enrichment, not veterinary advice.'**
  String get settingsRewardDisclaimer;

  /// No description provided for @rewardNone.
  ///
  /// In en, this message translates to:
  /// **'No treat reminders'**
  String get rewardNone;

  /// No description provided for @rewardManual.
  ///
  /// In en, this message translates to:
  /// **'Manual rewards only'**
  String get rewardManual;

  /// No description provided for @rewardEveryThree.
  ///
  /// In en, this message translates to:
  /// **'Every 3 successful catches'**
  String get rewardEveryThree;

  /// No description provided for @rewardVariable.
  ///
  /// In en, this message translates to:
  /// **'Variable: every 2-5 successful catches'**
  String get rewardVariable;

  /// No description provided for @settingsMaxReminders.
  ///
  /// In en, this message translates to:
  /// **'Maximum reminders per session'**
  String get settingsMaxReminders;

  /// No description provided for @settingsPinSection.
  ///
  /// In en, this message translates to:
  /// **'Owner gate'**
  String get settingsPinSection;

  /// No description provided for @settingsPinSet.
  ///
  /// In en, this message translates to:
  /// **'PIN is set'**
  String get settingsPinSet;

  /// No description provided for @settingsPinNotSet.
  ///
  /// In en, this message translates to:
  /// **'Press-and-hold gate (no PIN)'**
  String get settingsPinNotSet;

  /// No description provided for @settingsSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set a 4-digit PIN'**
  String get settingsSetPin;

  /// No description provided for @settingsChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsChangePin;

  /// No description provided for @settingsRemovePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get settingsRemovePin;

  /// No description provided for @pinDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner PIN'**
  String get pinDialogTitle;

  /// No description provided for @pinDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN for leaving play sessions. The press-and-hold gate is used when no PIN is set.'**
  String get pinDialogBody;

  /// No description provided for @pinDialogError.
  ///
  /// In en, this message translates to:
  /// **'Enter exactly 4 digits.'**
  String get pinDialogError;

  /// No description provided for @settingsAccessibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibilitySection;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReduceMotion;

  /// No description provided for @settingsReduceMotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calms owner-screen animations. Prey movement is controlled per cat, not here.'**
  String get settingsReduceMotionSubtitle;

  /// No description provided for @settingsHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High-contrast play targets'**
  String get settingsHighContrast;

  /// No description provided for @settingsHighContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maximises prey contrast for cats with reduced vision.'**
  String get settingsHighContrastSubtitle;

  /// No description provided for @settingsMoreSection.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get settingsMoreSection;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety guidance'**
  String get settingsSafety;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data management'**
  String get settingsData;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer tools'**
  String get settingsDeveloper;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsLocalFirstNote.
  ///
  /// In en, this message translates to:
  /// **'PawSense is local-first: no account, no cloud, no analytics.'**
  String get settingsLocalFirstNote;

  /// No description provided for @setupTitlePlay.
  ///
  /// In en, this message translates to:
  /// **'Play session'**
  String get setupTitlePlay;

  /// No description provided for @setupTitleTrain.
  ///
  /// In en, this message translates to:
  /// **'Touch training'**
  String get setupTitleTrain;

  /// No description provided for @setupTitleCalibration.
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get setupTitleCalibration;

  /// No description provided for @setupCalibrationInfo.
  ///
  /// In en, this message translates to:
  /// **'A short, balanced session of 12 small trials. PawSense shows a fair mix of prey, movement, speed, and size to learn your cat\'s starting preferences. You can stop at any time and continue later.'**
  String get setupCalibrationInfo;

  /// No description provided for @setupDuration.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get setupDuration;

  /// No description provided for @setupSound.
  ///
  /// In en, this message translates to:
  /// **'Sound for this session'**
  String get setupSound;

  /// No description provided for @setupSoundBody.
  ///
  /// In en, this message translates to:
  /// **'Soft prey and capture sounds.'**
  String get setupSoundBody;

  /// No description provided for @setupSoundLocked.
  ///
  /// In en, this message translates to:
  /// **'Off: this cat is marked as easily startled.'**
  String get setupSoundLocked;

  /// No description provided for @setupManualToggle.
  ///
  /// In en, this message translates to:
  /// **'Choose the target myself'**
  String get setupManualToggle;

  /// No description provided for @setupManualBody.
  ///
  /// In en, this message translates to:
  /// **'Fix the prey, movement, speed, and size instead of letting PawSense adapt.'**
  String get setupManualBody;

  /// No description provided for @setupManualPrey.
  ///
  /// In en, this message translates to:
  /// **'Prey'**
  String get setupManualPrey;

  /// No description provided for @setupManualMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get setupManualMovement;

  /// No description provided for @setupManualSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get setupManualSpeed;

  /// No description provided for @setupManualSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get setupManualSize;

  /// No description provided for @setupSafetyReminder.
  ///
  /// In en, this message translates to:
  /// **'Stay nearby while your cat plays. Use a stable stand, keep sessions short, and finish with a physical toy your cat can really catch.'**
  String get setupSafetyReminder;

  /// No description provided for @setupStart.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get setupStart;

  /// No description provided for @movementSmooth.
  ///
  /// In en, this message translates to:
  /// **'Smooth'**
  String get movementSmooth;

  /// No description provided for @movementStopGo.
  ///
  /// In en, this message translates to:
  /// **'Stop and go'**
  String get movementStopGo;

  /// No description provided for @movementUnpredictable.
  ///
  /// In en, this message translates to:
  /// **'Unpredictable'**
  String get movementUnpredictable;

  /// No description provided for @speedSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get speedSlow;

  /// No description provided for @speedMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get speedMedium;

  /// No description provided for @speedFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get speedFast;

  /// No description provided for @ownerGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner check'**
  String get ownerGateTitle;

  /// No description provided for @ownerGateHoldBody.
  ///
  /// In en, this message translates to:
  /// **'Press and hold the circle to end the session. Tap outside or choose resume to keep playing.'**
  String get ownerGateHoldBody;

  /// No description provided for @ownerGatePinBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit owner PIN to end the session.'**
  String get ownerGatePinBody;

  /// No description provided for @ownerGatePinError.
  ///
  /// In en, this message translates to:
  /// **'That PIN does not match.'**
  String get ownerGatePinError;

  /// No description provided for @ownerGateHoldLabel.
  ///
  /// In en, this message translates to:
  /// **'Hold to end'**
  String get ownerGateHoldLabel;

  /// No description provided for @ownerGateEndSession.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get ownerGateEndSession;

  /// No description provided for @ownerGateResume.
  ///
  /// In en, this message translates to:
  /// **'Resume play'**
  String get ownerGateResume;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session results'**
  String get resultsTitle;

  /// No description provided for @resultsDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes of play'**
  String resultsDuration(String minutes);

  /// No description provided for @resultsCatches.
  ///
  /// In en, this message translates to:
  /// **'Catches'**
  String get resultsCatches;

  /// No description provided for @resultsCatchRate.
  ///
  /// In en, this message translates to:
  /// **'Catch rate'**
  String get resultsCatchRate;

  /// No description provided for @resultsMedianReaction.
  ///
  /// In en, this message translates to:
  /// **'Median reaction'**
  String get resultsMedianReaction;

  /// No description provided for @resultsSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String resultsSeconds(String seconds);

  /// No description provided for @resultsMisses.
  ///
  /// In en, this message translates to:
  /// **'Misses'**
  String get resultsMisses;

  /// No description provided for @resultsTimeouts.
  ///
  /// In en, this message translates to:
  /// **'Timed-out targets'**
  String get resultsTimeouts;

  /// No description provided for @resultsFrustrationNote.
  ///
  /// In en, this message translates to:
  /// **'PawSense noticed some unsuccessful interaction patterns and made the session easier. Consider a slightly shorter or slower session next time.'**
  String get resultsFrustrationNote;

  /// No description provided for @resultsFeedbackPrompt.
  ///
  /// In en, this message translates to:
  /// **'How did it look from where you sat?'**
  String get resultsFeedbackPrompt;

  /// No description provided for @resultsFeedbackBody.
  ///
  /// In en, this message translates to:
  /// **'Optional. Your impression is stored separately from the observed play data and never changes what PawSense learned.'**
  String get resultsFeedbackBody;

  /// No description provided for @feedbackEngaged.
  ///
  /// In en, this message translates to:
  /// **'Engaged'**
  String get feedbackEngaged;

  /// No description provided for @feedbackNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get feedbackNeutral;

  /// No description provided for @feedbackFrustrated.
  ///
  /// In en, this message translates to:
  /// **'Frustrated'**
  String get feedbackFrustrated;

  /// No description provided for @voiceTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s voice cues'**
  String voiceTitle(String name);

  /// No description provided for @voiceIntro.
  ///
  /// In en, this message translates to:
  /// **'Record short, calm cues in your own voice. PawSense plays them during Touch Training: the Touch cue before each target, praise after a catch, and All done at the end. Keep each one under a couple of seconds.'**
  String get voiceIntro;

  /// No description provided for @cueCatName.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s name'**
  String cueCatName(String name);

  /// No description provided for @cueTouch.
  ///
  /// In en, this message translates to:
  /// **'Touch'**
  String get cueTouch;

  /// No description provided for @cueGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get cueGood;

  /// No description provided for @cueGoodJob.
  ///
  /// In en, this message translates to:
  /// **'Good job'**
  String get cueGoodJob;

  /// No description provided for @cueAllDone.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get cueAllDone;

  /// No description provided for @cueCatNameHint.
  ///
  /// In en, this message translates to:
  /// **'A friendly greeting played at the start of training.'**
  String get cueCatNameHint;

  /// No description provided for @cueTouchHint.
  ///
  /// In en, this message translates to:
  /// **'The cue that a target is about to appear.'**
  String get cueTouchHint;

  /// No description provided for @cueGoodHint.
  ///
  /// In en, this message translates to:
  /// **'Short praise played after a catch.'**
  String get cueGoodHint;

  /// No description provided for @cueGoodJobHint.
  ///
  /// In en, this message translates to:
  /// **'Alternative praise; PawSense varies between the two.'**
  String get cueGoodJobHint;

  /// No description provided for @cueAllDoneHint.
  ///
  /// In en, this message translates to:
  /// **'The calm sign-off at the end of every session.'**
  String get cueAllDoneHint;

  /// No description provided for @voiceMicDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is off'**
  String get voiceMicDeniedTitle;

  /// No description provided for @voiceMicDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'PawSense needs the microphone only while you record a cue. Recordings stay on this device. You can allow access in system settings.'**
  String get voiceMicDeniedBody;

  /// No description provided for @voiceOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get voiceOpenSettings;

  /// No description provided for @voiceRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get voiceRecord;

  /// No description provided for @voiceReRecord.
  ///
  /// In en, this message translates to:
  /// **'Re-record'**
  String get voiceReRecord;

  /// No description provided for @voiceStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get voiceStop;

  /// No description provided for @voiceRecordingNow.
  ///
  /// In en, this message translates to:
  /// **'Recording... speak your cue, then stop.'**
  String get voiceRecordingNow;

  /// No description provided for @voiceDuration.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s recorded'**
  String voiceDuration(String seconds);

  /// No description provided for @voicePreview.
  ///
  /// In en, this message translates to:
  /// **'Play recording'**
  String get voicePreview;

  /// No description provided for @voicePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Recordings are stored only inside PawSense on this device, are never uploaded, and are deleted with the cue or the profile.'**
  String get voicePrivacyNote;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s insights'**
  String insightsTitle(String name);

  /// No description provided for @insightsTitleGeneric.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitleGeneric;

  /// No description provided for @insightsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show yet'**
  String get insightsEmptyTitle;

  /// No description provided for @insightsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Play a session or run calibration with {name} and the first observations will appear here.'**
  String insightsEmptyBody(String name);

  /// No description provided for @insightsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get insightsSessions;

  /// No description provided for @insightsSessionsWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} in the last 7 days'**
  String insightsSessionsWeek(int count);

  /// No description provided for @insightsCatches.
  ///
  /// In en, this message translates to:
  /// **'Catches'**
  String get insightsCatches;

  /// No description provided for @insightsOfTrials.
  ///
  /// In en, this message translates to:
  /// **'of {count} concluded targets'**
  String insightsOfTrials(int count);

  /// No description provided for @insightsComparableOnly.
  ///
  /// In en, this message translates to:
  /// **'concluded targets only'**
  String get insightsComparableOnly;

  /// No description provided for @insightsPlayTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min of play in total'**
  String insightsPlayTime(String minutes);

  /// No description provided for @insightsFavouritesSection.
  ///
  /// In en, this message translates to:
  /// **'What works for this cat'**
  String get insightsFavouritesSection;

  /// No description provided for @insightsDimensionPrey.
  ///
  /// In en, this message translates to:
  /// **'Prey'**
  String get insightsDimensionPrey;

  /// No description provided for @insightsDimensionMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get insightsDimensionMovement;

  /// No description provided for @insightsDimensionSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get insightsDimensionSpeed;

  /// No description provided for @insightsDimensionSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get insightsDimensionSize;

  /// No description provided for @insightsNoConclusion.
  ///
  /// In en, this message translates to:
  /// **'No conclusion yet - only {count} comparable targets so far.'**
  String insightsNoConclusion(int count);

  /// No description provided for @insightsFavouriteEvidence.
  ///
  /// In en, this message translates to:
  /// **'{name} has caught {value} targets in {successes} of {total} recent comparable trials.'**
  String insightsFavouriteEvidence(
    String name,
    String value,
    int successes,
    int total,
  );

  /// No description provided for @confidenceEarly.
  ///
  /// In en, this message translates to:
  /// **'Early observation'**
  String get confidenceEarly;

  /// No description provided for @confidenceDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing pattern'**
  String get confidenceDeveloping;

  /// No description provided for @confidenceStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong pattern'**
  String get confidenceStrong;

  /// No description provided for @insightsTrendsSection.
  ///
  /// In en, this message translates to:
  /// **'Trends (recent sessions)'**
  String get insightsTrendsSection;

  /// No description provided for @insightsCatchRateTrend.
  ///
  /// In en, this message translates to:
  /// **'Catch rate per session'**
  String get insightsCatchRateTrend;

  /// No description provided for @insightsReactionTrend.
  ///
  /// In en, this message translates to:
  /// **'Median reaction per session'**
  String get insightsReactionTrend;

  /// No description provided for @insightsDifficultyTrend.
  ///
  /// In en, this message translates to:
  /// **'Difficulty over recent targets'**
  String get insightsDifficultyTrend;

  /// No description provided for @insightsHeatmapSection.
  ///
  /// In en, this message translates to:
  /// **'Where the paws land'**
  String get insightsHeatmapSection;

  /// No description provided for @insightsHeatmapEmpty.
  ///
  /// In en, this message translates to:
  /// **'No touch data yet.'**
  String get insightsHeatmapEmpty;

  /// No description provided for @insightsHeatmapHits.
  ///
  /// In en, this message translates to:
  /// **'Catches'**
  String get insightsHeatmapHits;

  /// No description provided for @insightsHeatmapOther.
  ///
  /// In en, this message translates to:
  /// **'Misses and edge touches'**
  String get insightsHeatmapOther;

  /// No description provided for @insightsHeatmapSample.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} touches.'**
  String insightsHeatmapSample(int count);

  /// No description provided for @insightsCueSection.
  ///
  /// In en, this message translates to:
  /// **'Cue training'**
  String get insightsCueSection;

  /// No description provided for @insightsCueName.
  ///
  /// In en, this message translates to:
  /// **'Name greeting'**
  String get insightsCueName;

  /// No description provided for @insightsCueStats.
  ///
  /// In en, this message translates to:
  /// **'{successes} of {exposures} cued targets caught, typical reaction {seconds} s'**
  String insightsCueStats(int successes, int exposures, String seconds);

  /// No description provided for @insightsCueCaveat.
  ///
  /// In en, this message translates to:
  /// **'Catch rate in cued trials describes play at home, not proven word understanding.'**
  String get insightsCueCaveat;

  /// No description provided for @insightsDayPartTitle.
  ///
  /// In en, this message translates to:
  /// **'Best time so far: {part}'**
  String insightsDayPartTitle(String part);

  /// No description provided for @insightsDayPartBody.
  ///
  /// In en, this message translates to:
  /// **'{rate}% catch rate across {count} of {total} sessions. Patterns this early can change.'**
  String insightsDayPartBody(int rate, int count, int total);

  /// No description provided for @dayPartMorning.
  ///
  /// In en, this message translates to:
  /// **'morning'**
  String get dayPartMorning;

  /// No description provided for @dayPartAfternoon.
  ///
  /// In en, this message translates to:
  /// **'afternoon'**
  String get dayPartAfternoon;

  /// No description provided for @dayPartEvening.
  ///
  /// In en, this message translates to:
  /// **'evening'**
  String get dayPartEvening;

  /// No description provided for @dayPartNight.
  ///
  /// In en, this message translates to:
  /// **'night'**
  String get dayPartNight;

  /// No description provided for @insightsCompletionSection.
  ///
  /// In en, this message translates to:
  /// **'How sessions ended'**
  String get insightsCompletionSection;

  /// No description provided for @insightsFrustrationNote.
  ///
  /// In en, this message translates to:
  /// **'{count} targets showed unsuccessful-interaction patterns; PawSense eased those sessions.'**
  String insightsFrustrationNote(int count);

  /// No description provided for @insightsMethodNote.
  ///
  /// In en, this message translates to:
  /// **'All insights are computed on this device from observed play only. Sample sizes are shown with every claim; small samples show no conclusion at all.'**
  String get insightsMethodNote;

  /// No description provided for @insightsPersonalityCaveat.
  ///
  /// In en, this message translates to:
  /// **'A playful nickname from observed play preferences - not a scientific assessment. Long-press any insight for its numbers.'**
  String get insightsPersonalityCaveat;

  /// No description provided for @personalityMouseSmooth.
  ///
  /// In en, this message translates to:
  /// **'The Calm Ground Hunter'**
  String get personalityMouseSmooth;

  /// No description provided for @personalityMouseStopGo.
  ///
  /// In en, this message translates to:
  /// **'The Patient Ambusher'**
  String get personalityMouseStopGo;

  /// No description provided for @personalityMouseUnpredictable.
  ///
  /// In en, this message translates to:
  /// **'The Scurry Chaser'**
  String get personalityMouseUnpredictable;

  /// No description provided for @personalityMothSmooth.
  ///
  /// In en, this message translates to:
  /// **'The Gliding Watcher'**
  String get personalityMothSmooth;

  /// No description provided for @personalityMothStopGo.
  ///
  /// In en, this message translates to:
  /// **'The Flutter Stalker'**
  String get personalityMothStopGo;

  /// No description provided for @personalityMothUnpredictable.
  ///
  /// In en, this message translates to:
  /// **'The Aerial Acrobat'**
  String get personalityMothUnpredictable;

  /// No description provided for @personalityFishSmooth.
  ///
  /// In en, this message translates to:
  /// **'The Stream Gazer'**
  String get personalityFishSmooth;

  /// No description provided for @personalityFishStopGo.
  ///
  /// In en, this message translates to:
  /// **'The Tidepool Tactician'**
  String get personalityFishStopGo;

  /// No description provided for @personalityFishUnpredictable.
  ///
  /// In en, this message translates to:
  /// **'The Splash Sprinter'**
  String get personalityFishUnpredictable;

  /// No description provided for @personalityFallback.
  ///
  /// In en, this message translates to:
  /// **'The Curious Explorer'**
  String get personalityFallback;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet.'**
  String get historyEmpty;

  /// No description provided for @historyStats.
  ///
  /// In en, this message translates to:
  /// **'{catches} catches, {misses} misses, {timeouts} timed out'**
  String historyStats(int catches, int misses, int timeouts);

  /// No description provided for @historyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the session and all of its trials and touch data. Learned preferences are a running summary and are not rolled back.'**
  String get historyDeleteBody;

  /// No description provided for @dataExportSection.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get dataExportSection;

  /// No description provided for @dataExportBody.
  ///
  /// In en, this message translates to:
  /// **'Create a copy of the behavioural data on this device and share it wherever you choose. Nothing is uploaded by PawSense itself.'**
  String get dataExportBody;

  /// No description provided for @dataExportScope.
  ///
  /// In en, this message translates to:
  /// **'What to export'**
  String get dataExportScope;

  /// No description provided for @dataExportAll.
  ///
  /// In en, this message translates to:
  /// **'All cats and mixed sessions'**
  String get dataExportAll;

  /// No description provided for @dataExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get dataExportJson;

  /// No description provided for @dataExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get dataExportCsv;

  /// No description provided for @dataExportMediaNote.
  ///
  /// In en, this message translates to:
  /// **'Exports include play data, profiles, learned preferences, and voice cue details - never the photo or audio files themselves.'**
  String get dataExportMediaNote;

  /// No description provided for @dataDeleteSection.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dataDeleteSection;

  /// No description provided for @dataDeleteHistoryFor.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}\'s history'**
  String dataDeleteHistoryFor(String name);

  /// No description provided for @dataDeleteHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'Removes every session, trial, and touch event. The profile and voice recordings stay.'**
  String get dataDeleteHistoryBody;

  /// No description provided for @dataDeleteHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'All of {name}\'s sessions, trials, and touch events will be permanently removed. The profile, photo, voice recordings, and learned preference summary stay. This cannot be undone.'**
  String dataDeleteHistoryConfirm(String name);

  /// No description provided for @dataDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted.'**
  String get dataDeleted;

  /// No description provided for @dataDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all application data'**
  String get dataDeleteAll;

  /// No description provided for @dataDeleteAllBody.
  ///
  /// In en, this message translates to:
  /// **'Every profile, photo, recording, session, and setting.'**
  String get dataDeleteAllBody;

  /// No description provided for @dataDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes every cat profile, photo, voice recording, play session, learned preference, and setting, and returns PawSense to its first-launch state. This cannot be undone.'**
  String get dataDeleteAllConfirm;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusOwnerStopped.
  ///
  /// In en, this message translates to:
  /// **'Ended by you'**
  String get statusOwnerStopped;

  /// No description provided for @statusDisengaged.
  ///
  /// In en, this message translates to:
  /// **'Ended early: lost interest'**
  String get statusDisengaged;

  /// No description provided for @statusFrustrated.
  ///
  /// In en, this message translates to:
  /// **'Ended gently: repeated frustration'**
  String get statusFrustrated;

  /// No description provided for @statusBackgrounded.
  ///
  /// In en, this message translates to:
  /// **'Ended: app went to background'**
  String get statusBackgrounded;

  /// No description provided for @statusInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get statusInterrupted;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
