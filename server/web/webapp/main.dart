part of dabble.server;

void main() {
  var map = {
     '/': '/out/index.html',
     '/dabble.dart': '/out/dabble.dart',
     '/dabble.dart.map': '/out/dabble.dart.map',
     '/index.html_bootstrap.dart': '/out/index.html_bootstrap.dart',
     '/index.html_bootstrap.dart.js': '/out/index.html_bootstrap.dart.js',
     '/index.html_bootstrap.dart.js.deps': '/out/index.html_bootstrap.dart.js.deps',
     '/index.html_bootstrap.dart.js.map': '/out/index.html_bootstrap.dart.js.map',
     '/editorComponent.dart': '/out/editorComponent.dart',
     '/editorComponent.dart.map': '/out/editorComponent.dart.map',
     '/editorComponent.html_bootstrap.dart': '/out/editorComponent.html_bootstrap.dart',
     '/editorComponent.html_bootstrap.dart.js': '/out/editorComponent.html_bootstrap.dart.js',
     '/editorComponent.html_bootstrap.dart.js.deps': '/out/editorComponent.html_bootstrap.dart.js.deps',
     '/editorComponent.html_bootstrap.dart.js.map': '/out/editorComponent.html_bootstrap.dart.js.map',
     '/_/(id:.*)': api,
     '/ws/(id:.*)': ws,
     '/view/(id:.*)': live,
  };

  new StreamServer(uriMapping: map).start();
}

Map<String, StreamController<DabbleData>> _map = new Map();

void ws(HttpConnect connect) {
  String id = connect.dataset['id'];
  WebSocketTransformer.upgrade(connect.request).then((WebSocket websocket) {
    print("Got websocket connection!");
    var sub = getStream(id).stream.listen((DabbleData data) {
      try {
        websocket.send(data.serialize());
      } catch(e) {
        print("socket error.");
        sub.cancel();
      }
    });
    StreamSubscription wsSub = websocket.listen((_) {});
    wsSub..onDone(() {sub.cancel();})
         ..onError((_) {sub.cancel();});
  });
}

void notifyUpdate(String id, DabbleData data) {
  getStream(id).add(data);
}

StreamController<DabbleData> getStream(String id) {
  if (!_map.containsKey(id)) {
    _map[id] = new StreamController.broadcast();
  }
  return _map[id];
}

// Viktor....
// TODO: replace with storage API.
Map<String, ADabble> _data = new Map();

void api(HttpConnect connect) {
  print(connect);
  HttpRequest req = connect.request;
  String id = connect.dataset['id'];
  if (req.method == 'POST') {
    if (id != null && id != "") {
      _readBody(req, (body) { doUpdate(id, body, connect); });
    } else {
      _readBody(req, (body) { doCreate(body, connect); });
    }
  } else if (req.method == 'GET') {
    HttpResponse resp = connect.response;
    resp..headers.contentType = new ContentType.fromString("text/json")
        ..write(getDabble(id).serialize());
    connect.close();
  } else if (req.method == 'DELETE') {
    _data[id] = null;
    HttpResponse resp = connect.response;
    resp..headers.contentType = new ContentType.fromString("text/json")
    ..write(JSON.stringify(""));
    connect.close();
  } 
}

ADabble getDabble(String id) {
  ADabble dabble = _data[id];
  if (dabble == null) {
    dabble = new ADabble(id, 'anonymous');
    dabble.current = new DabbleData();
    _data[id] = dabble;
  }
  return dabble;
}

doUpdate(String id, String body, HttpConnect connect) {
  DabbleData data = DabbleData.revive(body);
  ADabble dabble = getDabble(id);
  dabble.current = data;
  _data[id] = dabble;
  notifyUpdate(id, data);
  HttpResponse resp = connect.response;
  resp..headers.contentType = new ContentType.fromString("text/json")
      ..write(JSON.stringify(""));
  connect.close();
}

doCreate(String body, HttpConnect connect) {
  print("body: $body");
  var options = JSON.parse(body);
  String owner = options['owner'] == null ? options['owner'] : 'anonymous';
  ////////******VIKTOR**********//////////
  /* 
   * 1.Construct JSON request
   * 2.Send request to the cloud (http://dadabble.appspot.com/dabbleapi)
   * 3. receive JSON response (id) and parse it
   * 4. instantiate the Dabble object 
   */
  ADabble dabble = new ADabble(makeDabbleId(), owner);  
  _data[dabble.id] = dabble;
  print(dabble.id);
  HttpResponse resp = connect.response;
  resp..headers.contentType = new ContentType.fromString("text/json")
      ..write(dabble.serialize());
  connect.close();
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

// Read body of [request] and call [handleBody] when complete.
_readBody(HttpRequest request, void handleBody(String body)) {
  request.transform(new StringDecoder()).toList().then((data) {
    var body = data.join('');
    print(body);
    handleBody(body);
  });
}