import 'dart:io';
import 'package:pathos/path.dart' as path;
import 'package:web_ui/component_build.dart' as WEBUI;

void main() {
  Options options = new Options();
  WEBUI.build(options.arguments, [
    'server/web/index.html',
    'server/web/editorComponent.html',
    'server/web/live.html']);
  String dir = path.dirname(options.executable);
  Process.run("$dir/dart2js",
      ["-oserver/web/out/index.html_bootstrap.dart.js",
       "server/web/out/index.html_bootstrap.dart"]);
  Process.run("$dir/dart2js",
      ["-oserver/web/out/live.html_bootstrap.dart.js",
       "server/web/out/live.html_bootstrap.dart"]);
  Process.run("$dir/dart2js",
      ["-oserver/web/out/editorComponent.html_bootstrap.dart.js",
       "server/web/out/editorComponent.html_bootstrap.dart"]);
}

