import 'dart:io';
import 'package:pathos/path.dart' as path;
import 'package:web_ui/component_build.dart';

void main() {
  Options options = new Options();
  build(options.arguments, ['server/web/index.html']);
  String dir = path.dirname(options.executable);
  Process.run("$dir/dart2js",
      ["-oserver/web/out/index.html_bootstrap.dart.js",
       "server/web/out/index.html_bootstrap.dart"]);
}

