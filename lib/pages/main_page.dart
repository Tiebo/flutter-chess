import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../router/app_router.dart';

class MainPage extends StatefulWidget {
  final Widget child;
  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _getCurrentIndex(String location) {
    switch (location) {
      case '/':
        return 0;
      case '/profile':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final location = GoRouterState.of(context).uri.path;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(location),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRouter.todo);
              break;
            case 1:
              context.go(AppRouter.profile);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: l10n.todo,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}