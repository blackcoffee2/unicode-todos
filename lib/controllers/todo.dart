import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:unicode_todo_app/models/todo.dart';

class ToDoController with ChangeNotifier {
  List<ToDoModel> _todos = [];

  List<ToDoModel> get todos => _todos;

  ToDoController() {
    _loadTodos();
  }

  // Load todos
  void _loadTodos() async {
    var box = await Hive.openBox<ToDoModel>('todos');
    _todos = box.values.toList();
    notifyListeners();
  }

  // Add todo
  Future<void> addTodo(ToDoModel todo) async {
    var box = await Hive.openBox<ToDoModel>('todos');
    await box.add(todo);
    _todos.add(todo);
    notifyListeners();
  }

  // Check/uncheck todo
  void toggleCompletion(int index) async {
    var box = await Hive.openBox<ToDoModel>('todos');
    var todo = _todos[index];
    todo.isCompleted = !todo.isCompleted;
    await box.putAt(index, todo);
    notifyListeners();
  }
}
