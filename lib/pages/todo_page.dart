import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/page_widgets/todo/empty_view.dart';
import '../widgets/page_widgets/todo/add_todo_bottom_sheet.dart';
import '../widgets/page_widgets/todo/todo_list_item.dart';

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
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已删除')),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple ToDo'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                '$doneCount / ${_todos.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: _todos.isEmpty
          ? const EmptyView()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _todos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        label: const Text('新增'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}