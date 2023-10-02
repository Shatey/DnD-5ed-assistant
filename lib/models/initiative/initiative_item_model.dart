class InitiativeItemModel {
  InitiativeItemModel(
      {required this.name,
      required this.maxHp,
      required this.initiative,
      required this.kd,
      required this.statuses})
      : currentHp = maxHp;

  String name;
  int kd;
  int maxHp;
  int? currentHp;
  int initiative;
  bool hasActed = false;
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
}
