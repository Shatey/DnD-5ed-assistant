import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/services/databaseService.dart';
import 'package:initiative_support/services/initiative_turn_service.dart';
import 'package:sqflite/sqflite.dart';

/// Riverpod state notifier that stores and loads initiative participants.
///
/// The notifier is responsible for persistence and state updates. Pure turn
/// ordering and round-normalization rules live in [InitiativeTurnService].
class InitiativeDB extends StateNotifier<List<InitiativeItemModel>> {
  /// Creates an empty initiative state.
  InitiativeDB() : super(const []);

  /// Opens the shared SQLite database.
  Future<Database> getDB() async {
    final databaseService = DatabaseService.getInstance();
    return databaseService.openDatabase();
  }

  /// Adds a new participant to local storage and refreshes state.
  Future<void> addInitiativeItem(
    InitiativeItemModel initiativeItemModel,
  ) async {
    final db = await getDB();
    await db.insert(
      'initiative',
      initiativeItemModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await getInitiativeItems();
  }

  /// Updates an existing participant and refreshes state.
  Future<void> updateInitiativeItem(
    InitiativeItemModel initiativeItemModel,
  ) async {
    final db = await getDB();
    await db.insert(
      'initiative',
      initiativeItemModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await getInitiativeItems();
  }

  /// Deletes every participant from the active combat scene.
  Future<void> clearInitiative() async {
    final db = await getDB();
    await db.delete('initiative');
    state = const [];
  }

  /// Loads participants from SQLite and applies initiative ordering.
  Future<void> getInitiativeItems() async {
    final db = await getDB();
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
    StateNotifierProvider<InitiativeDB, List<InitiativeItemModel>>(
  (ref) => InitiativeDB(),
);
