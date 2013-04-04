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

  @override
  void insertNewVersion(String dabbleId, DabbleData newData) {
    var completer = new Completer<ADabble>();
    var xhr = new HttpRequest();
    xhr.open('POST', '/_/$dabbleId', async: true);
    xhr.send(newData.serialize());
  }

  @override
  Stream<DabbleData> onUpdate(String dabbleId) {
    print("let's try to connect!");
    Location location = window.location;
    String host = location.host;
    String port = location.port;
    WebSocket ws = new WebSocket('ws://$host/ws/$dabbleId');
    return ws.onMessage.transform(new StreamTransformer<MessageEvent, DabbleData>(
        handleData: (MessageEvent value, EventSink<DabbleData> sink) {
          sink.add(DabbleData.revive(value.data));
        }));
  }
}
