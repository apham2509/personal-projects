// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PawSense';

  @override
  String get appTagline => 'Play smarter. Learn your cat.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionNext => 'Next';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionArchive => 'Archive';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionDone => 'Done';

  @override
  String get actionClose => 'Close';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionRetry => 'Try again';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericBody =>
      'Please try again. If the problem continues, restart the app.';

  @override
  String get introWelcomeTitle => 'Welcome to PawSense';

  @override
  String get introWelcomeBody =>
      'Personalised play for your cat. PawSense learns which prey, movement, and pace your cat enjoys, adapts every session, and helps you pair your own spoken cues with successful play.';

  @override
  String get introPrivacyTitle => 'Private by design';

  @override
  String get introPrivacyBody =>
      'Everything stays on this device. No account, no cloud, no advertising, and no analytics. Photos, voice recordings, and play history never leave the app, and you can export or delete them at any time.';

  @override
  String get introSafetyTitle => 'Calm, short, and safe';

  @override
  String get introSafetyBody =>
      'Sessions are short with a hard five-minute cap, sounds are soft, and there are no flashing effects. Supervise play, use a stable stand, and finish with a physical toy your cat can really catch. PawSense is enrichment, not veterinary advice.';

  @override
  String get introCreateFirstCat => 'Create your first cat';

  @override
  String get pickerTitle => 'Who\'s playing?';

  @override
  String get pickerAddCat => 'Add cat';

  @override
  String get pickerMixedSession => 'Mixed session';

  @override
  String get pickerMixedSessionSubtitle =>
      'For several cats together. Nothing is saved to any individual profile.';

  @override
  String get pickerManageProfiles => 'Manage profiles';

  @override
  String get pickerEmptyTitle => 'No cats yet';

  @override
  String get pickerEmptyBody => 'Create a profile to start personalised play.';

  @override
  String get manageTitle => 'Manage profiles';

  @override
  String get manageReorderHint =>
      'Drag to change the order shown on the picker.';

  @override
  String get manageArchivedSection => 'Archived';

  @override
  String manageArchiveConfirmTitle(String name) {
    return 'Archive $name?';
  }

  @override
  String manageArchiveConfirmBody(String name) {
    return '$name disappears from the picker but keeps all history, recordings, and preferences. You can restore the profile at any time.';
  }

  @override
  String manageDeleteConfirmTitle(String name) {
    return 'Permanently delete $name?';
  }

  @override
  String manageDeleteConfirmBody(String name) {
    return 'This permanently removes $name\'s profile, photo, voice recordings, every play session, and all learned preferences. This cannot be undone.';
  }

  @override
  String get manageDeleteConfirmAction => 'Delete forever';

  @override
  String get manageEmptyBody => 'Nothing to manage yet.';

  @override
  String get wizardTitleNew => 'New cat';

  @override
  String get wizardTitleEdit => 'Edit profile';

  @override
  String wizardStepIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get wizardPriorNote =>
      'Your answers only set gentle starting points. PawSense trusts what your cat actually does over what anyone expects.';

  @override
  String get wizardStepNamePhoto => 'Name and photo';

  @override
  String get wizardStepAbout => 'About your cat';

  @override
  String get wizardStepExperience => 'Play experience';

  @override
  String get wizardStepSenses => 'Senses';

  @override
  String get wizardStepBodyTreats => 'Body and treats';

  @override
  String get wizardStepGoalNotes => 'Your goal';

  @override
  String get wizardStepReview => 'Review';

  @override
  String get wizardNameLabel => 'Name';

  @override
  String get wizardNameHint => 'For example: Tiger';

  @override
  String get wizardNameError => 'Please give your cat a name.';

  @override
  String get wizardPhotoAdd => 'Add photo';

  @override
  String get wizardPhotoChange => 'Change photo';

  @override
  String get wizardPhotoRemove => 'Remove photo';

  @override
  String get wizardAgeLabel => 'Age group';

  @override
  String get ageKitten => 'Kitten';

  @override
  String get ageYoungAdult => 'Young adult';

  @override
  String get ageAdult => 'Adult';

  @override
  String get ageSenior => 'Senior';

  @override
  String get ageUnknown => 'Not sure';

  @override
  String get wizardBodySizeLabel => 'Approximate body size';

  @override
  String get bodySmall => 'Small';

  @override
  String get bodyMedium => 'Medium';

  @override
  String get bodyLarge => 'Large';

  @override
  String get wizardEnergyLabel => 'Energy level';

  @override
  String get energyLow => 'Low';

  @override
  String get energyMedium => 'Medium';

  @override
  String get energyHigh => 'High';

  @override
  String get wizardExperienceLabel => 'Screen-play experience';

  @override
  String get experienceNone => 'None';

  @override
  String get experienceSome => 'Some';

  @override
  String get experienceFrequent => 'Frequent';

  @override
  String get wizardFavouritePreyLabel => 'Favourite real-world toy or prey';

  @override
  String get preyMouse => 'Mouse';

  @override
  String get preyMothBug => 'Moth or bug';

  @override
  String get preyFish => 'Fish';

  @override
  String get preyFeather => 'Feather';

  @override
  String get preyBall => 'Ball';

  @override
  String get preyOther => 'Other';

  @override
  String get preyUnknown => 'Not sure';

  @override
  String get wizardSoundLabel => 'Sound sensitivity';

  @override
  String get soundEnjoys => 'Enjoys sound';

  @override
  String get soundNeutral => 'Neutral';

  @override
  String get soundStartled => 'Easily startled';

  @override
  String get soundUnknown => 'Not sure';

  @override
  String get wizardTreatLabel => 'Treat motivation';

  @override
  String get treatLow => 'Low';

  @override
  String get treatMedium => 'Medium';

  @override
  String get treatHigh => 'High';

  @override
  String get treatUnknown => 'Not sure';

  @override
  String get wizardMobilityLabel => 'Mobility considerations';

  @override
  String get mobilityNone => 'None';

  @override
  String get mobilityLimited => 'Limited movement';

  @override
  String get mobilitySenior => 'Senior-friendly needed';

  @override
  String get wizardVisionLabel => 'Vision';

  @override
  String get visionNone => 'None known';

  @override
  String get visionReduced => 'Reduced vision';

  @override
  String get visionUnknown => 'Not sure';

  @override
  String get wizardHearingLabel => 'Hearing';

  @override
  String get hearingNone => 'None known';

  @override
  String get hearingReduced => 'Reduced hearing';

  @override
  String get hearingUnknown => 'Not sure';

  @override
  String get wizardGoalLabel => 'Main goal';

  @override
  String get goalPlay => 'Play';

  @override
  String get goalEnrichment => 'Mental enrichment';

  @override
  String get goalCueTraining => 'Verbal cue training';

  @override
  String get goalGentleActivity => 'Gentle activity';

  @override
  String get wizardNotesLabel => 'Notes (optional)';

  @override
  String get wizardNotesHint =>
      'Anything worth remembering about how this cat plays.';

  @override
  String wizardReviewIntro(String name) {
    return 'Ready to create $name\'s profile. These answers set gentle starting points and can be changed later.';
  }

  @override
  String get wizardCreateAction => 'Create profile';

  @override
  String get wizardSaveAction => 'Save changes';

  @override
  String get homeCalibrationNotStarted => 'Calibration not started';

  @override
  String get homeCalibrationInProgress => 'Calibration in progress';

  @override
  String get homeCalibrationCompleted => 'Calibrated';

  @override
  String get homeCalibrationSkipped => 'Calibration skipped';

  @override
  String get homePlay => 'Play';

  @override
  String get homePlaySubtitle => 'Adaptive free play';

  @override
  String get homeTrain => 'Train';

  @override
  String get homeTrainSubtitle => 'Touch training with your voice';

  @override
  String get homeCalibrate => 'Calibrate';

  @override
  String get homeCalibrateSubtitle => 'A short, balanced first session';

  @override
  String get homeInsights => 'Insights';

  @override
  String get homeInsightsSubtitle => 'What PawSense has learned';

  @override
  String get homeHistory => 'History';

  @override
  String get homeHistorySubtitle => 'Recent sessions';

  @override
  String get homeVoiceCues => 'Voice cues';

  @override
  String get homeVoiceCuesSubtitle => 'Record Touch, Good, and All done';

  @override
  String get homeEditProfile => 'Profile';

  @override
  String get homeEditProfileSubtitle => 'Questionnaire and photo';

  @override
  String get mixedTitle => 'Mixed session';

  @override
  String get mixedInfoBody =>
      'Mixed sessions are for several cats playing together. PawSense keeps the data separate and never updates any individual cat\'s preferences from a mixed session.';

  @override
  String get placeholderComingTitle => 'Not built yet';

  @override
  String get placeholderComingBody =>
      'This part of PawSense arrives in a later build phase.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSessionSection => 'Session defaults';

  @override
  String get settingsDefaultDuration => 'Default session length';

  @override
  String durationMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get settingsSound => 'Game sounds';

  @override
  String get settingsSoundSubtitle =>
      'Soft prey and capture sounds during play. Individual cats marked as easily startled always start silent.';

  @override
  String get settingsRewardSection => 'Real-world treat reminders';

  @override
  String get settingsRewardDisclaimer =>
      'Treats are optional. Keep the total within your cat\'s normal daily diet. PawSense is enrichment, not veterinary advice.';

  @override
  String get rewardNone => 'No treat reminders';

  @override
  String get rewardManual => 'Manual rewards only';

  @override
  String get rewardEveryThree => 'Every 3 successful catches';

  @override
  String get rewardVariable => 'Variable: every 2-5 successful catches';

  @override
  String get settingsMaxReminders => 'Maximum reminders per session';

  @override
  String get settingsPinSection => 'Owner gate';

  @override
  String get settingsPinSet => 'PIN is set';

  @override
  String get settingsPinNotSet => 'Press-and-hold gate (no PIN)';

  @override
  String get settingsSetPin => 'Set a 4-digit PIN';

  @override
  String get settingsChangePin => 'Change PIN';

  @override
  String get settingsRemovePin => 'Remove PIN';

  @override
  String get pinDialogTitle => 'Owner PIN';

  @override
  String get pinDialogBody =>
      'Choose a 4-digit PIN for leaving play sessions. The press-and-hold gate is used when no PIN is set.';

  @override
  String get pinDialogError => 'Enter exactly 4 digits.';

  @override
  String get settingsAccessibilitySection => 'Accessibility';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsReduceMotionSubtitle =>
      'Calms owner-screen animations. Prey movement is controlled per cat, not here.';

  @override
  String get settingsHighContrast => 'High-contrast play targets';

  @override
  String get settingsHighContrastSubtitle =>
      'Maximises prey contrast for cats with reduced vision.';

  @override
  String get settingsMoreSection => 'More';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsSafety => 'Safety guidance';

  @override
  String get settingsData => 'Data management';

  @override
  String get settingsDeveloper => 'Developer tools';

  @override
  String get settingsAboutSection => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsLocalFirstNote =>
      'PawSense is local-first: no account, no cloud, no analytics.';

  @override
  String get setupTitlePlay => 'Play session';

  @override
  String get setupTitleTrain => 'Touch training';

  @override
  String get setupTitleCalibration => 'Calibration';

  @override
  String get setupCalibrationInfo =>
      'A short, balanced session of 12 small trials. PawSense shows a fair mix of prey, movement, speed, and size to learn your cat\'s starting preferences. You can stop at any time and continue later.';

  @override
  String get setupDuration => 'Session length';

  @override
  String get setupSound => 'Sound for this session';

  @override
  String get setupSoundBody => 'Soft prey and capture sounds.';

  @override
  String get setupSoundLocked => 'Off: this cat is marked as easily startled.';

  @override
  String get setupManualToggle => 'Choose the target myself';

  @override
  String get setupManualBody =>
      'Fix the prey, movement, speed, and size instead of letting PawSense adapt.';

  @override
  String get setupManualPrey => 'Prey';

  @override
  String get setupManualMovement => 'Movement';

  @override
  String get setupManualSpeed => 'Speed';

  @override
  String get setupManualSize => 'Size';

  @override
  String get setupSafetyReminder =>
      'Stay nearby while your cat plays. Use a stable stand, keep sessions short, and finish with a physical toy your cat can really catch.';

  @override
  String get setupStart => 'Start session';

  @override
  String get movementSmooth => 'Smooth';

  @override
  String get movementStopGo => 'Stop and go';

  @override
  String get movementUnpredictable => 'Unpredictable';

  @override
  String get speedSlow => 'Slow';

  @override
  String get speedMedium => 'Medium';

  @override
  String get speedFast => 'Fast';

  @override
  String get ownerGateTitle => 'Owner check';

  @override
  String get ownerGateHoldBody =>
      'Press and hold the circle to end the session. Tap outside or choose resume to keep playing.';

  @override
  String get ownerGatePinBody =>
      'Enter your 4-digit owner PIN to end the session.';

  @override
  String get ownerGatePinError => 'That PIN does not match.';

  @override
  String get ownerGateHoldLabel => 'Hold to end';

  @override
  String get ownerGateEndSession => 'End session';

  @override
  String get ownerGateResume => 'Resume play';

  @override
  String get resultsTitle => 'Session results';

  @override
  String resultsDuration(String minutes) {
    return '$minutes minutes of play';
  }

  @override
  String get resultsCatches => 'Catches';

  @override
  String get resultsCatchRate => 'Catch rate';

  @override
  String get resultsMedianReaction => 'Median reaction';

  @override
  String resultsSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get resultsMisses => 'Misses';

  @override
  String get resultsTimeouts => 'Timed-out targets';

  @override
  String get resultsFrustrationNote =>
      'PawSense noticed some unsuccessful interaction patterns and made the session easier. Consider a slightly shorter or slower session next time.';

  @override
  String get resultsFeedbackPrompt => 'How did it look from where you sat?';

  @override
  String get resultsFeedbackBody =>
      'Optional. Your impression is stored separately from the observed play data and never changes what PawSense learned.';

  @override
  String get feedbackEngaged => 'Engaged';

  @override
  String get feedbackNeutral => 'Neutral';

  @override
  String get feedbackFrustrated => 'Frustrated';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusOwnerStopped => 'Ended by you';

  @override
  String get statusDisengaged => 'Ended early: lost interest';

  @override
  String get statusFrustrated => 'Ended gently: repeated frustration';

  @override
  String get statusBackgrounded => 'Ended: app went to background';

  @override
  String get statusInterrupted => 'Interrupted';

  @override
  String get statusInProgress => 'In progress';
}
