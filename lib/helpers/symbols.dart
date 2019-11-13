import 'package:awok_calculator/helpers/calculator_buttons.dart';

enum KeyType { FUNCTION, OPERATOR, INTEGER }

class KeySymbol {

  const KeySymbol(this.value);
  final String value;

  static List<KeySymbol> _functions = [ Keys.clear, Keys.sign, Keys.percent, Keys.decimal ];//provide symbols from calculator buttons class
  static List<KeySymbol> _operators = [ Keys.divide, Keys.multiply, Keys.subtract, Keys.add, Keys.equals ];//provide symbols from calculator buttons class

  @override
  String toString() => value;

  bool get isOperator => _operators.contains(this);
  bool get isFunction => _functions.contains(this);
  bool get isInteger => !isOperator && !isFunction;

  KeyType get type => isFunction ? KeyType.FUNCTION : (isOperator ? KeyType.OPERATOR : KeyType.INTEGER);//checks wheather key’s type is a function, operator, or integer
}