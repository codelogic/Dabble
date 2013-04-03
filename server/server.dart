

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
          /* sc.add(request); */
          String text = createHtmlResponse();
          request.response.headers.set(HttpHeaders.CONTENT_TYPE, "text/html; charset=UTF-8");
          request.response.write(text);
          request.response.close();
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

String createHtmlResponse() {
  return
'''
<html>
  <style>
    body { background-color: teal; }
    p { background-color: white; border-radius: 8px;
        border:solid 1px #555; text-align: center; padding: 0.5em;
        font-family: "Lucida Grande", Tahoma; font-size: 18px; color: #555; }
  </style>
  <body>
    <br/><br/>
    <p>Current time: ${new DateTime.now()}</p>
  </body>
</html>
''';
}
