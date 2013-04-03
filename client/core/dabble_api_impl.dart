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
    String dabbleId = makeDabbleId();

    return store.open()
    .then((_) => store.save(dabbleId, new ADabble(dabbleId, owner)));
  }

  String makeDabbleId() {
    int random = new math.Random().nextDouble() * 100000000;
    String encoding = "0123456789abcdefghijklmnopqrstuvwxyz";
    String dabbleId = "";
    do {
      var digit = random % 36;
      dabbleId = "${encoding[digit]}$dabbleId";
      random = (int) (random / 36);
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
    return store.getByKey(dabbleId);
  }

  /* update a dabble instance itself */
  @override
  Future<ADabble> insertNewVersion(String dabbleId, DabbleData newData) {
    getDabble(dabbleId)
    .then((dabble) {
      dabble.current = newData;
      return store.save(dabbleId, dabble);
    });
  }
  
  /* when a particular dabble is updated */
  Stream<DabbleData> onUpdate(String dabbleId);
}

