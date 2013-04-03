library dabble.client.dabble;

import 'dart:html';
import 'package:dabble/core.dart';

void main() {
  query("#save")
    .onClick.listen((_) => print(compileData().description));


}

DabbleData compileData() {
  String name = (query("#d-name") as InputElement).value;
  String description = (query("#d-description") as TextAreaElement).value;
  
  DabbleData data = new DabbleData(
      name,
      description,
      null,
      markupLanguageBlob(),
      styleLanguageBlob(),
      appLanguageBlob());
  
  return data;
}

LanguageData markupLanguageBlob() => new LanguageData(
      "html",
      query("#htmlinput").value,
      {});

LanguageData styleLanguageBlob() => new LanguageData(
      "css",
      query("#cssinput").value,
      {});

LanguageData appLanguageBlob() => new LanguageData(
      "js",
      query("#jsinput").value,
      {});