part of dabble.core;

abstract class DabbleApi {
  /* create a persistant dabble instance populated with an id */
  Future<ADabble> createNewDabble({owner: 'anonymous'});
  
  /** Gets a dabble by id. */
  Future<ADabble> getDabble(String dabbleId);

  /* delete a dabble by passing in the id */
  Future deleteDabble(String dabbleId);
  
  /* update a dabble instance itself */
  Future<ADabble> insertNewVersion(String dabbleId, DabbleData newData);
  
  /* when a particular dabble is updated */
  Stream<DabbleData> onUpdate(String dabbleId);
}