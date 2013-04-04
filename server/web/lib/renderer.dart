part of dabble.core;

class Renderer {
  String render({LanguageData markup, LanguageData style, LanguageData code}) {
    String lt = languageType(code);
    return dataUri(
      "<!doctype html>\n<html><head><style type=\"text/css\">"
      + (style == null ? '' : style.rawText)
      + "</style></head><body>"
      + (markup == null ? '' : markup.rawText)
      + "<script type=\"$lt\">"
      + (code == null ? '' : preparedText(code))
      + "</script>"
      + (lt == 'application/dart' ? "<script src=\"/packages/browser/dart.js\")></script>" : "")
      + "</body></html>");
  }

  String dataUri(String value) {
    return "data:text/html;base64," + CryptoUtils.bytesToBase64(value.codeUnits);
  }

  String languageType(LanguageData code) {
    if (code.language == 'dart' && (code.compiledText == null || code.compiledText == "")) {
      return "application/dart";
    }
    return "text/javascript";
  }

  String preparedText(LanguageData code) {
    if (code.compiledText == null || code.compiledText == "") {
      return code.rawText;
    }
    return code.compiledText;
  }
}