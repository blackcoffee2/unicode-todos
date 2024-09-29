import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:unicode_todo_app/controllers/todo.dart';
import 'package:unicode_todo_app/models/todo.dart';
import 'package:unicode_todo_app/widgets/todo.dart';

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()), // Localized app title
        actions: [
          IconButton(
            key: const Key('language_button'),
            icon: const Icon(Icons.language),
            onPressed: () {
              _changeLanguage(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildTodoList(context)),
          _buildAddTodoSection(context),
        ],
      ),
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Consumer<ToDoController>(
      builder: (context, todoController, child) {
        if (todoController.todos.isEmpty) {
          return Center(
            child: Text('no_todos'.tr()), // Localized message for no tasks
          );
        }

        return ListView.builder(
          itemCount: todoController.todos.length,
          itemBuilder: (context, index) {
            final todo = todoController.todos[index];
            return ToDoItemWidget(
              todo: todo,
              onToggleCompletion: () {
                todoController.toggleCompletion(index);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAddTodoSection(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  key: const Key('add_todo_input'),
                  keyboardType: TextInputType.text,
                  controller: titleController,
                  decoration:
                      InputDecoration(hintText: 'todo'.tr()), // Localized hint
                ),
              ],
            ),
          ),
          IconButton(
            key: const Key('add_todo_button'),
            icon: const Icon(Icons.add),
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await _addNewTodo(
                    context, titleController.text, descriptionController.text);
                titleController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addNewTodo(
      BuildContext context, String title, String description) async {
    final newTodo = ToDoModel(
      id: DateTime.now().toIso8601String(),
      title: title,
    );
    await Provider.of<ToDoController>(context, listen: false).addTodo(newTodo);
  }

  void _changeLanguage(BuildContext context) {
    // Toggle between English and Arabic
    if (context.locale.languageCode == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }
}
