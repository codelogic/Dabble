part of dabble.core;

/*
 * Immutable data object representing all the information need render the seperate
 * raw text blobs.
 */
class DabbleData {
  final String name;
  final String description;
  final DabbleData parent;
  
  final LanguageBlob markup;
  final LanguageBlob style;
  final LanguageBlob applicationCode;
  
  DabbleData(String this.name,
      String this.description,
      DabbleData this.parent,
      LanguageBlob this.markup,
      LanguageBlob this.style,
      LanguageBlob this.applicationCode);
}