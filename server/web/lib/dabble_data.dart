part of dabble.core;

/*
 * Immutable data object representing all the information need render the seperate
 * raw text blobs.
 */
class DabbleData {
  String name = "";
  String description = "";
  String dabbleId = "";

  LanguageData markup = new LanguageData();
  LanguageData style = new LanguageData();
  LanguageData code = new LanguageData();

  DabbleData();

  String serialize() {
    return JSON.stringify(this.toJson());
  }

  toJson() {
    Map json = new Map();
    json['name'] = this.name;
    json['description'] = this.description;
    json['dabbleId'] = this.dabbleId;
    json['markup'] = this.markup == null ? new Map() : this.markup.toJson();
    json['style'] = this.style == null ? new Map() : this.style.toJson();
    json['code'] = this.code == null ? new Map() : this.code.toJson();
    return json;
  }

  static DabbleData revive(String serialized) {
    var json = JSON.parse(serialized);
    return fromJson(json);
  }
  
  static DabbleData fromJson(json) {
    DabbleData data = new DabbleData();
    if (json == null) {
      return data;
    }
    data.name = json['name'];
    data.description = json['description'];
    data.dabbleId = json['dabbleId'];
    data.markup = LanguageData.fromJson(json['markup']);
    data.style = LanguageData.fromJson(json['style']);
    data.code = LanguageData.fromJson(json['code']);
    return data;
  }
}