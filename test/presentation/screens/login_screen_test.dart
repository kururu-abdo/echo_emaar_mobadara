import 'package:echoemaar_commerce/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import your screen and providers...

void main() {
  testWidgets('shows loading indicator when login button is tapped', (WidgetTester tester) async {
    
    // 1. ARRANGE: "Pump" (render) the widget. 
    // Because we use Riverpod, it MUST be wrapped in a ProviderScope.
    await tester.pumpWidget(
      MaterialApp(home: LoginPage()),
      
    );

    // Verify the initial state: Button is there, Spinner is not.
    expect(find.text("Enter the Experience"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // 2. ACT: Enter text and tap the button
    // Find the text fields by their Key or Type
    await tester.enterText(find.byType(TextField).first, 'vip@orisa.com');
    await tester.enterText(find.byType(TextField).last, 'gold123');
    
    await tester.tap(find.byType(ElevatedButton));

    // Pump the frame to trigger the rebuild after the state changes to "Loading"
    await tester.pump(); 

    // 3. ASSERT: The spinner should now be visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}