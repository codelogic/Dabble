part of dabble.core;

class ADabble {
  String id;
  String owner;

  String urlName;
  DabbleData current;

  ADabble(String this.id, String this.owner);

  ADabble.blank();

  String serialize() {
    return JSON.stringify(this.toJson());
  }

  toJson() {
    Map json = new Map();
    json['id'] = this.id;
    json['owner'] = this.owner;
    json['urlName'] = this.urlName;
    json['current'] = this.current == null ? new Map() : this.current.toJson();
    return json;
  }

  static ADabble revive(String serialized) {
    var json = JSON.parse(serialized);
    ADabble dabble = new ADabble.blank();
    dabble.id = json['id'];
    dabble.owner = json['owner'];
    dabble.urlName = json['urlName'];
    dabble.current = DabbleData.fromJson(json['current']);
    return dabble;
  }
}
