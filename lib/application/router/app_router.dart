import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wikigame/ui/pages/home_page.dart';
import 'package:wikigame/ui/pages/select_game_mode_page.dart';

final appRouter = GoRouter(
  routes: [
    _mainRoute,
    _gameRoute,
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
      pageBuilder: (context, state) => NoTransitionPage(child: Container()),
    ),
  ],
  pageBuilder: (context, state) => const NoTransitionPage(child: SelectGameModePage()),
);
