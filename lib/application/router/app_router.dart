import 'package:go_router/go_router.dart';
import 'package:wikigame/ui/pages/classic_mode_page.dart';
import 'package:wikigame/ui/pages/click_guess_page.dart';
import 'package:wikigame/ui/pages/five_to_jesus_page.dart';
import 'package:wikigame/ui/pages/home_page.dart';
import 'package:wikigame/ui/pages/select_game_mode_page.dart';
import 'package:wikigame/ui/pages/settings_page.dart';
import 'package:wikigame/ui/pages/time_trial_page.dart';

final appRouter = GoRouter(
  routes: [
    _mainRoute,
    _gameRoute,
    _settingsRoute,
  ],
);

final _mainRoute = GoRoute(
  path: '/',
  pageBuilder: (context, state) => const NoTransitionPage(
    child: MenuPage(),
  ),
);

final _gameRoute = GoRoute(
  path: '/game',
  routes: [
    GoRoute(
      path: 'classic',
      pageBuilder: (context, state) => const NoTransitionPage(child: ClassicModePage()),
    ),
    GoRoute(
      path: 'click_guess',
      pageBuilder: (context, state) => const NoTransitionPage(child: ClickGuessPage()),
    ),
    GoRoute(
      path: 'five_to_jesus',
      pageBuilder: (context, state) => const NoTransitionPage(child: FiveToJesusPage()),
    ),
    GoRoute(
      path: 'time_trial',
      pageBuilder: (context, state) => const NoTransitionPage(child: TimeTrialPage()),
    ),
  ],
  pageBuilder: (context, state) => const NoTransitionPage(child: SelectGameModePage()),
);

final _settingsRoute = GoRoute(
  path: '/settings',
  pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
);
