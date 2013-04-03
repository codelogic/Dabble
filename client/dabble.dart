library dabble.client.dabble;

import 'dart:html';
import 'package:dabble/core.dart';

void main() {
  query("#save")
    .onClick.listen((_) => save());


}

void save() {
  // For now, just print the description to the console.
  print(compileDabbleData().description);
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