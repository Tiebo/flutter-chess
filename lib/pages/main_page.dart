import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../router/app_router.dart';
import 'todo_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  final String initialTab;
  const MainPage({super.key, required this.initialTab});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  
  final List<Widget> _pages = [
    const TodoPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab == 'profile' ? 1 : 0;
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() {
        _currentIndex = widget.initialTab == 'profile' ? 1 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          final tab = index == 1 ? 'profile' : 'todo';
          AppRouter.goToTab(context, tab);
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