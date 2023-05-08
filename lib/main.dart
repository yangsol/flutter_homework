import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MaterialApp(
    home: Calculator(),
  ));
}


class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String result = "";
  String equation = "";
  double evaluateExpression(String expression) {
    // 수식 문자열을 계산하여 결과 값을 반환합니다.
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }
///////////////////계산기 기능들//////////////////////
  void calculateResult() {
    try {
      // 수식을 계산하고 결과 값을 result 변수에 저장합니다.
      double res = evaluateExpression(equation);
      result = res.toString();
    } catch (e) {
      // 수식이 잘못된 경우 에러 메시지를 표시합니다.
      result = "Error";
    }
  }
  void clear() {
    setState(() {
      equation = "";
      result = "";
    });
  }



  Widget buildButton(String buttonText, double buttonWidth, Color buttonColor) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1 * buttonWidth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: buttonColor,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(16.0),
          primary: buttonColor,
        ),
        onPressed: () {
          setState(() {
            if (buttonText == "X") {
              equation += "*";
            } else if (buttonText == "÷") {
              equation += "/";
            } else if (buttonText == "=") {
              calculateResult();
            } else if (buttonText == "C") {
              clear();
            } else if (buttonText == "()") {
              if (equation.isEmpty ||
                  equation.endsWith("(") ||
                  equation.endsWith("+") ||
                  equation.endsWith("-") ||
                  equation.endsWith("X") ||
                  equation.endsWith("÷")) {
                equation += "(";
              } else {
                equation += ")";
              }
            } else if (buttonText == "%") {
              int lastIndex = equation.lastIndexOf(RegExp(r"[+\-X÷]"));
              double lastNumber = double.parse(equation.substring(lastIndex + 1));
              equation += (lastNumber / 100).toString();
            } else if (buttonText == "+/-") {
              int lastIndex = equation.lastIndexOf(RegExp(r"[+\-X÷()]"));
              String lastNumberStr = equation.substring(lastIndex + 1);
              if (lastNumberStr.startsWith("-")) {
                lastNumberStr = lastNumberStr.substring(1);
              } else {
                lastNumberStr = "-" + lastNumberStr;
              }
              equation = equation.substring(0, lastIndex + 1) + lastNumberStr;
            } else {
              equation += buttonText;
            }
          });
        }
        ,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Calculator"),
    ),
    body: Column(
    children: <Widget>[
    Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
    child: Text(
    equation,
    style: TextStyle(fontSize: 38.0),
    ),
    ),
    Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
    child: Text(
    result,
    style: TextStyle(fontSize: 48.0),
    ),
    ),
    Expanded(
    child: Divider(),
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Container(
    width: MediaQuery.of(context).size.width * .75,
    child: Table(
    children: [
    TableRow(
    children: [
    buildButton("C", 1, Colors.redAccent),
    buildButton("()", 1, Colors.blue),
    buildButton("%", 1, Colors.blue),
    buildButton("÷", 1, Colors.blue),
    ],
    ),
    TableRow(
    children: [
    buildButton("7", 1, Colors.black54),
    buildButton("8", 1, Colors.black54),
    buildButton("9", 1, Colors.black54),
    buildButton("X", 1, Colors.blue),
    ],
    ),
    TableRow(
    children: [
    buildButton("4", 1, Colors.black54),
    buildButton("5", 1, Colors.black54),
    buildButton("6", 1, Colors.black54),
    buildButton("-", 1, Colors.blue),
    ],
    ),
      TableRow(
        children: [
          buildButton("1", 1, Colors.black54),
          buildButton("2", 1, Colors.black54),
          buildButton("3", 1, Colors.black54),
          buildButton("+", 1, Colors.blue),
        ],
      ),
      TableRow(
        children: [
          buildButton("+/-", 1, Colors.black54),
          buildButton("0", 1, Colors.black54),
          buildButton(".", 1, Colors.black54),
          buildButton("=", 1, Colors.blue),
        ],
      ),
      ],
    ),
    ),
    ],
    ),
  ],
    ),
    );
  }
}

