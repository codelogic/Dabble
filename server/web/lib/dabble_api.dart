part of dabble.core;

abstract class DabbleApi {
  /** create a persistant dabble instance populated with an [dabbleId] */
  Future<ADabble> createNewDabble({owner: 'anonymous'});

  /** Gets a dabble by [dabbleId]. */
  Future<ADabble> getDabble(String dabbleId);

  /** delete a dabble by passing in the [dabbleId] */
  Future deleteDabble(String dabbleId);

  /** update a dabble via [dabbleId] instance with [newData] */
  void insertNewVersion(String dabbleId, DabbleData newData);

  /* when a particular dabble is updated */
  Stream<DabbleData> onUpdate(String dabbleId);
}