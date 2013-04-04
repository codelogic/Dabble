import 'dart:io';
import 'package:stream/rspc.dart' as RSPC;
import 'package:pathos/path.dart' as path;
import 'package:web_ui/component_build.dart' as WEBUI;

void main() {
  Options options = new Options();
  RSPC.build(options.arguments);
  WEBUI.build(options.arguments, ['server/web/index.html', 'server/web/editorComponent.html']);
  String dir = path.dirname(options.executable);
  Process.run("$dir/dart2js",
      ["-oserver/web/out/index.html_bootstrap.dart.js",
       "server/web/out/index.html_bootstrap.dart"]);
}

