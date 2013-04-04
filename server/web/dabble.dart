library dabble.client.dabble;

import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'package:web_ui/web_ui.dart';
import 'client.dart';
import 'lib/core.dart';
import 'package:js/js.dart' as js;
import 'reset-timer.dart';

const TIMEOUT = const Duration(seconds: 1);

@observable
String htmlInput = "";
@observable
String cssInput = "";
@observable
String jsInput = "";
@observable
String title = "";
@observable
String description = "";

ResetTimer saveTimer = new ResetTimer(TIMEOUT, save);

LocalDabbleApi localApi = new LocalDabbleApi();
ADabble currentDabble = null;

void main() {
  tryLoadPreviouslySavedDabble();

  watch(() => htmlInput, (_) => saveTimer.reset());
  watch(() => cssInput, (_) => saveTimer.reset());
  watch(() => jsInput, (_) => saveTimer.reset());
  watch(() => title, (_) => saveTimer.reset());
  watch(() => description, (_) => saveTimer.reset());
}

Future<ADabble> createNewDabble() {
  return localApi.createNewDabble().then((dabble) => currentDabble = dabble);
}

void tryLoadPreviouslySavedDabble() {
  localApi.lastSavedDabbleId()
    .then((id) {
      if(id != null && id != "") {
        localApi.getDabble(id)
          .then((dabble) => currentDabble = dabble)
          .then((dabble) => populateEditorsWithLoadedData(dabble.current));
      }

      print("Id loaded: ${id}");
    });
}

void populateEditorsWithLoadedData(DabbleData data) {
  print("Populating data");
  print("name: " + data.name);
  print("description: " + data.description);
  print("name: " + data.markup.rawText);
  print("markup: " + data.style.rawText);
  print("code: " + data.code.rawText);
  title = data.name;
  description = data.description;
  htmlInput = data.markup.rawText;
  cssInput = data.style.rawText;
  jsInput = data.code.rawText;
}

void updatedDabbleWithData(ADabble dabble, DabbleData newData) {
  localApi.insertNewVersion(dabble.id, newData);
  dabble.current = newData;

  query("#status").text = "http://localhost:8080/anon/${dabble.id}";

  // TODO: move this to occur on an api event.
  renderData(newData);
}

void renderData(DabbleData data) {
  var render = new Renderer();
  String result = render.render(markup: data.markup, style: data.style, code: data.code);

  (query("#render-area") as IFrameElement).srcdoc = result;
}

void clearRenderer() {
  (query("#render-area") as IFrameElement).srcdoc = "";
}

void save() {
  if (currentDabble == null) {
    createNewDabble()
      .then((dabble) => updatedDabbleWithData(dabble, compileDabbleData()));
  } else {
    updatedDabbleWithData(currentDabble, compileDabbleData());
  }
}

void clear() {
  createNewDabble();
  title = "";
  description = "";
  htmlInput = "";
  cssInput = "";
  jsInput = "";
  clearRenderer();
  print("clearing");
}

void refresh() {
  if(currentDabble != null) {
    renderData(currentDabble.current);
  }
}

DabbleData compileDabbleData() {
  String name = (query("#d-name") as InputElement).value;
  String description = (query("#d-description") as TextAreaElement).value;

  String dabbleId = currentDabble == null ? null : currentDabble.id;

  DabbleData data = new DabbleData()
      ..name = name
      ..description = description
      ..dabbleId = dabbleId
      ..markup = markupLanguageData()
      ..style = styleLanguageData()
      ..code = appLanguageData();

  return data;
}


LanguageData markupLanguageData() {
  LanguageData data = new LanguageData()
    ..language = "html"
    ..rawText = htmlInput
    ..options = {};
  return data;
}

LanguageData styleLanguageData() {
  LanguageData data = new LanguageData()
    ..language = "css"
    ..rawText = cssInput
    ..options = {};
  return data;
}

LanguageData appLanguageData() {
  LanguageData data = new LanguageData()
    ..language = "js"
    ..rawText = jsInput
    ..options = {};
  return data;
}
