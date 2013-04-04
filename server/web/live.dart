import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'package:web_ui/web_ui.dart';
import 'client.dart';
import 'lib/core.dart';
import 'reset-timer.dart';

const TIMEOUT = const Duration(seconds: 1);

RemoteDabbleApi api = new RemoteDabbleApi();
ADabble currentDabble = null;

void main() {
  Timer.run(() => deferedMain());
}

void deferedMain() {
  Location location = window.location;
  String path = location.pathname;
  String id = path.substring(path.lastIndexOf("/") + 1);
  print("id is $id");
  tryLoadPreviouslySavedDabble(id);
}

ADabble registerListener(ADabble dabble) {
  api.onUpdate(dabble.id).listen(renderData);
  return dabble;
}

void tryLoadPreviouslySavedDabble(String id) {
  if(id != null && id != "") {
    api.getDabble(id)
      .then((dabble) {
        currentDabble = dabble;
        return dabble;
      })
      .then(registerListener)
      .then((dabble) => renderData(dabble.current));
  }
}

void renderData(DabbleData data) {
  print("let's render!");
  query('#name').text = data.name == null ? "" : data.name;
  var render = new Renderer();
  String result = render.render(markup: data.markup, style: data.style, code: data.code);

  (query("#render-area") as IFrameElement).srcdoc = result;
}

void clearRenderer() {
  (query("#render-area") as IFrameElement).srcdoc = "";
}

void refresh() {
  if(currentDabble != null) {
    renderData(currentDabble.current);
  }
}
