import 'package:flutter/material.dart';

class AddTodoBottomSheet extends StatefulWidget {
  const AddTodoBottomSheet({super.key});

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('新增待办', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '输入待办标题',
                border: OutlineInputBorder(),
              ),
              maxLength: 60,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '内容不能为空';
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('添加'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}