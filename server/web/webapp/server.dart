import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import "package:stream/stream.dart";
import "dart:json" as JSON;
import "../lib/core.dart";

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
  };

  new StreamServer(uriMapping: map).start();
}

Map<String, StreamController<DabbleData>> _map = new Map();

void ws(HttpConnect connect) {
  String id = connect.dataset['id'];
  WebSocketTransformer.upgrade(connect.request).then((WebSocket websocket) {
    print("Got websocket connection!");
    getStream(id).stream.listen((DabbleData data) {
      websocket.send(data.serialize());
    });
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

void api(HttpConnect connect) {
  print(connect);
  HttpRequest req = connect.request;
  if (req.method == 'POST') {
    String id = connect.dataset['id'];
    if (id != null && id != "") {
      _readBody(req, (body) { doUpdate(id, body, connect); });
    } else {
      _readBody(req, (body) { doCreate(body, connect); });
    }
  }
}

doUpdate(String id, String body, HttpConnect connect) {
  DabbleData data = DabbleData.revive(body);
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