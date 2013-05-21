import 'dart:io';
import 'package:pathos/path.dart' as path;
import 'package:web_ui/component_build.dart' as WEBUI;

void main() {
  Options options = new Options();
  WEBUI.build(options.arguments, [
    'server/web/index.html',
    'server/web/editorComponent.html',
    'server/web/live.html']).then((_) {
        String dir = path.dirname(options.executable);
      print("$dir");
    Process.run("$dir/dart2js",
        ["-oserver/web/out/dabble.dart.js",
         "server/web/out/dabble.dart"]);
    Process.run("$dir/dart2js",
        ["-oserver/web/out/live.dart.js",
         "server/web/out/live.dart"]);
    Process.run("$dir/dart2js",
        ["-oserver/web/out/index.html_bootstrap.dart.js",
         "server/web/out/index.html_bootstrap.dart"]);
    Process.run("$dir/dart2js",
        ["-oserver/web/out/live.html_bootstrap.dart.js",
         "server/web/out/live.html_bootstrap.dart"]);
    Process.run("$dir/dart2js",
        ["-oserver/web/out/editorComponent.html_bootstrap.dart.js",
         "server/web/out/editorComponent.html_bootstrap.dart"]);
  });
}

