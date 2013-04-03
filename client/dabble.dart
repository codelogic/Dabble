library dabble.client.dabble;

import 'dart:html';
import 'client.dart';
import 'package:dabble/core.dart';

void main() {
  foo();
  query("#save")
    .onClick.listen((_) => save());
}

void save() {
  var data = compileDabbleData();
  // For now, just print the description to the console.
  print(data.description);
  var render = new Renderer();
  String result = render.render(markup: data.markup, style: data.style, code: data.code);

  (query("#render-area") as IFrameElement).srcdoc = result;
}
String htmlInput = "";
String cssInput = "";
String jsInput = "";

DabbleData compileDabbleData() {
  String name = (query("#d-name") as InputElement).value;
  String description = (query("#d-description") as TextAreaElement).value;

  DabbleData data = new DabbleData(
      name,
      description,
      null,
      markupLanguageData(),
      styleLanguageData(),
      appLanguageData());

  return data;
}

LanguageData markupLanguageData() => new LanguageData(
      "html",
      htmlInput,
      {});

LanguageData styleLanguageData() => new LanguageData(
      "css",
      cssInput,
      {});

LanguageData appLanguageData() => new LanguageData(
      "js",
      jsInput,
      {});

foo() {
  DabbleApi api = new DabbleApiImpl();
  api.createNewDabble().then((dabble) {
    print(dabble.id);
    api.insertNewVersion(dabble.id, new DabbleData("Dabble test",
        "test desc",
        null,
        new LanguageData("html",
        "<div/>",
        null),
        new LanguageData("css",
            ".foo { color: #fff; }",
            null),
        new LanguageData("js",
            "foo bar baz",
            null))).then((dabble) { print(dabble.id);});
  });
}