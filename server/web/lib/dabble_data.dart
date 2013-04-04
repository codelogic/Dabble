part of dabble.core;

/*
 * Immutable data object representing all the information need render the seperate
 * raw text blobs.
 */
class DabbleData {
  String name;
  String description;
  String dabbleId;

  LanguageData markup;
  LanguageData style;
  LanguageData code;

  DabbleData();

  String serialize() {
    return JSON.stringify(makeSerializer(this).write(this));
  }

  static DabbleData revive(String serialized) {
    return makeSerializer().read(JSON.parse(serialized));
  }

  static Serialization makeSerializer([DabbleData data]) {
    return new Serialization()..addRuleFor((data == null ? new DabbleData() : data));
  }
}