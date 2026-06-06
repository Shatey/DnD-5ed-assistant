import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

/// Provides access to the local SQLite database used by the app.
///
/// The service owns database creation and schema definition. Feature-specific
/// repositories should depend on this service instead of opening their own
/// database connections.
class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  /// Returns the shared database service instance.
  factory DatabaseService.getInstance() => _instance;

  /// Opens the local DnD assistant database.
  Future<Database> openDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(
      path.join(dbPath, 'dnd.db'),
      onCreate: _createSchema,
      version: 1,
    );
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bestiary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name STRING,
        size STRING,
        type STRING,
        alignment STRING,
        armor_class STRING,
        hit_points STRING,
        speed STRING,
        strength STRING,
        dexterity STRING,
        constitution STRING,
        intelligence STRING,
        wisdom STRING,
        charisma STRING,
        damage_immunities STRING,
        condition_immunities STRING,
        saving_throws STRING,
        skills STRING,
        senses STRING,
        languages STRING,
        challenge_rate INTEGER,
        challenge_range STRING,
        proficiency_bonus STRING,
        source STRING,
        special_actions STRING,
        actions STRING,
        bonus_actions STRING,
        legendary_actions STRING,
        mythic_actions STRING,
        description STRING
      )
    ''');

    await db.execute('''
      CREATE TABLE initiative(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name STRING,
        current_hit_points INTEGER,
        max_hit_points INTEGER,
        armor_class INTEGER,
        initiative INTEGER,
        monster_id INTEGER,
        has_acted INTEGER DEFAULT 0,
        statuses STRING
      )
    ''');

    await db.execute('''
      CREATE TABLE spells(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name STRING,
        level STRING,
        school STRING,
        casting_time STRING,
        range_area STRING,
        components STRING,
        duration STRING,
        archetypes STRING,
        classes STRING,
        source STRING,
        description STRING
      )
    ''');
  }
}
