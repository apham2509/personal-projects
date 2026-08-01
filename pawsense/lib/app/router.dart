import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cat_profiles/presentation/cat_home_screen.dart';
import '../features/cat_profiles/presentation/manage_profiles_screen.dart';
import '../features/cat_profiles/presentation/profile_wizard_screen.dart';
import '../features/onboarding/presentation/bootstrap_screen.dart';
import '../features/onboarding/presentation/intro_screen.dart';
import '../features/profile_picker/presentation/profile_picker_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
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
          GoRoute(path: 'setup', builder: (_, _) => const PlaceholderScreen()),
          GoRoute(
            path: 'insights',
            builder: (_, _) => const PlaceholderScreen(),
          ),
          GoRoute(
            path: 'history',
            builder: (_, _) => const PlaceholderScreen(),
          ),
          GoRoute(path: 'voice', builder: (_, _) => const PlaceholderScreen()),
        ],
      ),
      GoRoute(path: '/mixed', builder: (_, _) => const PlaceholderScreen()),
      GoRoute(path: '/dev', builder: (_, _) => const PlaceholderScreen()),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'privacy',
            builder: (_, _) => const PlaceholderScreen(),
          ),
          GoRoute(path: 'safety', builder: (_, _) => const PlaceholderScreen()),
          GoRoute(path: 'data', builder: (_, _) => const PlaceholderScreen()),
        ],
      ),
    ],
  );
});
