import 'package:web_ui/web_ui.dart';
import 'package:js/js.dart' as js;
import 'dart:async';

class EditorComponent extends WebComponent {
  String _editorValue = "";
  String editorstyle;
  String _mode = "ace/mode/javascript";
  String theme = "ace/theme/GitHub";
  StreamController<String> valueStreamController = new StreamController();

  var editor;
  inserted() {
    js.scoped(() {
      var ace = js.context.ace;
      var node = getShadowRoot('x-dabble-editor').query("#editor");
      editor = new js.Proxy(ace.edit, node);
      editor.setTheme(theme);
      editor.getSession().setMode(_mode);
      editor.getSession().setValue(_editorValue);
      editor.on("change", new js.Callback.many((_) {
        js.scoped(() {
          _editorValue = editor.getSession().getValue();
          valueStreamController.add(_editorValue);
        });
        if (editorstyle != null) {
          editor.setStyle(editorstyle);
          getShadowRoot('x-dabble-editor').query("#editorContainer").classes.add(editorstyle);
        }
      }));
      js.retain(editor);
    });
  }

  set mode(String mode) {
    _mode = mode;
    if (editor != null) {
      js.scoped(() {
        editor.getSession().setMode(_mode);
      });
    }
  }

  set editorvalue(String value) {
    js.scoped(() {
      editor.getSession().setValue(value);
    });
    _editorValue = value;
  }

  String get editorvalue {
    js.scoped(() {
      _editorValue = editor.getSession().getValue();  
    });
    return _editorValue;
  }
  
  Stream<String> get stream => valueStreamController.stream.asBroadcastStream();
}

