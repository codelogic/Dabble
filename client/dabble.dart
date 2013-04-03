library dabble.dabble;

import 'dart:html';

void main() {
  query("#save")
    .onClick.listen((_) => print("hello"));
  
  query("#htmlinput")
    .onKeyUp.listen((event) => print(event.charCode));
}