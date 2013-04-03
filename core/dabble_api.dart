part of dabble.core;

abstract class DabbleApi {
  Future<String> createNewDabble();
  Future deleteDabble(String dabbleId);
  Future updateDabble(ADabble dabble);
  
  Stream onUpdate(String id);
}