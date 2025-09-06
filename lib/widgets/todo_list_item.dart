import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'edit_todo_dialog.dart';
import 'delete_confirmation_dialog.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onToggle;
  final VoidCallback onRemove;
  final ValueChanged<String> onEdit;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onRemove,
    required this.onEdit,
  });

  Future<void> _editTodo(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => EditTodoDialog(todo: todo),
    );

    if (result != null) {
      onEdit(result.trim());
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteConfirmationDialog(todo: todo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.withValues(alpha: 0.85),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      confirmDismiss: (_) => _confirmDelete(context),
      child: ListTile(
        leading: Checkbox(
          value: todo.done,
          onChanged: (v) => onToggle(v ?? false),
        ),
        title: Text(
          todo.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: todo.done ? TextDecoration.lineThrough : null,
            color: todo.done ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editTodo(context),
          tooltip: '编辑',
        ),
        onTap: () => onToggle(!todo.done),
      ),
    );
  }
}