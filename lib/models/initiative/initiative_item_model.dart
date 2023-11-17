import 'dart:convert';

class InitiativeItemModel {
  InitiativeItemModel({
    this.id = -1,
    required this.name,
    this.hasActed = false,
    this.currentHp = -1,
    required this.maxHp,
    required this.initiative,
    required this.kd,
    required this.monsterId,
    required this.statuses,
  });
  int id;
  String name;
  int kd;
  int maxHp;
  int currentHp;
  int initiative;
  bool hasActed;
  int monsterId;
  Map<String, int> statuses;

  void sort(List<InitiativeItemModel> items) {
    if (items.every((item) => item.hasActed)) {
      for (var item in items) {
        item.hasActed = !item.hasActed;
      }
    }
    items.sort((first, second) {
      if (first.hasActed == second.hasActed) {
        return second.initiative.compareTo(first.initiative);
      } else {
        return first.hasActed ? 1 : -1;
      }
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id == -1 ? null : id,
      'name': name,
      'current_hit_points': currentHp,
      'max_hit_points': maxHp,
      'armor_class': kd,
      'initiative': initiative,
      'monster_id': monsterId,
      'has_acted': hasActed ? 1 : 0,
      'statuses': jsonEncode(statuses),
    };
  }
}
