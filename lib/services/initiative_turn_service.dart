import 'package:initiative_support/models/initiative/initiative_item_model.dart';

/// Result of applying initiative ordering and round progression.
class InitiativeTurnResult {
  /// Creates a result with sorted items and the current round number.
  const InitiativeTurnResult({
    required this.items,
    required this.round,
  });

  /// Sorted initiative items.
  final List<InitiativeItemModel> items;

  /// Current combat round.
  final int round;
}

/// Contains pure combat-turn logic used by UI, storage, and tests.
class InitiativeTurnService {
  const InitiativeTurnService._();

  /// Adds a participant and returns the updated initiative order.
  static List<InitiativeItemModel> addParticipant(
    List<InitiativeItemModel> items,
    InitiativeItemModel participant,
  ) {
    return sortItems([...items, participant]);
  }

  /// Applies damage to a participant without allowing HP to go below zero.
  static InitiativeItemModel applyDamage(
    InitiativeItemModel item,
    int damage,
  ) {
    if (damage <= 0) return item;

    item.currentHp = (item.currentHp - damage).clamp(0, item.maxHp);
    return item;
  }

  /// Applies healing to a participant without allowing HP to exceed max HP.
  static InitiativeItemModel applyHealing(
    InitiativeItemModel item,
    int healing,
  ) {
    if (healing <= 0) return item;

    item.currentHp = (item.currentHp + healing).clamp(0, item.maxHp);
    return item;
  }

  /// Sorts items so participants who have not acted go first.
  ///
  /// Participants with the same acted state are ordered by initiative descending.
  static List<InitiativeItemModel> sortItems(List<InitiativeItemModel> items) {
    final sortedItems = [...items];

    sortedItems.sort((first, second) {
      if (first.hasActed == second.hasActed) {
        return second.initiative.compareTo(first.initiative);
      }

      return first.hasActed ? 1 : -1;
    });

    return sortedItems;
  }

  /// Starts a new round when every participant has acted.
  ///
  /// The method resets the `hasActed` flag, decreases positive status durations,
  /// removes expired statuses, and returns items sorted for the next turn.
  static InitiativeTurnResult normalizeRound({
    required List<InitiativeItemModel> items,
    required int currentRound,
  }) {
    final shouldStartNextRound =
        items.isNotEmpty && items.every((item) => item.hasActed);

    if (!shouldStartNextRound) {
      return InitiativeTurnResult(
        items: sortItems(items),
        round: currentRound,
      );
    }

    for (final item in items) {
      item.hasActed = false;
      item.statuses.updateAll((key, value) => value > 0 ? value - 1 : value);
      item.statuses.removeWhere((key, value) => value == 0);
    }

    return InitiativeTurnResult(
      items: sortItems(items),
      round: currentRound + 1,
    );
  }
}
