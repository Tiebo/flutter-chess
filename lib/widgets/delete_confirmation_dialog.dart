import 'package:flutter/cupertino.dart';
import '../models/todo.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Todo todo;

  const DeleteConfirmationDialog({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('确认删除？'),
      content: Text('删除「${todo.title}」后不可恢复。'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, true),
          isDestructiveAction: true,
          child: const Text('删除'),
        ),
      ],
    );
  }
}