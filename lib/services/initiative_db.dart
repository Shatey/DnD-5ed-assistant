import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/services/database_service.dart';
import 'package:initiative_support/services/initiative_turn_service.dart';
import 'package:sqflite/sqflite.dart';

/// Riverpod state notifier that stores and loads initiative participants.
///
/// The notifier is responsible for persistence and state updates. Pure turn
/// ordering and round-normalization rules live in [InitiativeTurnService].
class InitiativeNotifier extends StateNotifier<List<InitiativeItemModel>> {
  /// Creates an empty initiative state.
  InitiativeNotifier() : super(const []);

  /// Opens the shared SQLite database.
  Future<Database> getDatabase() async {
    final databaseService = DatabaseService.getInstance();
    return databaseService.openDatabase();
  }

  /// Adds a new participant to local storage and refreshes state.
  Future<void> addInitiativeItem(
    InitiativeItemModel initiativeItemModel,
  ) async {
    final db = await getDatabase();
    await db.insert(
      'initiative',
      initiativeItemModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await loadInitiativeItems();
  }

  /// Updates an existing participant and refreshes state.
  Future<void> updateInitiativeItem(
    InitiativeItemModel initiativeItemModel,
  ) async {
    final db = await getDatabase();
    await db.insert(
      'initiative',
      initiativeItemModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await loadInitiativeItems();
  }

  /// Deletes every participant from the active combat scene.
  Future<void> clearInitiative() async {
    final db = await getDatabase();
    await db.delete('initiative');
    state = const [];
  }

  /// Loads participants from SQLite and applies initiative ordering.
  Future<void> loadInitiativeItems() async {
    final db = await getDatabase();
    final data = await db.query('initiative');

    final initiativeItems = data.map(InitiativeItemModel.fromMap).toList();
    state = InitiativeTurnService.sortItems(initiativeItems);
  }

  /// Applies turn progression rules and returns the resulting round number.
  int normalizeRound(int currentRound) {
    final result = InitiativeTurnService.normalizeRound(
      items: state,
      currentRound: currentRound,
    );
    state = result.items;
    return result.round;
  }
}

/// Provides the current initiative list and persistence operations.
final initiativeProvider =
    StateNotifierProvider<InitiativeNotifier, List<InitiativeItemModel>>(
  (ref) => InitiativeNotifier(),
);
