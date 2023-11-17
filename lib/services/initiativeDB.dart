import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class InitiativeDB extends StateNotifier<List<InitiativeItemModel>> {
  InitiativeDB() : super(const []);

  Future<Database> getDB() async {
    final databaseService = DatabaseService.getInstance();
    return await databaseService.openDatabase();
  }

  void addInitiativeItem(InitiativeItemModel initiativeItemModel) async {
    final db = await getDB();
    db.insert(
      'initiative',
      initiativeItemModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  void updateInitiativeItem(InitiativeItemModel initiativeItemModel) async {
    final db = await getDB();
    db.insert(
      'initiative',
      initiativeItemModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void clearInitiative() async {
    final db = await getDB();
    db.delete('initiative');
  }

  Future<void> getInitiativeItems() async {
    final db = await getDB();

    final data = await db.query('initiative');
    final initiativeItems = data.map(
      (row) {
        Map<String, dynamic> statusesJson =
            jsonDecode(row['statuses'] as String);
        Map<String, int> correctStatuses = statusesJson
            .map((key, value) => MapEntry(key, int.parse(value.toString())));
        return InitiativeItemModel(
          id: row['id'] as int,
          name: row['name'] as String,
          maxHp: row['max_hit_points'] as int,
          currentHp: row['current_hit_points'] as int,
          initiative: row['initiative'] as int,
          kd: row['armor_class'] as int,
          monsterId: row['monster_id'] as int,
          statuses: correctStatuses,
          hasActed: row['has_acted'] as int == 1 ? true : false,
        );
      },
    ).toList();
    if (initiativeItems.every((item) => item.hasActed)) {
      for (var item in initiativeItems) {
        item.hasActed = !item.hasActed;
        item.statuses.updateAll(
          (key, value) => value > 0 ? value - 1 : value,
        );
        item.statuses.removeWhere((key, value) => value == 0);
      }
    }
    if (initiativeItems.length > 1) {
      initiativeItems.sort((first, second) {
        if (first.hasActed == second.hasActed) {
          return second.initiative.compareTo(first.initiative);
        } else {
          return first.hasActed ? 1 : -1;
        }
      });
    }
    state = initiativeItems;
  }
}

final initiativeProvider =
    StateNotifierProvider<InitiativeDB, List<InitiativeItemModel>>(
  (ref) => InitiativeDB(),
);
