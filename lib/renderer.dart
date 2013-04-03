part of dabble.core;

class Renderer {
  String render({LanguageData markup, LanguageData style, LanguageData code}) {
    String result = "<!doctype html>\n<html><head><style type=\"text/css\">"
        + style.rawText
        + "</style></head><body>"
        + markup.rawText
        + "<script type=\"text/javascript\">"
        + code.rawText
        + "</script></body>";

    return result;
  }
}