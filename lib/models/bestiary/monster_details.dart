class MonsterDetails {
  int id;
  String name;
  String size;
  String type;
  String alignment;
  String armorClass;
  String hitPoints;
  String speed;
  String strength;
  String dexterity;
  String constitution;
  String intelligence;
  String wisdom;
  String charisma;
  String damageImmunities;
  String conditionImmunities;
  String savingThrows;
  String skills;
  String senses;
  String languages;
  String challengeRange;
  String proficiencyBonus;
  String source;
  List<String> specialActions;
  List<String> actions;
  List<String> bonusActions;
  List<String> legendaryActions;
  List<String> mythicActions;
  List<String> description;

  MonsterDetails({
    this.id = -1,
    required this.name,
    required this.size,
    required this.type,
    required this.alignment,
    required this.armorClass,
    required this.hitPoints,
    required this.speed,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.damageImmunities,
    required this.conditionImmunities,
    required this.savingThrows,
    required this.skills,
    required this.senses,
    required this.languages,
    required this.challengeRange,
    required this.proficiencyBonus,
    required this.source,
    required this.specialActions,
    required this.actions,
    required this.bonusActions,
    required this.legendaryActions,
    required this.mythicActions,
    required this.description,
  });

  static List<MonsterDetails>? convertData(List<Map<String, Object?>> data) {
    final monsters = data.map((row) => MonsterDetails(
          id: row['id'] as int,
          name: row['name'] as String,
          size: row['size'] as String,
          type: row['type'] as String,
          alignment: row['alignment'] as String,
          armorClass: row['armor_class'] as String,
          hitPoints: row['hit_points'] as String,
          speed: row['speed'] as String,
          strength: row['strength'] as String,
          dexterity: row['dexterity'] as String,
          constitution: row['constitution'] as String,
          intelligence: row['intelligence'] as String,
          wisdom: row['wisdom'] as String,
          charisma: row['charisma'] as String,
          damageImmunities: row['damage_immunities'] as String,
          conditionImmunities: row['condition_immunities'] as String,
          savingThrows: row['saving_throws'] as String,
          skills: row['skills'] as String,
          senses: row['senses'] as String,
          languages: row['languages'] as String,
          challengeRange: row['challenge_range'] as String,
          proficiencyBonus: row['proficiency_bonus'] as String,
          source: row['source'] as String,
          specialActions: (row['special_actions'] as String).split('---'),
          actions: (row['actions'] as String).split('---'),
          bonusActions: (row['bonus_actions'] as String).split('---'),
          legendaryActions: (row['legendary_actions'] as String).split('---'),
          mythicActions: (row['mythic_actions'] as String).split('---'),
          description: (row['description'] as String).split('---'),
        ));
    return monsters.toList();
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'size': size,
      'type': type,
      'alignment': alignment,
      'armor_class': armorClass,
      'hit_points': hitPoints,
      'speed': speed,
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
      'damage_immunities': damageImmunities,
      'condition_immunities': conditionImmunities,
      'saving_throws': savingThrows,
      'skills': skills,
      'senses': senses,
      'languages': languages,
      'challenge_rate': int.parse(challengeRange.split(' ')[0]),
      'challenge_range': challengeRange,
      'proficiency_bonus': proficiencyBonus,
      'source': source,
      'special_actions': specialActions.join('---'),
      'actions': actions.join('---'),
      'bonus_actions': bonusActions.join('---'),
      'legendary_actions': legendaryActions.join('---'),
      'mythic_actions': mythicActions.join('---'),
      'description': description.join('---'),
    };
  }
}
