part of dabble.client;

class RemoteDabbleApi extends DabbleApi {
  /* create a persistant dabble instance populated with an id */
  @override
  Future<ADabble> createNewDabble({owner: 'anonymous'}) {
    var completer = new Completer<ADabble>();
    var xhr = new HttpRequest();
    xhr.open('POST', '/_/', async: true);
    xhr.send(JSON.stringify({'owner': owner}));
    xhr.onLoad.listen((e) {
      // Note: file:// URIs have status of 0.
      if ((xhr.status >= 200 && xhr.status < 300) ||
          xhr.status == 0 || xhr.status == 304) {
        completer.complete(ADabble.revive(xhr.responseText));
      } else {
        completer.completeError(e);
      }
    });
    return completer.future;
  }
}

