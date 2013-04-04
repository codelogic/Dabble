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
     '/index.html_bootstrap.dart': '/out/index.html_bootstrap.dart',
     '/index.html_bootstrap.dart.js': '/out/index.html_bootstrap.dart.js',
     '/index.html_bootstrap.dart.js.deps': '/out/index.html_bootstrap.dart.js.deps',
     '/index.html_bootstrap.dart.js.map': '/out/index.html_bootstrap.dart.js.map',
     '/dabble.dart.map': '/out/dabble.dart.map',
     '/_/': api,
  };
  new StreamServer(uriMapping: map).start();
}

void api(HttpConnect connect) {
  print(connect);
  HttpRequest req = connect.request;
  if (req.method == 'POST') {
    _readBody(req, (body) { doCreate(body, connect); });
  }
}

doCreate(String body, HttpConnect connect) {
  print("body: $body");
  var options = JSON.parse(body);
  String owner = options['owner'] == null ? options['owner'] : 'anonymous';
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