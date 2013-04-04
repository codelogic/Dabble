library dabble.client.dabble;

import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'package:web_ui/web_ui.dart';
import 'client.dart';
import 'lib/core.dart';
import 'package:js/js.dart' as js;
import 'reset-timer.dart';
import 'editorComponent.dart';

const TIMEOUT = const Duration(seconds: 1);

@observable
String title = "";
@observable
String description = "";

ResetTimer saveTimer = new ResetTimer(TIMEOUT, save);

LocalDabbleApi localApi = new LocalDabbleApi(new RemoteDabbleApi());
ADabble currentDabble = null;

EditorComponent markupEditor;
EditorComponent styleEditor;
EditorComponent codeEditor;

void main() {
  Timer.run(() => deferedMain());
}

void deferedMain() {
  markupEditor = (query("#markupEditor").xtag as EditorComponent);
  styleEditor = (query("#styleEditor").xtag as EditorComponent);
  codeEditor = (query("#codeEditor").xtag as EditorComponent);

  tryLoadPreviouslySavedDabble();

  markupEditor.stream.listen((String data) => saveTimer.reset());
  styleEditor.stream.listen((String data) => saveTimer.reset());
  codeEditor.stream.listen((String data) => saveTimer.reset());

  watch(() => title, (_) => saveTimer.reset());
  watch(() => description, (_) => saveTimer.reset());
}

Future<ADabble> createNewDabble() {
  return localApi.createNewDabble()
      .then((dabble) => currentDabble = dabble)
      .then(registerListener);
}

ADabble registerListener(ADabble dabble) {
  if (dabble != null) {
    localApi.onUpdate(dabble.id).listen(renderData);
  }
  return dabble;
}

void updateShareLink() {
  var a = (query("#share-link a") as AnchorElement);
  if (currentDabble.id != null) {
    a.text = "/view/" + currentDabble.id;
    String host = window.location.host;
    a.href = "http://$host/view/${currentDabble.id}";
  }
}

void tryLoadPreviouslySavedDabble() {
  localApi.lastSavedDabbleId()
    .then((id) {
      if(id != null && id != "") {
        localApi.getDabble(id)
          .then((dabble) {
            currentDabble = dabble;
            return dabble;
          })
          .then(registerListener)
          .then((dabble) => populateEditorsWithLoadedData(dabble.current));
      }

      print("Id loaded: ${id}");
    });
}

void populateEditorsWithLoadedData(DabbleData data) {
  if (data != null) {
    print("Populating data");
    print("name: " + data.name);
    print("description: " + data.description);
    print("name: " + data.markup.rawText);
    print("markup: " + data.style.rawText);
    print("code: " + data.code.rawText);
    title = data.name;
    description = data.description;
    markupEditor.editorvalue = data.markup.rawText;
    styleEditor.editorvalue = data.style.rawText;
    codeEditor.editorvalue = data.code.rawText;
  }
}

void updatedDabbleWithData(ADabble dabble, DabbleData newData) {
  localApi.insertNewVersion(dabble.id, newData);
  updateShareLink();
  dabble.current = newData;
}

void renderData(DabbleData data) {
  print("let's render!");
  var id = currentDabble.id;
  (query("#render-area") as IFrameElement).src = "/_i/$id";
}

void clearRenderer() {
  (query("#render-area") as IFrameElement).src = "";
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
  markupEditor.editorvalue = "";
  styleEditor.editorvalue = "";
  codeEditor.editorvalue = "";
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
      ..code = codeLanguageData();

  return data;
}


LanguageData markupLanguageData() {
  LanguageData data = new LanguageData()
    ..language = "html"
    ..rawText = markupEditor.editorvalue
    ..options = {};
  return data;
}

LanguageData styleLanguageData() {
  LanguageData data = new LanguageData()
    ..language = "css"
    ..rawText = styleEditor.editorvalue
    ..options = {};
  return data;
}

LanguageData codeLanguageData() {
  LanguageData data = new LanguageData()
    ..language = "js"
    ..rawText = codeEditor.editorvalue
    ..options = {};
  return data;
}
