import 'package:flutter/material.dart';
import '../../../models/todo.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;

  const EditTodoDialog({super.key, required this.todo});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.title);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑待办'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: '待办标题',
            border: OutlineInputBorder(),
          ),
          maxLength: 60,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return '内容不能为空';
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        FilledButton(onPressed: _submit, child: const Text('保存')),
      ],
    );
  }
}