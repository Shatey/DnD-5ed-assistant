class CharacteristicsChecker {
  static int getValidCharacteristicValue(int value) {
    if (value.isNegative) {
      if (value / 999 <= -1) {
        value = -999;
      }
    } else {
      if (value / 999 >= 1) {
        value = 999;
      }
    }
    return value;
  }
}
