import 'dart:io';

void main() {
  print("=== Dart CMD Calculator ===");
  print("Type expressions like: 2+2");
  print("Type 'exit' to quit.\n");

  while (true) {
    stdout.write("Enter calculation: ");
    String input = stdin.readLineSync()!.replaceAll(' ', '');

    if (input.toLowerCase() == 'exit') {
      print("Calculator closed.");
      break;
    }

    RegExp exp = RegExp(r'^(-?\d+\.?\d*)([\+\-\*/])(-?\d+\.?\d*)$');
    Match? match = exp.firstMatch(input);

    if (match == null) {
      print("Invalid format!");
      continue;
    }

    double num1 = double.parse(match.group(1)!);
    String op = match.group(2)!;
    double num2 = double.parse(match.group(3)!);

    double result;

    switch (op) {
      case '+':
        result = num1 + num2;
        break;

      case '-':
        result = num1 - num2;
        break;

      case '*':
        result = num1 * num2;
        break;

      case '/':
        if (num2 == 0) {
          print("Cannot divide by zero!");
          continue;
        }
        result = num1 / num2;
        break;

      default:
        print("Invalid operator!");
        continue;
    }

    print("Result: $result\n");
  }
}