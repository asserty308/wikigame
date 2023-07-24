import 'package:go_router/go_router.dart';
import 'package:wikigame/data/models/game_mode.dart';
import 'package:wikigame/ui/pages/game_page.dart';
import 'package:wikigame/ui/pages/home_page.dart';
import 'package:wikigame/ui/pages/select_game_mode_page.dart';
import 'package:wikigame/ui/pages/settings_page.dart';

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
  pageBuilder: (context, state) {
    final params = state.uri.queryParameters;
    final modeValue = params['mode'];

    if (modeValue != null) {
      final mode = modeFromValue(modeValue);

      if (mode != null) {
        return NoTransitionPage(child: GamePage(gameMode: mode,));
      }
    }

    return const NoTransitionPage(child: SelectGameModePage());
  },
);

final _settingsRoute = GoRoute(
  path: '/settings',
  pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
);
