import 'package:web_ui/web_ui.dart';
import 'package:js/js.dart' as js;
import 'dart:async';

class EditorComponent extends WebComponent {
  String _editorValue = "";
  String editorstyle;
  String mode = "ace/mode/javascript";
  String theme = "ace/theme/GitHub";
  StreamController<String> valueStreamController = new StreamController.broadcast();

  var editor;
  inserted() {
    js.scoped(() {
      var ace = js.context.ace;
      var node = _root.query("#editor");
      editor = new js.Proxy(ace.edit, node);
      editor.setTheme(theme);
      editor.getSession().setMode(mode);
      editor.getSession().setValue(_editorValue);
      editor.on("change", new js.Callback.many((_) {
        js.scoped(() {
          _editorValue = editor.getSession().getValue();
          valueStreamController.add(_editorValue);
        });
      }));
      if (editorstyle != null) {
        editor.setStyle(editorstyle);
        _root.query("#editorContainer").classes.add(editorstyle);
      }
      js.retain(editor);
    });
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
  
  Stream<String> get stream => valueStreamController.stream;
}

