

import 'dart:async';
import 'dart:io';

void main() {
  int websocketPort = 8000;
  int regularPort = 8080;
  HttpServer.bind('127.0.0.1', websocketPort)
    .then((HttpServer server) {
      print('listening for connections on $websocketPort');
      
      var wsh = new WebSocketHandler();
      var sc = new StreamController();
      sc.stream
        .transform(new WebSocketTransformer())
        .listen(wsh.onConnection);

      server.listen((HttpRequest request) {
        if (request.uri.path == '/ws') {
          sc.add(request);
        } else {
          /* ... */
        }
      });
    },
    onError: (error) => print("Error starting HTTP server: $error"));
  
  HttpServer.bind('127.0.0.1', regularPort)
  .then((HttpServer server) {
    print('listening for connections on $regularPort');

    server.listen(requestReceivedHandler);
  },
  onError: (error) => print("Error starting HTTP server: $error"));
}

class WebSocketHandler {
  Set<WebSocket> connections;
  onConnection(WebSocket conn) {
    void onMessage(message) {
      print('new ws msg: $message');
      connections.forEach((connection) {
        if (conn != connection) {
          print('queued msg to be sent');
          connection.send(message);
        }
      });
    }
    
    print('new ws conn');
    connections.add(conn);
    conn.listen(onMessage,
      onDone: () => connections.remove(conn),
      onError: (e) => connections.remove(conn)
    );
  }
}

void requestReceivedHandler(HttpRequest request) {
  request.response.headers.set(
      HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8");
  String text;
  if (request.uri.path == '/render') {
    /* text = createHtmlResponse(); */
    text = '''rendering''';
  } else if (request.uri.path == '/save') {
    text = '''saving''';
  } else {
    text = '''unknown command''';
  }
  request.response.write(text);
  request.response.close();
}

String createHtmlResponse() {
  return
'''
<html>
  
  <body>
    ${new DateTime.now()}
  </body>
</html>

''';
}
