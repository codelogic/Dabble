part of dabble.core;

class Renderer {
  String render({LanguageData markup, LanguageData style, LanguageData code}) {
    String result =
        "<!doctype html>\n<html><head><style type=\"text/css\">"
        + "${style == null ? '' : style.rawText}"
        + "</style></head><body>"
        + (markup == null ? '' : markup.rawText)
        + "<script type=\"text/javascript\">"
        + (code == null ? '' : code.rawText)
        + "</script></body></html>";

    return result;
  }
}