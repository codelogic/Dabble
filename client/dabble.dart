part of dabble.client;

void main() {
  query("#save")
    .onClick
    .listen((event) => Window.alert("WIN!"));
  
  var subscription = query("#save").onClick.listen(
      (event) => print('click!'));

  subscription.cancel();
}
