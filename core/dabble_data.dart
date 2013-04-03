part of dabble.core;

/*
 * Immutable data object representing all the information need render the seperate
 * raw text blobs.
 */
class DabbleData {
  final String name;
  final String description;
  final DabbleData parent;
  
  final LanguageData markup;
  final LanguageData style;
  final LanguageData applicationCode;
  
  DabbleData(String this.name,
      String this.description,
      DabbleData this.parent,
      LanguageData this.markup,
      LanguageData this.style,
      LanguageData this.applicationCode);
}