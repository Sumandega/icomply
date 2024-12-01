import 'dart:developer';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class SQLiteService {
  Database? _database;

  /// Get the initialized database
  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  /// Initialize the database
  Future<Database> initDB() async {
    sqfliteFfiInit(); // Initialize FFI for desktop platforms
    databaseFactory = databaseFactoryFfi;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'icomply_db.db');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE cards (
              card_id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT,
              assigned_to TEXT,
              awarding_body TEXT,
              awarding_body_contact TEXT,
              card_status TEXT NOT NULL,
              priority INTEGER DEFAULT 1,
              planned_start_date TEXT,
              planned_end_date TEXT,
              actual_start_date TEXT,
              actual_end_date TEXT,
              parent_card_id INTEGER,
              card_type TEXT NOT NULL,
              FOREIGN KEY(parent_card_id) REFERENCES cards(card_id)
            )
          ''');
        },
        readOnly: false,
      ),
    );
  }

  /// Insert a new card
  Future<int> insertCard(Map<String, dynamic> cardData) async {
    try {
      final db = await getDatabase();
      return await db.insert('cards', cardData);
    } catch (e) {
      log('Error inserting card: $e', error: e);
      throw Exception('Failed to insert card');
    }
  }

  /// Fetch all cards
  Future<List<Map<String, dynamic>>> fetchCards() async {
    try {
      final db = await getDatabase();
      return await db.query('cards');
    } catch (e) {
      log('Error fetching cards: $e', error: e);
      return [];
    }
  }

  /// Fetch cards by status
  Future<List<Map<String, dynamic>>> fetchCardsByStatus(String status) async {
    try {
      final db = await getDatabase();
      return await db.query(
        'cards',
        where: 'card_status = ?',
        whereArgs: [status],
      );
    } catch (e) {
      log('Error fetching cards by status: $e', error: e);
      return [];
    }
  }

  /// Fetch cards by type
  Future<List<Map<String, dynamic>>> fetchCardsByType(String cardType) async {
    try {
      final db = await getDatabase();
      return await db.query(
        'cards',
        where: 'card_type = ?',
        whereArgs: [cardType],
      );
    } catch (e) {
      log('Error fetching cards by type: $e', error: e);
      return [];
    }
  }

  /// Fetch cards assigned to a specific user
  Future<List<Map<String, dynamic>>> fetchCardsByAssignedTo(String assignedTo) async {
    try {
      final db = await getDatabase();
      return await db.query(
        'cards',
        where: 'assigned_to = ?',
        whereArgs: [assignedTo],
      );
    } catch (e) {
      log('Error fetching cards by assigned to: $e', error: e);
      return [];
    }
  }

  /// Fetch child cards of a specific parent
  Future<List<Map<String, dynamic>>> fetchChildCards(int parentCardId) async {
    try {
      final db = await getDatabase();
      return await db.query(
        'cards',
        where: 'parent_card_id = ?',
        whereArgs: [parentCardId],
      );
    } catch (e) {
      log('Error fetching child cards: $e', error: e);
      return [];
    }
  }

  /// Update a card by its ID
  Future<bool> updateCard(int cardId, Map<String, dynamic> cardData) async {
    try {
      final db = await getDatabase();
      final rows = await db.update(
        'cards',
        cardData,
        where: 'card_id = ?',
        whereArgs: [cardId],
      );
      return rows > 0;
    } catch (e) {
      log('Error updating card: $e', error: e);
      return false;
    }
  }

  /// Delete a card by its ID
  Future<bool> deleteCard(int cardId) async {
    try {
      final db = await getDatabase();
      final rows = await db.delete(
        'cards',
        where: 'card_id = ?',
        whereArgs: [cardId],
      );
      return rows > 0;
    } catch (e) {
      log('Error deleting card: $e', error: e);
      return false;
    }
  }

  /// Clear the entire database
  Future<void> clearDatabase() async {
    try {
      final db = await getDatabase();
      await db.delete('cards');
    } catch (e) {
      log('Error clearing database: $e', error: e);
      throw Exception('Failed to clear database');
    }
  }

  /// Update the status of a specific card
  Future<bool> updateCardStatus(int cardId, String newStatus) async {
    if (!['Backlog', 'Planned', 'Doing', 'Done'].contains(newStatus)) {
      throw Exception('Invalid status: $newStatus');
    }
    try {
      final db = await getDatabase();
      final rows = await db.update(
        'cards',
        {'card_status': newStatus},
        where: 'card_id = ?',
        whereArgs: [cardId],
      );
      return rows > 0;
    } catch (e) {
      log('Error updating card status: $e', error: e);
      return false;
    }
  }
}
