part of dabble.core;

/*
 * Chunk of raw data with associated meta-data such as the specific language
 * and rendering options for this language blob.
 */
class LanguageBlob {
  final String language;
  final String rawText;
  final Map<String, Object> options;
  
  LanguageBlob(String this.language,
      String this.rawText,
      Map<String, Object> this.options);
}

