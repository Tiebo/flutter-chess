import 'package:flutter/cupertino.dart';
import 'pages/todo_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Simple ToDo',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemPink,
      ),
      home: const TodoPage(),
    );
  }
}