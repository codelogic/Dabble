import 'package:web_ui/component_build.dart';
import 'dart:io';

void main() {
  build(new Options().arguments, ['server/web/index.html', 'server/web/editorComponent.html']);
}

