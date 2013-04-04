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
}