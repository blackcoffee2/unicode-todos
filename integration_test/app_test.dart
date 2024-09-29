import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:unicode_todo_app/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Todo integration tests", () {
    testWidgets('Add a new Todo item and check it',
        (WidgetTester tester) async {
      // Run main in test mode
      await app.main(tester: tester);

      await tester.pumpAndSettle();

      // Add a new Todo
      await tester.enterText(
          find.byKey(const Key("add_todo_input")), 'Buy groceries');
      await tester.tap(find.byKey(const Key("add_todo_button")));
      await tester.pumpAndSettle();

      // Verify the new Todo item has been added to the list
      expect(find.text('Buy groceries'), findsOneWidget);

      // Find and tap the checkbox to complete the task
      await tester.tap(find.byKey(const Key("todo_checkbox")));

      await tester.pumpAndSettle();

      // Verify that the checkbox has been checked
      Checkbox checkbox = tester.widget(find.byKey(const Key("todo_checkbox")));

      expect(checkbox.value, true);
    });

    testWidgets('Check and uncheck Todo, verify opacity change',
        (WidgetTester tester) async {
      // Run main in test mode
      await app.main(tester: tester);

      await tester.pumpAndSettle();

      // Add a new Todo
      await tester.enterText(
          find.byKey(const Key("add_todo_input")), 'Do laundry');
      await tester.tap(find.byKey(const Key("add_todo_button")));
      await tester.pumpAndSettle();

      // Verify the new Todo is added
      expect(find.text('Do laundry'), findsOneWidget);

      // Verify initial opacity (should be 1.0 for incomplete Todo)
      final FadeTransition fadeTransitionBefore =
          tester.widget<FadeTransition>(find.byKey(const Key("Do laundry")));
      expect(fadeTransitionBefore.opacity.value, 1.0);

      // Mark the Todo as completed (check the checkbox)
      await tester.tap(find.byKey(const Key("todo_checkbox")));
      await tester.pumpAndSettle(); // Wait for the UI to update

      // Verify opacity changes to 0.5 for completed Todo
      final FadeTransition fadeTransitionAfter =
          tester.widget<FadeTransition>(find.byKey(const Key("Do laundry")));
      expect(fadeTransitionAfter.opacity.value, 0.5);

      // Unmark the Todo (uncheck the checkbox)
      await tester.tap(find.byKey(const Key("todo_checkbox")));
      await tester.pumpAndSettle(); // Wait for the UI to update

      // Verify opacity returns to 1.0 for incomplete Todo
      final FadeTransition fadeTransitionAfterUncheck =
          tester.widget<FadeTransition>(find.byKey(const Key("Do laundry")));
      expect(fadeTransitionAfterUncheck.opacity.value, 1.0);
    });
  });
}
