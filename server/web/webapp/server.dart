import 'dart:async';
import 'dart:io';
import "package:stream/stream.dart";

void main() {
  var map = {
     '/style/(path:.*)': '/out/style/(path)',
     '/': '/out/index.html',
     '/dabble.dart': '/out/dabble.dart',
     '/index.html_bootstrap.dart': '/out/index.html_bootstrap.dart',
     '/index.html_bootstrap.dart.js': '/out/index.html_bootstrap.dart.js',
     '/index.html_bootstrap.dart.js.deps': '/out/index.html_bootstrap.dart.js.deps',
     '/index.html_bootstrap.dart.js.map': '/out/index.html_bootstrap.dart.js.map',
     '/dabble.dart.map': '/out/dabble.dart.map',
  };
  new StreamServer(uriMapping: map).start();
}