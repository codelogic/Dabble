part of dabble.core;

abstract class DabbleApi {
  /* create a persistant dabble instance populated with an id */
  Future<ADabble> createNewDabble({owner: 'anonymous'});
  
  /* delete a dabble by passing in the id */
  Future deleteDabble(String dabbleId);
  
  /* update a dabble instance itself */
  Future insertNewVersion(String dabbleId, DabbleData newData);
  
  /* when a particular dable is update */
  Stream onUpdate(String dabblId);
}