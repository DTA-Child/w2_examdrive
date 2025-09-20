import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/database/database_helper.dart';
import 'data/sample_data/database_seeder.dart';
import 'features/test/providers/test_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize database
  try {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;

    // Seed data if first run
    final seeder = DatabaseSeeder();
    await seeder.seedIfEmpty();
  } catch (e) {
    debugPrint('Database initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TestProvider()),
      ],
      child: const DrivingTestApp(),
    ),
  );
}