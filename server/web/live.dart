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
bool autoreload = true;
StreamSubscription listenHandler = null;

void main() {
  Timer.run(() => deferedMain());
}

void deferedMain() {
  Location location = window.location;
  String path = location.pathname;
  String id = path.substring(path.lastIndexOf("/") + 1);
  print("id is $id");
  tryLoadPreviouslySavedDabble(id);
  watch(() => autoreload, (_) => updateAutoReload());
}

void updateAutoReload() {
  if(autoreload) {
    if(listenHandler == null) {
      listenHandler = api.onUpdate(currentDabble.id).listen(renderData);
    }
  } else {
    if(listenHandler != null) {
      listenHandler.unsubscribe();
      listenHandler == null;
    }
  }
}

ADabble registerListener(ADabble dabble) {
  listenHandler = api.onUpdate(dabble.id).listen(renderData);
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
  query('#d-title').text = data.name == null ? "" : data.name;
  
  var a = (query("#share-link a") as AnchorElement);
  a.text = "/view/" + currentDabble.id;
  String host = window.location.host;
  var id = currentDabble.id;
  a.href = "http://$host/view/${id}";
  
  (query("#render-area") as IFrameElement).src =
      new Renderer().render(markup: data.markup, style: data.style, code: data.code);
}

void clearRenderer() {
  (query("#render-area") as IFrameElement).src = "";
}

void refresh() {
  if(currentDabble != null) {
    renderData(currentDabble.current);
  }
}
