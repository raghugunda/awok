import 'dart:async';

import 'package:awok_calculator/helpers/calculator_buttons.dart';


class KeyEvent {

  KeyEvent(this.key);
  final CalculatorKey key;
}

abstract class KeyController {

  static StreamController _controller = StreamController();
  static Stream get _stream => _controller.stream;

  static StreamSubscription listen(Function handler) => _stream.listen(handler as dynamic);//accessing messages
  static void fire(KeyEvent event) => _controller.add(event);//allow object to send messages

  static dispose() => _controller.close();// close the streambuilder
}