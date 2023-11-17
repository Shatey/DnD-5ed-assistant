class SpellDetails {
  final int id;
  final String name;
  final String level;
  final String school;
  final String castingTime;
  final String rangeArea;
  final String components;
  final String duration;
  final String archetypes;
  final String classes;
  final String source;
  final List<String> description;

  SpellDetails(
      this.id,
      this.name,
      this.level,
      this.school,
      this.castingTime,
      this.rangeArea,
      this.components,
      this.duration,
      this.archetypes,
      this.classes,
      this.source,
      this.description);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'school': school,
      'casting_time': castingTime,
      'range_area': rangeArea,
      'components': components,
      'duration': duration,
      'archetypes': archetypes,
      'classes': classes,
      'source': source,
      'description': description.join('---'),
    };
  }
}
