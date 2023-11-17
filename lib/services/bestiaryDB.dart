import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/bestiary/monster_details.dart';
import 'package:initiative_support/services/databaseService.dart';
import 'package:sqflite/sqlite_api.dart';

class BestiaryDB extends StateNotifier<List<MonsterDetails>> {
  BestiaryDB() : super(const []);

  Future<Database> getDB() async {
    final databaseService = DatabaseService.getInstance();
    return await databaseService.openDatabase();
  }

  void addBestiary(MonsterDetails monsterDetails) async {
    // final databaseService = DatabaseService.getInstance();
    // final db = await databaseService.openDatabase();
    final db = await getDB();
    db.insert(
      'bestiary',
      monsterDetails.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  void clearBestiary() async {
    // final databaseService = DatabaseService.getInstance();
    // final db = await databaseService.openDatabase();
    final db = await getDB();
    db.delete('bestiary', where: 'id > -2');
  }

  Future<void> getBestiary() async {
    // final databaseService = DatabaseService.getInstance();
    // final db = await databaseService.openDatabase();
    final db = await getDB();

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
    StateNotifierProvider<BestiaryDB, List<MonsterDetails>>(
  (ref) => BestiaryDB(),
);
