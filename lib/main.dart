import 'package:flutter/material.dart';
import 'package:icomply/home_page.dart';
import 'package:icomply/services/sqlite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sqliteService = SQLiteService();
  await sqliteService.initDB(); // Ensure DB initialization is complete.

  runApp(MyApp(sqliteService: sqliteService));
}

class MyApp extends StatelessWidget {
  final SQLiteService sqliteService;

  const MyApp({super.key, required this.sqliteService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: HomePage(sqliteService: sqliteService),
    );
  }
}
