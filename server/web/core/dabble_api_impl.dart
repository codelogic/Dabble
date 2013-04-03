part of dabble.client;

class DabbleApiImpl extends DabbleApi {
  Store store;
  DabbleApiImpl() {
    if (IdbFactory.supported) {
      this.store = new IndexedDbStore('dabble', 'dabble');
    } else if (SqlDatabase.supported) {
      this.store = new WebSqlStore('dabble', 'dabble');
    } else {
      this.store = new MemoryStore();
    }
  }

  /* create a persistant dabble instance populated with an id */
  @override
  Future<ADabble> createNewDabble({owner: 'anonymous'}) {
    return doSave(new ADabble(makeDabbleId(), owner));
  }

  Future<ADabble> doSave(ADabble dabble) {
    return store.open()
        .then((_)  => store.save(dabble.serialize(), dabble.id))
        .then((_) => dabble);
  }

  // TODO: make this not stupid
  String makeDabbleId() {
    int random = new math.Random().nextInt(100000000);
    String encoding = "0123456789abcdefghijklmnopqrstuvwxyz";
    String dabbleId = "";
    do {
      var digit = random % 36;
      dabbleId = "${encoding[digit]}$dabbleId";
      random = (random / 36).floor();
    } while (random > 0);
    return dabbleId;
  }
  
  /* delete a dabble by passing in the id */
  @override
  Future deleteDabble(String dabbleId) {
    return store.removeByKey(dabbleId);
  }

  @override
  Future<ADabble> getDabble(String dabbleId) {
    return store.open().then((_) {
      return store.getByKey(dabbleId).then(ADabble.revive);
    });
  }

  /* update a dabble instance itself */
  @override
  Future<ADabble> insertNewVersion(String dabbleId, DabbleData newData) {
    return getDabble(dabbleId).then((ADabble dabble) {
      if (dabble == null) { return null; }
      dabble.current = newData;
      return doSave(dabble);
    });
  }

  /* when a particular dabble is updated */
  Stream<DabbleData> onUpdate(String dabbleId);
}

