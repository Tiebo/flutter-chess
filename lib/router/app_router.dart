import 'package:go_router/go_router.dart';
import '../pages/main_page.dart';
import '../pages/todo_page.dart';
import '../pages/profile_page.dart';
import '../pages/settings_page.dart';

class AppRouter {
  static const String todo = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final GoRouter _router = GoRouter(
    initialLocation: todo,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainPage(child: child),
        routes: [
          GoRoute(
            path: todo,
            builder: (context, state) => const TodoPage(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );

  static GoRouter get router => _router;
}