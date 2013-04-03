

import 'dart:async';
import 'dart:io';

void main() {
  int port = 8000;
  HttpServer.bind('127.0.0.1', port)
    .then((HttpServer server) {
      print('listening for connections on $port');
      
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
