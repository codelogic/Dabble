part of dabble.core;

/*
 * Chunk of raw data with associated meta-data such as the specific language
 * and rendering options for this language blob.
 */
class LanguageData {
  String language;
  String rawText;
  Map<String, Object> options;
}