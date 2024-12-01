import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<String> getDatabasePath() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'app_database.db');
  return path;
}
