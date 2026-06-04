import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/services/initiative_turn_service.dart';

void main() {
  InitiativeItemModel createParticipant({
    required String name,
    required int initiative,
    int currentHp = 10,
    int maxHp = 10,
    int armorClass = 10,
    bool hasActed = false,
    int monsterId = -1,
    Map<String, int>? statuses,
  }) {
    return InitiativeItemModel(
      name: name,
      initiative: initiative,
      armorClass: armorClass,
      currentHp: currentHp,
      maxHp: maxHp,
      monsterId: monsterId,
      statuses: statuses ?? {},
      hasActed: hasActed,
    );
  }

  group('Initiative combat logic', () {
    test('adds a hero to the initiative list', () {
      final hero = createParticipant(name: 'Hero', initiative: 15);

      final result = InitiativeTurnService.addParticipant([], hero);

      expect(result, hasLength(1));
      expect(result.single.name, 'Hero');
      expect(result.single.monsterId, -1);
    });

    test('adds a monster to the initiative list', () {
      final monster = createParticipant(
        name: 'Goblin',
        initiative: 12,
        monsterId: 42,
      );

      final result = InitiativeTurnService.addParticipant([], monster);

      expect(result, hasLength(1));
      expect(result.single.name, 'Goblin');
      expect(result.single.monsterId, 42);
    });

    test('keeps participants sorted by initiative after adding a new one', () {
      final slowHero = createParticipant(name: 'Slow Hero', initiative: 5);
      final fastMonster = createParticipant(name: 'Fast Monster', initiative: 20);

      final result = InitiativeTurnService.addParticipant([slowHero], fastMonster);

      expect(result.map((item) => item.name), ['Fast Monster', 'Slow Hero']);
    });

    test('applies damage to current HP', () {
      final hero = createParticipant(name: 'Hero', initiative: 10, currentHp: 10);

      final result = InitiativeTurnService.applyDamage(hero, 4);

      expect(result.currentHp, 6);
    });

    test('damage cannot reduce HP below zero', () {
      final hero = createParticipant(name: 'Hero', initiative: 10, currentHp: 3);

      final result = InitiativeTurnService.applyDamage(hero, 10);

      expect(result.currentHp, 0);
    });

    test('ignores zero and negative damage', () {
      final hero = createParticipant(name: 'Hero', initiative: 10, currentHp: 7);

      InitiativeTurnService.applyDamage(hero, 0);
      InitiativeTurnService.applyDamage(hero, -3);

      expect(hero.currentHp, 7);
    });

    test('applies healing to current HP', () {
      final hero = createParticipant(name: 'Hero', initiative: 10, currentHp: 4);

      final result = InitiativeTurnService.applyHealing(hero, 3);

      expect(result.currentHp, 7);
    });

    test('healing cannot increase HP above max HP', () {
      final hero = createParticipant(
        name: 'Hero',
        initiative: 10,
        currentHp: 8,
        maxHp: 10,
      );

      final result = InitiativeTurnService.applyHealing(hero, 10);

      expect(result.currentHp, 10);
    });

    test('ignores zero and negative healing', () {
      final hero = createParticipant(name: 'Hero', initiative: 10, currentHp: 4);

      InitiativeTurnService.applyHealing(hero, 0);
      InitiativeTurnService.applyHealing(hero, -3);

      expect(hero.currentHp, 4);
    });

    test('starts a new round after every participant has acted', () {
      final items = [
        createParticipant(name: 'Hero', initiative: 15, hasActed: true),
        createParticipant(name: 'Goblin', initiative: 10, hasActed: true),
      ];

      final result = InitiativeTurnService.normalizeRound(
        items: items,
        currentRound: 2,
      );

      expect(result.round, 3);
      expect(result.items.every((item) => item.hasActed), false);
    });

    test('decreases temporary statuses at the start of a new round', () {
      final hero = createParticipant(
        name: 'Hero',
        initiative: 10,
        hasActed: true,
        statuses: {'Poisoned': 2},
      );

      final result = InitiativeTurnService.normalizeRound(
        items: [hero],
        currentRound: 1,
      );

      expect(result.items.single.statuses['Poisoned'], 1);
    });

    test('removes expired statuses at the start of a new round', () {
      final hero = createParticipant(
        name: 'Hero',
        initiative: 10,
        hasActed: true,
        statuses: {'Stunned': 1},
      );

      final result = InitiativeTurnService.normalizeRound(
        items: [hero],
        currentRound: 1,
      );

      expect(result.items.single.statuses.containsKey('Stunned'), false);
    });

    test('keeps indefinite statuses unchanged', () {
      final hero = createParticipant(
        name: 'Hero',
        initiative: 10,
        hasActed: true,
        statuses: {'Blessed': -1},
      );

      final result = InitiativeTurnService.normalizeRound(
        items: [hero],
        currentRound: 1,
      );

      expect(result.items.single.statuses['Blessed'], -1);
    });
  });
}
