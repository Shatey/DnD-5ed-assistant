import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/services/initiative_turn_service.dart';

void main() {
  InitiativeItemModel createItem({
    required String name,
    required int initiative,
    bool hasActed = false,
    Map<String, int>? statuses,
  }) {
    return InitiativeItemModel(
      name: name,
      initiative: initiative,
      armorClass: 10,
      maxHp: 10,
      monsterId: -1,
      statuses: statuses ?? {},
      hasActed: hasActed,
      currentHp: 10,
    );
  }

  group('InitiativeTurnService', () {
    test('sortItems prioritizes participants who have not acted', () {
      final items = [
        createItem(name: 'A', initiative: 5, hasActed: true),
        createItem(name: 'B', initiative: 20),
        createItem(name: 'C', initiative: 10),
      ];

      final result = InitiativeTurnService.sortItems(items);

      expect(result.first.name, 'B');
      expect(result[1].name, 'C');
      expect(result.last.name, 'A');
    });

    test('normalizeRound starts next round when everyone acted', () {
      final items = [
        createItem(name: 'A', initiative: 10, hasActed: true),
        createItem(name: 'B', initiative: 5, hasActed: true),
      ];

      final result = InitiativeTurnService.normalizeRound(
        items: items,
        currentRound: 1,
      );

      expect(result.round, 2);
      expect(result.items.every((item) => !item.hasActed), true);
    });

    test('normalizeRound decreases temporary statuses', () {
      final items = [
        createItem(
          name: 'A',
          initiative: 10,
          hasActed: true,
          statuses: {'Poisoned': 2, 'Prone': -1},
        ),
      ];

      final result = InitiativeTurnService.normalizeRound(
        items: items,
        currentRound: 1,
      );

      expect(result.items.first.statuses['Poisoned'], 1);
      expect(result.items.first.statuses['Prone'], -1);
    });

    test('normalizeRound removes expired statuses', () {
      final items = [
        createItem(
          name: 'A',
          initiative: 10,
          hasActed: true,
          statuses: {'Stunned': 1},
        ),
      ];

      final result = InitiativeTurnService.normalizeRound(
        items: items,
        currentRound: 1,
      );

      expect(result.items.first.statuses.containsKey('Stunned'), false);
    });
  });
}
