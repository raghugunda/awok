import 'dart:async';

import 'package:awok_calculator/helpers/calculator_buttons.dart';
import 'package:awok_calculator/helpers/key_controller.dart';
import 'package:awok_calculator/helpers/symbols.dart';

abstract class Handle_event {

  static KeySymbol _operator;    //holds the current requested mathematical operator
  static String _valA = '0';     //holds the operand left of the operator
  static String _valB = '0';     //holds the operand right of the operator
  static String _result;         //holds the result of the previous calculation

  static StreamController _controller = StreamController();  //class uses to subscribe to messages that contain the updated display value
  static Stream get _stream => _controller.stream;

  static StreamSubscription listen(Function handler) => _stream.listen(handler);
  static void refresh() => _fire(_output);

  static void _fire(String data) => _controller.add(_output);//method is declared with an underscore prefix

  static String get _output => _result == null ? _equation : _result;   //returns the _result if not null, else returns _equation

  static String get _equation => _valA   //returns an equation if _operator is ready, else returns _valA
      + (_operator != null ? ' ' + _operator.value : '')
      + (_valB != '0' ? ' ' + _valB : '');

  static dispose() => _controller.close();

  static process(dynamic event) {  //chooses the next action to take based on KeySymbol type

    CalculatorKey key = (event as KeyEvent).key;
    switch(key.symbol.type) {

      case KeyType.FUNCTION:
        return handleFunction(key);   //prepares to execute some function on the current state

      case KeyType.OPERATOR:
        return handleOperator(key);    //assigns the selected math operator to _operator

      case KeyType.INTEGER:
        return handleInteger(key);    //adds the key’s number value to the appropriate operand
    }
  }

  static void handleFunction(CalculatorKey key) {

    if (_valA == '0') { return; }//heck if the left operand is ‘0’ and discard the event if so
    if (_result != null) { _condense(); }


    //select the desired function based on the KeySymbol of the incoming KeyEvent, and the KeySymbol is forwarded to the appropriate function followed by a refresh
    Map<KeySymbol, dynamic> table = {
      Keys.clear: () => _clear(),
      Keys.sign: () => _sign(),
      Keys.percent: () => _percent(),
      Keys.decimal: () => _decimal(),
    };

    table[key.symbol]();
    refresh();
  }

  static void handleOperator(CalculatorKey key) {

    if (_valA == '0') { return; }//discards events when the left operand is ‘0’

    //store the result of a previous calculation in the left operand
    if (key.symbol == Keys.equals) { return _calculate(); }
    if (_result != null) { _condense(); }

    _operator = key.symbol;
    refresh();
  }

  static void handleInteger(CalculatorKey key) {

    String val = key.symbol.value;
    //receives numerical input and appends it to either the left-side operand value if no _operator is present, or the right-side operand if _operator has a value.
    if (_operator == null) { _valA = (_valA == '0') ? val : _valA + val; }
    else { _valB = (_valB == '0') ? val : _valB + val; }
    refresh();
  }

  static void _clear() {//resets the calculator

    _valA = _valB = '0';
    _operator = _result = null;
  }

  static void _sign() {//sign of the operand that is currently receiving input

    if (_valB != '0') { _valB = (_valB.contains('-') ? _valB.substring(1) : '-' + _valB); }
    else if (_valA != '0') { _valA = (_valA.contains('-') ? _valA.substring(1) : '-' + _valA); }
  }

  static String calcPercent(String x) => (double.parse(x) / 100).toString();//divides the value of the current operand by 100

  static void _percent() {

    if (_valB != '0' && !_valB.contains('.')) { _valB = calcPercent(_valB); }
    else if (_valA != '0' && !_valA.contains('.')) { _valA = calcPercent(_valA); }
  }

  static void _decimal() {//appends a decimal point to the end of the current operand

    if (_valB != '0' && !_valB.contains('.')) { _valB = _valB + '.'; }
    else if (_valA != '0' && !_valA.contains('.')) { _valA = _valA + '.'; }
  }

  static void _calculate() {//perform the actual calculation and store the result in _result

    if (_operator == null || _valB == '0') { return; }

    Map<KeySymbol, dynamic> table = {
      Keys.divide: (a, b) => (a / b),
      Keys.multiply: (a, b) => (a * b),
      Keys.subtract: (a, b) => (a - b),
      Keys.add: (a, b) => (a + b)
    };

    double result = table[_operator](double.parse(_valA), double.parse(_valB));
    String str = result.toString();

    while ((str.contains('.') && str.endsWith('0')) || str.endsWith('.')) {
      str = str.substring(0, str.length - 1);
    }

    _result = str;
    refresh();
  }

  static void _condense() {//store _result in the left operand and prepare for more input

    _valA = _result;
    _valB = '0';
    _result = _operator = null;
  }
}