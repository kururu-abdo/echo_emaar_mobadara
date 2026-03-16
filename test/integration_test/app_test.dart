import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../../lib/main.dart' as app;

void main() {
  // This line is required to connect the test to the physical device/emulator
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Full login flow: from launch to dashboard', (WidgetTester tester) async {
      
      // 1. Launch the actual app
      app.main();
      
      // Wait for all animations and initial network calls to finish
      await tester.pumpAndSettle();

      // 2. Verify we are on the Login Screen
      expect(find.text('Enter the Experience'), findsOneWidget);

      // 3. Interact with the app exactly like a human would
      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));
      final loginBtn = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'client@orisa.com');
      await tester.enterText(passwordField, 'securePass!');
      await tester.tap(loginBtn);

      // 4. Wait for the network request and navigation animation to finish
      await tester.pumpAndSettle();

      // 5. Assert we successfully navigated to the Dashboard
      expect(find.text('Welcome to your Dashboard'), findsOneWidget);
      expect(find.text('Enter the Experience'), findsNothing); // Login screen is gone
    });
  });
}