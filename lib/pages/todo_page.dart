import 'package:flutter/cupertino.dart';
import '../models/todo.dart';
import '../widgets/empty_view.dart';
import '../widgets/add_todo_bottom_sheet.dart';
import '../widgets/todo_list_item.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> _todos = [
    Todo(id: UniqueKey().toString(), title: '学习 Flutter 热重载'),
    Todo(id: UniqueKey().toString(), title: '把 Counter 改成 ToDo'),
  ];

  Future<void> _addTodo() async {
    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) => const AddTodoBottomSheet(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _todos.insert(0, Todo(id: UniqueKey().toString(), title: result));
      });
    }
  }

  void _toggleTodo(String id, bool value) {
    setState(() {
      final idx = _todos.indexWhere((t) => t.id == id);
      if (idx != -1) _todos[idx].done = value;
    });
  }

  void _removeTodo(String id) {
    setState(() {
      _todos.removeWhere((t) => t.id == id);
    });
  }

  void _editTodo(String id, String newTitle) {
    setState(() {
      final idx = _todos.indexWhere((t) => t.id == id);
      if (idx != -1) _todos[idx].title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _todos.where((t) => t.done).length;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Simple ToDo'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            '$doneCount / ${_todos.length}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: SafeArea(
        child: _todos.isEmpty
            ? const EmptyView()
            : Stack(
                children: [
                  CupertinoScrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return TodoListItem(
                          todo: todo,
                          onToggle: (value) => _toggleTodo(todo.id, value),
                          onRemove: () => _removeTodo(todo.id),
                          onEdit: (newTitle) => _editTodo(todo.id, newTitle),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: CupertinoButton.filled(
                      onPressed: _addTodo,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.add, size: 20),
                          SizedBox(width: 8),
                          Text('新增'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}