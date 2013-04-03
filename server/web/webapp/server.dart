import 'dart:async';
import 'dart:io';
import "package:stream/stream.dart";

void main() {
  var map = {
     //'/style/(path:.*)': '/out/style/(path)',
     '/': '/out/index.html',
     '/dabble.dart': '/out/dabble.dart',
     '/dabble.dart.map': '/out/dabble.dart.map',
     '/index.html_bootstrap.dart': '/out/index.html_bootstrap.dart',
  };
  new StreamServer(uriMapping: map).start();
}