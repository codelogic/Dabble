part of dabble.core;

/*
 * Chunk of raw data with associated meta-data such as the specific language
 * and rendering options for this language blob.
 */
class LanguageData {
  String language = "";
  String rawText = "";
  Map<String, Object> options = new Map();

  String serialize() {
    return JSON.stringify(this.toJson());
  }

  toJson() {
    Map json = new Map();
    json['language'] = this.language;
    json['rawText'] = this.rawText;
    json['options'] = this.options;
    return json;
  }

  static LanguageData revive(String serialized) {
    var json = JSON.parse(serialized);
    return fromJson(json);
  }
  
  static LanguageData fromJson(Map json) {
    LanguageData data = new LanguageData();
    if (json == null) {
      return data;
    }
    data.language = json.containsKey('language') ? json['language'] : '';
    data.rawText =  json.containsKey('rawText') ? json['rawText'] : '';
    data.options = json.containsKey('options') ? json['options'] : new Map();
    return data;
  }
}