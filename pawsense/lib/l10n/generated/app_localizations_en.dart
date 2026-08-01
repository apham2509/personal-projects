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
  String voiceTitle(String name) {
    return '$name\'s voice cues';
  }

  @override
  String get voiceIntro =>
      'Record short, calm cues in your own voice. PawSense plays them during Touch Training: the Touch cue before each target, praise after a catch, and All done at the end. Keep each one under a couple of seconds.';

  @override
  String cueCatName(String name) {
    return '$name\'s name';
  }

  @override
  String get cueTouch => 'Touch';

  @override
  String get cueGood => 'Good';

  @override
  String get cueGoodJob => 'Good job';

  @override
  String get cueAllDone => 'All done';

  @override
  String get cueCatNameHint =>
      'A friendly greeting played at the start of training.';

  @override
  String get cueTouchHint => 'The cue that a target is about to appear.';

  @override
  String get cueGoodHint => 'Short praise played after a catch.';

  @override
  String get cueGoodJobHint =>
      'Alternative praise; PawSense varies between the two.';

  @override
  String get cueAllDoneHint => 'The calm sign-off at the end of every session.';

  @override
  String get voiceMicDeniedTitle => 'Microphone access is off';

  @override
  String get voiceMicDeniedBody =>
      'PawSense needs the microphone only while you record a cue, and recordings stay on this device. To allow it, open your device\'s Settings, find PawSense, and enable Microphone.';

  @override
  String get voiceRecord => 'Record';

  @override
  String get voiceReRecord => 'Re-record';

  @override
  String get voiceStop => 'Stop';

  @override
  String get voiceRecordingNow => 'Recording... speak your cue, then stop.';

  @override
  String voiceDuration(String seconds) {
    return '$seconds s recorded';
  }

  @override
  String get voicePreview => 'Play recording';

  @override
  String get voicePrivacyNote =>
      'Recordings are stored only inside PawSense on this device, are never uploaded, and are deleted with the cue or the profile.';

  @override
  String get safetyIntro =>
      'PawSense is built for short, calm, successful play. A few habits keep it that way:';

  @override
  String get safetySupervise =>
      'Stay nearby and watch your cat while it plays.';

  @override
  String get safetyStand =>
      'Use a stable stand or lay the tablet flat so a pounce cannot knock it over.';

  @override
  String get safetyProtector =>
      'Consider a screen protector; claws and screens are an uneasy pair.';

  @override
  String get safetyShort =>
      'Keep sessions short. PawSense caps them at five minutes and ends earlier when interest fades.';

  @override
  String get safetyStop =>
      'Stop if your cat seems uncomfortable, overly wound up, or frustrated.';

  @override
  String get safetyPhysicalToy =>
      'Finish with a physical toy your cat can really catch and hold - it completes the hunt.';

  @override
  String get safetyTreats =>
      'Treat rewards are optional and should fit within your cat\'s normal daily diet.';

  @override
  String get safetyNotVet =>
      'PawSense is enrichment, not veterinary or medical advice. Cats that react aggressively to screens should not play unsupervised.';

  @override
  String get safetyLockTitle => 'Keeping paws inside the app';

  @override
  String get safetyLockIntro =>
      'The play screen already requires a two-corner hold plus an owner check to leave. For full protection, your device can pin PawSense on screen - PawSense itself cannot lock the operating system, but these built-in features can:';

  @override
  String get safetyGuidedAccessTitle => 'iPad and iPhone: Guided Access';

  @override
  String get safetyGuidedAccessBody =>
      'Settings > Accessibility > Guided Access, turn it on and set a passcode. Then open PawSense and triple-click the side or home button to start. Triple-click again and enter your passcode to end.';

  @override
  String get safetyPinningTitle => 'Android: app pinning';

  @override
  String get safetyPinningBody =>
      'Settings > Security > App pinning (wording varies by device), turn it on. Open PawSense, open the recent-apps view, tap the app icon, and choose Pin. Unpinning uses your normal screen lock.';

  @override
  String get safetyDesignNote =>
      'By design PawSense contains no flashing effects, no sudden loud sounds, no endless play loops, and no streaks or guilt mechanics. It optimises for successful, calm, short engagement - never for screen time.';

  @override
  String get privacyHeadline =>
      'Everything PawSense knows lives on this device. No account, no cloud, no advertising, no analytics.';

  @override
  String get privacyStoredTitle => 'What is stored';

  @override
  String get privacyStoredBody =>
      'Cat profiles and questionnaire answers, session and trial history, paw-touch positions (as screen fractions), learned play preferences, optional photos, optional voice-cue recordings, and your settings.';

  @override
  String get privacyWhereTitle => 'Where it is stored';

  @override
  String get privacyWhereBody =>
      'In PawSense\'s private app storage on this device: a local database plus a folder per cat for the photo and voice recordings. Nothing is transmitted anywhere by PawSense. Deleting the app deletes all of it.';

  @override
  String get privacyPermissionsTitle => 'Permissions';

  @override
  String get privacyPermissionsBody =>
      'Microphone: only while you record a voice cue; recordings stay on the device. Photos: chosen through the system photo picker, so PawSense never sees your library - only the picture you select. There are no other permissions, and no network permission is used for app features.';

  @override
  String get privacyControlTitle => 'Your controls';

  @override
  String get privacyControlBody =>
      'Export any cat\'s data (or everything) as JSON or CSV from Settings > Data management. Delete one session, one cat\'s history, a whole profile, or all app data at any time. Deletions are immediate and permanent.';

  @override
  String get privacyFutureTitle => 'If this ever changes';

  @override
  String get privacyFutureBody =>
      'Any future optional cloud feature would be opt-in, off by default, and announced with an updated privacy explanation before it ships. The app currently fails a build check if a networking dependency is added.';

  @override
  String insightsTitle(String name) {
    return '$name\'s insights';
  }

  @override
  String get insightsTitleGeneric => 'Insights';

  @override
  String get insightsEmptyTitle => 'Nothing to show yet';

  @override
  String insightsEmptyBody(String name) {
    return 'Play a session or run calibration with $name and the first observations will appear here.';
  }

  @override
  String get insightsSessions => 'Sessions';

  @override
  String insightsSessionsWeek(int count) {
    return '$count in the last 7 days';
  }

  @override
  String get insightsCatches => 'Catches';

  @override
  String insightsOfTrials(int count) {
    return 'of $count concluded targets';
  }

  @override
  String get insightsComparableOnly => 'concluded targets only';

  @override
  String insightsPlayTime(String minutes) {
    return '$minutes min of play in total';
  }

  @override
  String get insightsFavouritesSection => 'What works for this cat';

  @override
  String get insightsDimensionPrey => 'Prey';

  @override
  String get insightsDimensionMovement => 'Movement';

  @override
  String get insightsDimensionSpeed => 'Speed';

  @override
  String get insightsDimensionSize => 'Size';

  @override
  String insightsNoConclusion(int count) {
    return 'No conclusion yet - only $count comparable targets so far.';
  }

  @override
  String insightsFavouriteEvidence(
    String name,
    String value,
    int successes,
    int total,
  ) {
    return '$name has caught $value targets in $successes of $total recent comparable trials.';
  }

  @override
  String get confidenceEarly => 'Early observation';

  @override
  String get confidenceDeveloping => 'Developing pattern';

  @override
  String get confidenceStrong => 'Strong pattern';

  @override
  String get insightsTrendsSection => 'Trends (recent sessions)';

  @override
  String get insightsCatchRateTrend => 'Catch rate per session';

  @override
  String get insightsReactionTrend => 'Median reaction per session';

  @override
  String get insightsDifficultyTrend => 'Difficulty over recent targets';

  @override
  String get insightsHeatmapSection => 'Where the paws land';

  @override
  String get insightsHeatmapEmpty => 'No touch data yet.';

  @override
  String get insightsHeatmapHits => 'Catches';

  @override
  String get insightsHeatmapOther => 'Misses and edge touches';

  @override
  String insightsHeatmapSample(int count) {
    return 'Based on $count touches.';
  }

  @override
  String get insightsCueSection => 'Cue training';

  @override
  String get insightsCueName => 'Name greeting';

  @override
  String insightsCueStats(int successes, int exposures, String seconds) {
    return '$successes of $exposures cued targets caught, typical reaction $seconds s';
  }

  @override
  String get insightsCueCaveat =>
      'Catch rate in cued trials describes play at home, not proven word understanding.';

  @override
  String insightsDayPartTitle(String part) {
    return 'Best time so far: $part';
  }

  @override
  String insightsDayPartBody(int rate, int count, int total) {
    return '$rate% catch rate across $count of $total sessions. Patterns this early can change.';
  }

  @override
  String get dayPartMorning => 'morning';

  @override
  String get dayPartAfternoon => 'afternoon';

  @override
  String get dayPartEvening => 'evening';

  @override
  String get dayPartNight => 'night';

  @override
  String get insightsCompletionSection => 'How sessions ended';

  @override
  String insightsFrustrationNote(int count) {
    return '$count targets showed unsuccessful-interaction patterns; PawSense eased those sessions.';
  }

  @override
  String get insightsMethodNote =>
      'All insights are computed on this device from observed play only. Sample sizes are shown with every claim; small samples show no conclusion at all.';

  @override
  String get insightsPersonalityCaveat =>
      'A playful nickname from observed play preferences - not a scientific assessment. Long-press any insight for its numbers.';

  @override
  String get personalityMouseSmooth => 'The Calm Ground Hunter';

  @override
  String get personalityMouseStopGo => 'The Patient Ambusher';

  @override
  String get personalityMouseUnpredictable => 'The Scurry Chaser';

  @override
  String get personalityMothSmooth => 'The Gliding Watcher';

  @override
  String get personalityMothStopGo => 'The Flutter Stalker';

  @override
  String get personalityMothUnpredictable => 'The Aerial Acrobat';

  @override
  String get personalityFishSmooth => 'The Stream Gazer';

  @override
  String get personalityFishStopGo => 'The Tidepool Tactician';

  @override
  String get personalityFishUnpredictable => 'The Splash Sprinter';

  @override
  String get personalityFallback => 'The Curious Explorer';

  @override
  String get historyTitle => 'Session history';

  @override
  String get historyEmpty => 'No sessions yet.';

  @override
  String historyStats(int catches, int misses, int timeouts) {
    return '$catches catches, $misses misses, $timeouts timed out';
  }

  @override
  String get historyDeleteTitle => 'Delete this session?';

  @override
  String get historyDeleteBody =>
      'This removes the session and all of its trials and touch data. Learned preferences are a running summary and are not rolled back.';

  @override
  String get dataExportSection => 'Export';

  @override
  String get dataExportBody =>
      'Create a copy of the behavioural data on this device and share it wherever you choose. Nothing is uploaded by PawSense itself.';

  @override
  String get dataExportScope => 'What to export';

  @override
  String get dataExportAll => 'All cats and mixed sessions';

  @override
  String get dataExportJson => 'Export JSON';

  @override
  String get dataExportCsv => 'Export CSV';

  @override
  String get dataExportMediaNote =>
      'Exports include play data, profiles, learned preferences, and voice cue details - never the photo or audio files themselves.';

  @override
  String get dataDeleteSection => 'Delete';

  @override
  String dataDeleteHistoryFor(String name) {
    return 'Delete $name\'s history';
  }

  @override
  String get dataDeleteHistoryBody =>
      'Removes every session, trial, and touch event. The profile and voice recordings stay.';

  @override
  String dataDeleteHistoryConfirm(String name) {
    return 'All of $name\'s sessions, trials, and touch events will be permanently removed. The profile, photo, voice recordings, and learned preference summary stay. This cannot be undone.';
  }

  @override
  String get dataDeleted => 'Deleted.';

  @override
  String get dataDeleteAll => 'Delete all application data';

  @override
  String get dataDeleteAllBody =>
      'Every profile, photo, recording, session, and setting.';

  @override
  String get dataDeleteAllConfirm =>
      'This permanently removes every cat profile, photo, voice recording, play session, learned preference, and setting, and returns PawSense to its first-launch state. This cannot be undone.';

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

  @override
  String get setupSkipCalibration => 'Skip calibration for now';

  @override
  String get setupSkipCalibrationNote =>
      'You can run it any time from the cat\'s home screen. Adaptive play works without it, starting from your questionnaire answers only.';
}
