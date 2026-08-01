import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cat_profiles/presentation/cat_home_screen.dart';
import '../features/cat_profiles/presentation/manage_profiles_screen.dart';
import '../features/cat_profiles/presentation/profile_wizard_screen.dart';
import '../features/data_management/presentation/data_management_screen.dart';
import '../features/developer_tools/presentation/developer_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/onboarding/presentation/bootstrap_screen.dart';
import '../features/onboarding/presentation/intro_screen.dart';
import '../features/play/presentation/play_screen.dart';
import '../features/play/presentation/session_launch.dart';
import '../features/play/presentation/session_setup_screen.dart';
import '../features/profile_picker/presentation/profile_picker_screen.dart';
import '../features/session_results/presentation/history_screen.dart';
import '../features/session_results/presentation/session_results_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/voice_cues/presentation/voice_cues_screen.dart';
import '../shared/models/enums.dart';
import '../shared/widgets/placeholder_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const BootstrapScreen()),
      GoRoute(path: '/intro', builder: (_, _) => const IntroScreen()),
      GoRoute(
        path: '/profiles',
        builder: (_, _) => const ProfilePickerScreen(),
        routes: [
          GoRoute(
            path: 'manage',
            builder: (_, _) => const ManageProfilesScreen(),
          ),
          GoRoute(
            path: 'new',
            builder: (_, _) => const ProfileWizardScreen(catId: null),
          ),
        ],
      ),
      GoRoute(
        path: '/cats/:catId',
        builder: (_, state) =>
            CatHomeScreen(catId: state.pathParameters['catId']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, state) =>
                ProfileWizardScreen(catId: state.pathParameters['catId']),
          ),
          GoRoute(
            path: 'setup',
            builder: (_, state) => SessionSetupScreen(
              catId: state.pathParameters['catId']!,
              mode: SessionMode.values.byName(
                state.uri.queryParameters['mode'] ?? 'freePlay',
              ),
            ),
          ),
          GoRoute(
            path: 'insights',
            builder: (_, state) =>
                InsightsScreen(catId: state.pathParameters['catId']!),
          ),
          GoRoute(
            path: 'history',
            builder: (_, state) =>
                HistoryScreen(catId: state.pathParameters['catId']!),
          ),
          GoRoute(
            path: 'voice',
            builder: (_, state) =>
                VoiceCuesScreen(catId: state.pathParameters['catId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/mixed',
        builder: (_, _) =>
            const SessionSetupScreen(catId: null, mode: SessionMode.mixed),
      ),
      GoRoute(
        path: '/play',
        builder: (_, state) =>
            PlayScreen(launch: state.extra! as SessionLaunch),
      ),
      GoRoute(
        path: '/results/:sessionId',
        builder: (_, state) =>
            SessionResultsScreen(sessionId: state.pathParameters['sessionId']!),
      ),
      if (kDebugMode)
        GoRoute(path: '/dev', builder: (_, _) => const DeveloperScreen()),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'privacy',
            builder: (_, _) => const PlaceholderScreen(),
          ),
          GoRoute(path: 'safety', builder: (_, _) => const PlaceholderScreen()),
          GoRoute(
            path: 'data',
            builder: (_, _) => const DataManagementScreen(),
          ),
        ],
      ),
    ],
  );
});
