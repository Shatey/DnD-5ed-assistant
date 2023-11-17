import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService.getInstance() => _instance;

  Future<Database> openDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final database = await sql.openDatabase(
      path.join(dbPath, 'dnd.db'),
      onCreate: (db, version) {
        db.execute('''CREATE TABLE bestiary(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name STRING, size STRING,
            type STRING, alignment STRING,
            armor_class STRING,
            hit_points STRING,
            speed STRING,
            strength String,
            dexterity String,
            constitution String,
            intelligence String,
            wisdom String,
            charisma String,
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
            )''');
        db.execute('''CREATE TABLE initiative(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name STRING,
            current_hit_points INTEGER,
            max_hit_points INTEGER,
            armor_class INTEGER,
            initiative INTEGER,
            monster_id INTEGER,
            has_acted INTEGER DEFAULT 0,
            statuses STRING
          )''');
        db.execute('''CREATE TABLE spells(
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
        )''');
      },
      version: 1,
    );
    return database;
  }

  // Future<Database> _getSpellsDB() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   final sleppsDB = await sql.openDatabase(
  //     path.join(dbPath, 'dnd.db'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //           'CREATE TABLE bestiary(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  //     },
  //     version: 1,
  //   );
  //   return sleppsDB;
  // }

  // Future<Database> _getInitiativeDB() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   final initiativeDB = await sql.openDatabase(
  //     path.join(dbPath, 'dnd.db'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //           'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  //     },
  //     version: 1,
  //   );
  //   return initiativeDB;
  // }
}
