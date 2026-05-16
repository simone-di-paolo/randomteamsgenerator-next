import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database/app_database.dart';

part 'database_provider.g.dart';

/// Provider for the single instance of our local database.
@Riverpod(keepAlive: true)
AppDatabase database(DatabaseRef ref) {
  if (kDebugMode) {
    print('DatabaseProvider: Initializing AppDatabase');
  }
  
  final db = AppDatabase();
  ref.onDispose(() {
    if (kDebugMode) {
      print('DatabaseProvider: Closing AppDatabase');
    }
    db.close();
  });
  return db;
}
