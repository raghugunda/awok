import 'package:awok_calculator/helpers/calculator_buttons.dart';
import 'package:awok_calculator/helpers/calculator_process.dart';
import 'package:awok_calculator/helpers/key_controller.dart';
import 'package:awok_calculator/helpers/result_display.dart';
import 'package:flutter/material.dart';
class Calculator extends StatefulWidget {
  Calculator({ Key key }) : super(key: key);
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output;

  @override
  void initState() {

    KeyController.listen((event) => Handle_event.process(event));// handles the messages
    Handle_event.listen((data) => setState(() { _output = data; }));//receiving back data to be displayed
    Handle_event.refresh();
    super.initState();
  }

  @override
  void dispose() {

    KeyController.dispose();
    Handle_event.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size screen = MediaQuery.of(context).size;

    double buttonSize = screen.width ;
    double displayHeight = 230;

    return Scaffold(
      backgroundColor: Color.fromARGB(190, 30, 62, 94),
      appBar: AppBar(
        centerTitle: true,
        title:  Text('Awok Calculator',style: TextStyle(color: Colors.white),),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
         Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Display(value: _output, height: displayHeight),//output box, displaying result
              Keypad_buttons()//input buttons
            ]
        ),
      ],
      ),
    );
  }
}
class Keypad_buttons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(
//buttons are defined in another class
        children: [
          Row(
              children: <Widget>[
                CalculatorKey(symbol: Keys.clear),
                CalculatorKey(symbol: Keys.sign),
                CalculatorKey(symbol: Keys.percent),
                CalculatorKey(symbol: Keys.divide),
              ]
          ),
          Row(
              children: <Widget>[
                CalculatorKey(symbol: Keys.seven),
                CalculatorKey(symbol: Keys.eight),
                CalculatorKey(symbol: Keys.nine),
                CalculatorKey(symbol: Keys.multiply),
              ]
          ),
          Row(
              children: <Widget>[
                CalculatorKey(symbol: Keys.four),
                CalculatorKey(symbol: Keys.five),
                CalculatorKey(symbol: Keys.six),
                CalculatorKey(symbol: Keys.subtract),
              ]
          ),
          Row(
              children: <Widget>[
                CalculatorKey(symbol: Keys.one),
                CalculatorKey(symbol: Keys.two),
                CalculatorKey(symbol: Keys.three),
                CalculatorKey(symbol: Keys.add),
              ]
          ),
          Row(
              children: <Widget>[
                CalculatorKey(symbol: Keys.zero),
                CalculatorKey(symbol: Keys.decimal),
                CalculatorKey(symbol: Keys.equals),
              ]
          )
        ]
    );
  }
}