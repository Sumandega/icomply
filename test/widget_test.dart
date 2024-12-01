import 'package:flutter/material.dart'; // For AppBar and widget testing
import 'package:flutter_test/flutter_test.dart';
import 'package:icomply/main.dart';
import 'package:mockito/mockito.dart';
import 'package:icomply/services/sqlite_service.dart';

// Mock SQLiteService with all relevant methods stubbed
class MockSQLiteService extends Mock implements SQLiteService {
  @override
  Future<void> initDB() async {
    // Simulates a successful database initialization
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCards() async {
    // Simulates fetching cards
    return [];
  }
}

void main() {
  testWidgets('MyApp displays the correct AppBar and body text', (WidgetTester tester) async {
    // Mock SQLiteService
    final mockSQLiteService = MockSQLiteService();

    // Stub necessary SQLiteService methods
    when(mockSQLiteService.initDB()).thenAnswer((_) async {});
    when(mockSQLiteService.fetchCards()).thenAnswer((_) async []); // Return empty cards list

    // Build the app
    await tester.pumpWidget(MyApp(
      sqliteService: mockSQLiteService,
    ));

    // Allow animations or async tasks to complete
    await tester.pumpAndSettle();

    // Verify the AppBar title
    expect(find.widgetWithText(AppBar, 'iComply'), findsOneWidget);

    // Verify the body content
    expect(find.text('Welcome to iComply!'), findsWidgets); // Ensure consistent text
  });
}
