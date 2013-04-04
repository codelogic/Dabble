part of dabble.core;

class ADabble {
  final String id;
  final String owner;
  
  String urlName;
  DabbleData current;
  
  ADabble(String this.id, String this.owner);

  ADabble.forSerialization(String this.id, String this.owner);

  String serialize() {
    return JSON.stringify(makeSerializer(this).write(this));
  }

  static ADabble revive(String serialized) {
    return makeSerializer().read(JSON.parse(serialized));
  }

  static Serialization makeSerializer([ADabble dabble]) {
    return new Serialization()
        ..addRuleFor((dabble == null ? new ADabble("", "") : dabble),
            constructor: "forSerialization",
            constructorFields: ["id", "owner"]);
  }
}
