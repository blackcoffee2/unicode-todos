import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unicode_todo_app/utils/firebase.dart';
import 'package:unicode_todo_app/utils/misc.dart';
import 'package:unicode_todo_app/models/todo.dart';
import 'controllers/todo.dart';
import 'screens/todo.dart';

bool init = false;
bool firebaseInitialized = false;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Perform the background task (sync ToDos with Firebase)
    if (task == 'syncTodos') {
      await Hive.initFlutter();
      Hive.registerAdapter(ToDoModelAdapter());
      await Hive.openBox<ToDoModel>('todos');

      try {
        await Firebase
            .initializeApp(); // Initialize Firebase for background process
        await syncTodosWithFirebase(
            inputData!['uniqueID']); // Sync ToDos in the background
      } catch (e) {
        print("Failed to initialize Firebase in background task: $e");
      }
    }
    return Future.value(true); // Indicate that the task was successful
  });
}

Future<void> main({WidgetTester? tester}) async {
  if (!init) {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(ToDoModelAdapter());
    await Hive.openBox<ToDoModel>('todos');

    init = true;
  }

  final app = EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/languages',
    fallbackLocale: const Locale('en'),
    child: const ToDoApp(),
  );

  if (tester != null) {
    await Hive.box<ToDoModel>('todos').clear();
    await tester.pumpWidget(app);
  } else {
    try {
      await Firebase.initializeApp();
      firebaseInitialized = true; // Firebase initialized successfully
    } catch (e) {
      print(
          "Firebase initialization failed: $e"); // Firebase initialization failed
    }

    if (firebaseInitialized) {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

      Workmanager().registerPeriodicTask(
        "1", // Unique name for this task
        "syncTodos", // Task identifier
        frequency: const Duration(hours: 6), // Set the sync frequency
        inputData: {
          'uniqueID': await getUniqueID()
        }, // Pass the unique ID to the background task
      );
    } else {
      print("Skipping Firebase sync: Firebase is not initialized.");
    }

    runApp(app);
  }
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToDoController()),
      ],
      child: MaterialApp(
        title: 'ToDo App',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ToDoScreen(),
      ),
    );
  }
}
