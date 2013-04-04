library dabble.client.dabble;

import 'dart:html';
import 'dart:async';
import 'package:web_ui/watcher.dart';
import 'client.dart';
import 'lib/core.dart';
import 'reset-timer.dart';

const TIMEOUT = const Duration(seconds: 1);

String htmlInput = "";
String cssInput = "";
String jsInput = "";
String title = "";
String description = "";

ResetTimer saveTimer = new ResetTimer(TIMEOUT, save);

DabbleApi api = new DabbleApiImpl(new RemoteDabbleApi());
ADabble currentDabble = null;

void main() {
  query("#save")
    .onClick.listen((_) => save());

  watch(() => htmlInput, (_) => saveTimer.reset());
  watch(() => cssInput, (_) => saveTimer.reset());
  watch(() => jsInput, (_) => saveTimer.reset());
}

Future<ADabble> createNewDabble() {
  return api.createNewDabble();
}

void updatedDabbleWithData(ADabble dabble, DabbleData newData) {
    api.insertNewVersion(dabble.id, newData);

    // TODO: move this to occur on an api event.
    renderData(newData);
}

void renderData(DabbleData data) {
  var render = new Renderer();
  String result = render.render(markup: data.markup, style: data.style, code: data.code);

  (query("#render-area") as IFrameElement).srcdoc = result;
}

void save() {
  var data = compileDabbleData();

  if (currentDabble == null) {
    createNewDabble()
      .then((dabble) => updatedDabbleWithData(dabble, data));
  } else {
    updatedDabbleWithData(currentDabble, data);
  }
}

DabbleData compileDabbleData() {
  String name = (query("#d-name") as InputElement).value;
  String description = (query("#d-description") as TextAreaElement).value;

  DabbleData previous = currentDabble == null ? null : currentDabble.current;

  DabbleData data = new DabbleData(
      name,
      description,
      previous,
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
