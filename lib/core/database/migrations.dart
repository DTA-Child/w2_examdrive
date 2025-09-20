import 'package:sqflite/sqflite.dart';
import '../constants/database_constants.dart';

class DatabaseMigrations {

  Future<void> createTables(Database db) async {
    // Create topics table
    await db.execute(DatabaseConstants.createTopicsTable);

    // Create questions table
    await db.execute(DatabaseConstants.createQuestionsTable);

    // Create test results table
    await db.execute(DatabaseConstants.createTestResultsTable);

    // Create answer details table
    await db.execute(DatabaseConstants.createAnswerDetailsTable);

    // Create indexes
    for (final index in DatabaseConstants.createIndexes) {
      await db.execute(index);
    }
  }

  Future<void> upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration from version 1 to 2
      await _migrateToV2(db);
    }

    if (oldVersion < 3) {
      // Migration from version 2 to 3
      await _migrateToV3(db);
    }

    // Add more migrations as needed
  }

  Future<void> _migrateToV2(Database db) async {
    // Example migration: Add difficulty column to questions
    await db.execute('''
      ALTER TABLE ${DatabaseConstants.tableQuestions}
      ADD COLUMN difficulty INTEGER DEFAULT 1
    ''');
  }

  Future<void> _migrateToV3(Database db) async {
    // Example migration: Add test_type column to test_results
    await db.execute('''
      ALTER TABLE ${DatabaseConstants.tableTestResults}
      ADD COLUMN test_type TEXT DEFAULT 'practice'
    ''');
  }

  Future<void> dropAllTables(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.tableAnswerDetails}');
    await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.tableTestResults}');
    await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.tableQuestions}');
    await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.tableTopics}');
  }

  Future<void> recreateTables(Database db) async {
    await dropAllTables(db);
    await createTables(db);
  }
}