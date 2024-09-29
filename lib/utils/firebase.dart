import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unicode_todo_app/models/todo.dart';

Future<void> syncTodosWithFirebase(String uniqueID) async {
  final box = await Hive.openBox<ToDoModel>('todos');
  final todos = box.values.toList();

  // Upload todos to Firebase Firestore using the unique ID
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('todos');

  for (var todo in todos) {
    await todosCollection
        .doc(uniqueID) // Use the unique ID as the document ID
        .collection('userTodos')
        .doc(todo.id)
        .set(todo.toJson()); // Convert your ToDo model to JSON and upload
  }
}
