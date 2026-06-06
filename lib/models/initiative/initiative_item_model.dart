import 'dart:convert';

/// A combat participant shown in the initiative tracker.
///
/// The model is intentionally UI-agnostic. It stores values needed to run a
/// combat round: initiative, hit points, armor class, action state, and active
/// statuses.
class InitiativeItemModel {
  /// Creates an initiative participant.
  InitiativeItemModel({
    this.id = -1,
    required this.name,
    this.hasActed = false,
    int? currentHp,
    required this.maxHp,
    required this.initiative,
    required this.armorClass,
    required this.monsterId,
    required this.statuses,
  }) : currentHp = currentHp ?? maxHp;

  /// SQLite identifier. `-1` means the item has not been persisted yet.
  int id;

  /// Display name of the player character, NPC, or monster.
  String name;

  /// Armor class.
  int armorClass;

  /// Maximum hit points.
  int maxHp;

  /// Current hit points.
  int currentHp;

  /// Rolled initiative value.
  int initiative;

  /// Whether the participant has already acted in the current round.
  bool hasActed;

  /// Linked monster identifier from the bestiary, or `-1` for custom entries.
  int monsterId;

  /// Active statuses mapped to remaining duration.
  ///
  /// Negative values mean "until manually removed".
  Map<String, int> statuses;

  /// Creates a copy with selected fields replaced.
  InitiativeItemModel copyWith({
    int? id,
    String? name,
    int? armorClass,
    int? maxHp,
    int? currentHp,
    int? initiative,
    bool? hasActed,
    int? monsterId,
    Map<String, int>? statuses,
  }) {
    return InitiativeItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      armorClass: armorClass ?? this.armorClass,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      initiative: initiative ?? this.initiative,
      hasActed: hasActed ?? this.hasActed,
      monsterId: monsterId ?? this.monsterId,
      statuses: statuses ?? Map<String, int>.from(this.statuses),
    );
  }

  /// Converts the model to a SQLite row.
  Map<String, dynamic> toMap() {
    return {
      'id': id == -1 ? null : id,
      'name': name,
      'current_hit_points': currentHp,
      'max_hit_points': maxHp,
      'armor_class': armorClass,
      'initiative': initiative,
      'monster_id': monsterId,
      'has_acted': hasActed ? 1 : 0,
      'statuses': jsonEncode(statuses),
    };
  }

  /// Creates a model instance from a SQLite row.
  factory InitiativeItemModel.fromMap(Map<String, Object?> row) {
    final statusesJson = jsonDecode(row['statuses'] as String? ?? '{}')
        as Map<String, dynamic>;

    return InitiativeItemModel(
      id: row['id'] as int,
      name: row['name'] as String,
      maxHp: row['max_hit_points'] as int,
      currentHp: row['current_hit_points'] as int,
      initiative: row['initiative'] as int,
      armorClass: row['armor_class'] as int,
      monsterId: row['monster_id'] as int,
      statuses: statusesJson.map(
        (key, value) => MapEntry(key, int.parse(value.toString())),
      ),
      hasActed: row['has_acted'] as int == 1,
    );
  }
}
