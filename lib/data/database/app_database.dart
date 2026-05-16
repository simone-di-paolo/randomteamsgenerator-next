import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Table to store previously generated team sessions.
class TeamGenerations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get teamsJson => text()(); // Stores the serialized List<Team>
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Main database class using Drift for local persistence.
/// Manages [TeamGenerations] table and handles storage of team history.
@DriftDatabase(tables: [TeamGenerations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Saves a list of teams to the local database.
  Future<int> saveGeneration(String teamsJson) {
    return into(teamGenerations).insert(
      TeamGenerationsCompanion.insert(teamsJson: teamsJson),
    );
  }

  /// Retrieves all saved generations ordered by date.
  Future<List<TeamGeneration>> getAllGenerations() {
    return (select(teamGenerations)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Deletes a specific generation record.
  Future<void> deleteGeneration(int id) {
    return (delete(teamGenerations)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
