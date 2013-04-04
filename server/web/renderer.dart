part of dabble.client;

class Renderer {
  String render({LanguageData markup, LanguageData style, LanguageData code}) {
    var host = window.location.host;
    String lt = languageType(code);
    return dataUri(
      "<!doctype html>\n<html><head><style type=\"text/css\">"
      + (style == null ? '' : style.rawText)
      + "</style></head><body>"
      + (markup == null ? '' : markup.rawText)
      + "<script type=\"$lt\">"
      + (code == null ? '' : preparedText(code))
      + "</script>"
      + (lt == 'application/dart' ? "<script src=\"http://$host/packages/browser/dart.js\")></script>" : "")
      + "</body></html>");
  }

  String dataUri(String value) {
    return "data:text/html;base64," + CryptoUtils.bytesToBase64(value.codeUnits);
  }

  String languageType(LanguageData code) {
    if (code.language == 'dart' && (
        hasDart() || code.compiledText == null || code.compiledText == "")) {
      return "application/dart";
    }
    return "text/javascript";
  }
  
  bool hasDart() {
    bool _hasDart = false;
    try {
      js.scoped(() {
        _hasDart = js.context.window.navigator.webkitStartDart != null;
      });
    } catch(_) { }
    return _hasDart;
  }


  String preparedText(LanguageData code) {
    if (hasDart() || code.compiledText == null || code.compiledText == "") {
      return code.rawText;
    }
    return code.compiledText;
  }
}