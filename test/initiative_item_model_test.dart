import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';

void main() {
  group('InitiativeItemModel', () {
    test('uses max HP as current HP by default', () {
      final item = InitiativeItemModel(
        name: 'Hero',
        maxHp: 18,
        initiative: 14,
        armorClass: 16,
        monsterId: -1,
        statuses: {},
      );

      expect(item.currentHp, 18);
    });

    test('serializes to a SQLite-compatible map', () {
      final item = InitiativeItemModel(
        id: 7,
        name: 'Goblin Boss',
        currentHp: 9,
        maxHp: 12,
        initiative: 18,
        armorClass: 15,
        monsterId: 42,
        hasActed: true,
        statuses: {'Poisoned': 2, 'Blessed': -1},
      );

      final map = item.toMap();

      expect(map['id'], 7);
      expect(map['name'], 'Goblin Boss');
      expect(map['current_hit_points'], 9);
      expect(map['max_hit_points'], 12);
      expect(map['armor_class'], 15);
      expect(map['initiative'], 18);
      expect(map['monster_id'], 42);
      expect(map['has_acted'], 1);
      expect(jsonDecode(map['statuses'] as String), {
        'Poisoned': 2,
        'Blessed': -1,
      });
    });

    test('serializes unsaved id as null', () {
      final item = InitiativeItemModel(
        name: 'Unsaved Hero',
        maxHp: 10,
        initiative: 10,
        armorClass: 12,
        monsterId: -1,
        statuses: {},
      );

      expect(item.toMap()['id'], null);
    });

    test('deserializes from a SQLite row', () {
      final item = InitiativeItemModel.fromMap({
        'id': 3,
        'name': 'Skeleton',
        'current_hit_points': 5,
        'max_hit_points': 13,
        'armor_class': 13,
        'initiative': 8,
        'monster_id': 77,
        'has_acted': 1,
        'statuses': jsonEncode({'Frightened': 1, 'Invisible': -1}),
      });

      expect(item.id, 3);
      expect(item.name, 'Skeleton');
      expect(item.currentHp, 5);
      expect(item.maxHp, 13);
      expect(item.armorClass, 13);
      expect(item.initiative, 8);
      expect(item.monsterId, 77);
      expect(item.hasActed, true);
      expect(item.statuses, {'Frightened': 1, 'Invisible': -1});
    });

    test('deserializes missing statuses as an empty map', () {
      final item = InitiativeItemModel.fromMap({
        'id': 4,
        'name': 'Commoner',
        'current_hit_points': 4,
        'max_hit_points': 4,
        'armor_class': 10,
        'initiative': 2,
        'monster_id': -1,
        'has_acted': 0,
      });

      expect(item.statuses, isEmpty);
      expect(item.hasActed, false);
    });

    test('copyWith replaces only selected values', () {
      final item = InitiativeItemModel(
        id: 1,
        name: 'Wizard',
        currentHp: 6,
        maxHp: 10,
        initiative: 12,
        armorClass: 11,
        monsterId: -1,
        statuses: {'Concentrating': -1},
      );

      final copy = item.copyWith(currentHp: 3, armorClass: 14);

      expect(copy.id, 1);
      expect(copy.name, 'Wizard');
      expect(copy.currentHp, 3);
      expect(copy.maxHp, 10);
      expect(copy.initiative, 12);
      expect(copy.armorClass, 14);
      expect(copy.monsterId, -1);
      expect(copy.statuses, {'Concentrating': -1});
    });
  });
}
