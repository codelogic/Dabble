import 'package:web_ui/web_ui.dart';
import 'package:js/js.dart' as js;

class EditorComponent extends WebComponent {
  String _editorValue = "";
  String editorstyle;
  String mode = "ace/mode/javascript";
  String theme = "ace/theme/monokai";
  var editor;
  inserted() {
    js.scoped(() {
      var ace = js.context.ace;
      var node = _root.query("#editor");
      editor = new js.Proxy(ace.edit, node);
      editor.setTheme(theme);
      editor.getSession().setMode(mode);
      editor.getSession().setValue(_editorValue);
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
}

