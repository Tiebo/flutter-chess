import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/main_page.dart';
import '../pages/settings_page.dart';

class AppRouter {
  static const String main = '/';
  static const String settings = '/settings';

  static final GoRouter _router = GoRouter(
    initialLocation: main,
    routes: [
      GoRoute(
        path: main,
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'] ?? 'todo';
          return MainPage(initialTab: tab);
        },
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );

  static GoRouter get router => _router;
  
  static void goToTab(BuildContext context, String tab) {
    context.go('/?tab=$tab');
  }
}