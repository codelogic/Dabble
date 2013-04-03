library dabble.dabble;

import 'dart:html';
import 'package:dabble/core.dart';

void main() {
  query("#save")
    .onClick.listen((_) => compileData.description);
}

DabbleData compileData() {
  String name = query("#d-name").text;
  String description = query("#d-description").text;
  
  DabbleData data = new DabbleData(
      name: name,
      description: description,
      markup: markupLanguageBlob(),
      style: styleLanguageBlob(),
      applicationCode: appLanguageBlob());
  
  return data;
}

LanguageData markupLanguageBlob() => new LanguageData(
      language: "html",
      rawText: query("#htmlinput").value,
      options: {});

LanguageData styleLanguageBlob() => new LanguageData(
      language: "css",
      rawText: query("#cssinput").value,
      options: {});

LanguageData appLanguageBlob() => new LanguageData(
      language: "js",
      rawText: query("#jsinput").value,
      options: {});