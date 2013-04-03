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
      (query("#htmlinput") as TextAreaElement).value,
      {});

LanguageData styleLanguageData() => new LanguageData(
      "css",
      (query("#cssinput") as TextAreaElement).value,
      {});

LanguageData appLanguageData() => new LanguageData(
      "js",
      (query("#jsinput") as TextAreaElement).value,
      {});