import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/bestiary/monster_details.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getBestiaryDB() async {
  final dbPath = await sql.getDatabasesPath();
  final bestiaryDB = await sql.openDatabase(
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
            has_acted BOOLEAN,
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
  return bestiaryDB;
}

class DatabaseService extends StateNotifier<List<MonsterDetails>> {
  

  DatabaseService() : super(const []);

  Future<Database> _getSpellsDB() async {
    final dbPath = await sql.getDatabasesPath();
    final sleppsDB = await sql.openDatabase(
      path.join(dbPath, 'dnd.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE bestiary(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    return sleppsDB;
  }

  Future<Database> _getInitiativeDB() async {
    final dbPath = await sql.getDatabasesPath();
    final initiativeDB = await sql.openDatabase(
      path.join(dbPath, 'dnd.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    return initiativeDB;
  }

  void addBestiary(MonsterDetails monsterDetails) async {
    var map = monsterDetails.toMap();
    final db = await _getBestiaryDB();
    db.insert(
      'bestiary',
      monsterDetails.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  void clearBestiary() async {
    final db = await _getBestiaryDB();
    db.delete('bestiary', where: 'id > -2');
  }

  Future<void> getDB() async {
    final db = await _getBestiaryDB();
    final data = await db.query('bestiary');
    final monsters = data
        .map(
          (row) => MonsterDetails(
            id: row['id'] as int,
            name: row['name'] as String,
            size: row['size'] as String,
            type: row['type'] as String,
            alignment: row['alignment'] as String,
            armorClass: row['armor_class'] as String,
            hitPoints: row['hit_points'] as String,
            speed: row['speed'] as String,
            strength: row['strength'] as String,
            dexterity: row['dexterity'] as String,
            constitution: row['constitution'] as String,
            intelligence: row['intelligence'] as String,
            wisdom: row['wisdom'] as String,
            charisma: row['charisma'] as String,
            damageImmunities: row['damage_immunities'] as String,
            conditionImmunities: row['condition_immunities'] as String,
            savingThrows: row['saving_throws'] as String,
            skills: row['skills'] as String,
            senses: row['senses'] as String,
            languages: row['languages'] as String,
            challengeRange: row['challenge_range'] as String,
            proficiencyBonus: row['proficiency_bonus'] as String,
            source: row['source'] as String,
            specialActions: (row['special_actions'] as String).split('---'),
            actions: (row['actions'] as String).split('---'),
            bonusActions: (row['bonus_actions'] as String).split('---'),
            legendaryActions: (row['legendary_actions'] as String).split('---'),
            mythicActions: (row['mythic_actions'] as String).split('---'),
            description: (row['description'] as String).split('---'),
          ),
        )
        .toList();
    state = monsters;
  }
}

final bestiaryProvider =
    StateNotifierProvider<DatabaseService, List<MonsterDetails>>(
  (ref) => DatabaseService(),
);
