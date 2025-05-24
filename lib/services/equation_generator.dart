import 'dart:math';

import 'package:devils_pyramid/models/number_with_symbol.dart';

class EquationGenerator {
  final int initialNumber;
  final int numOptions;
  final int numSolutions;
  final int maxNumber;
  final List<String> symbols = ['+', '-', 'x', '/'];
  final Random rand = Random();

  EquationGenerator(
    this.initialNumber, {
    this.numOptions = 10,
    this.numSolutions = 1,
    this.maxNumber = 20,
  });

  List<NumberWithSymbol> generate() {
    // Ensure at least one of each symbol
    List<NumberWithSymbol> options = [];
    for (var symbol in symbols) {
      options.add(NumberWithSymbol(_randomNumber(), symbol));
    }
    // Fill the rest randomly
    while (options.length < numOptions) {
      options.add(NumberWithSymbol(_randomNumber(), symbols[rand.nextInt(4)]));
    }
    // Shuffle to randomize order
    options.shuffle();

    // Insert guaranteed solutions
    for (int i = 0; i < numSolutions; i++) {
      var solution = _generateSolution();
      for (var n in solution) {
        // Replace a random option to ensure the solution is present
        options[rand.nextInt(options.length)] = n;
      }
    }
    return options;
  }

  List<NumberWithSymbol> _generateSolution() {
    while (true) {
      var usedSymbols = <String>{};
      List<NumberWithSymbol> solution = [];
      while (solution.length < 3) {
        String symbol = symbols[rand.nextInt(4)];
        if (solution.length == 2 && usedSymbols.length < 3) {
          symbol = symbols.firstWhere((s) => !usedSymbols.contains(s));
        }
        int number = _randomNumber();
        solution.add(NumberWithSymbol(number, symbol));
        usedSymbols.add(symbol);
      }
      int n2 = solution[1].number;
      int n3 = solution[2].number;
      int n1 = _reverseCalculate(
        initialNumber,
        solution[1].symbol,
        n2,
        solution[2].symbol,
        n3,
      );
      // Ensure n1 is within bounds
      if (n1 >= 1 && n1 <= maxNumber) {
        solution[0] = NumberWithSymbol(n1, solution[0].symbol);
        return solution;
      }
      // Otherwise, retry
    }
  }

  int _reverseCalculate(int result, String op2, int n2, String op3, int n3) {
    // We want: n1 op2 n2 op3 n3 = result
    // Since first symbol is ignored, it's just n1 op2 n2 op3 n3
    // We'll solve for n1
    double temp;
    switch (op3) {
      case '+':
        temp = (result - n3) as double;
        break;
      case '-':
        temp = (result + n3) as double;
        break;
      case 'x':
        temp = result / n3;
        break;
      case '/':
        temp = (result * n3) as double;
        break;
      default:
        temp = result.toDouble();
    }
    switch (op2) {
      case '+':
        temp -= n2;
        break;
      case '-':
        temp += n2;
        break;
      case 'x':
        temp /= n2;
        break;
      case '/':
        temp *= n2;
        break;
    }
    return temp.round();
  }

  bool isSolution(List<NumberWithSymbol> solution) {
    if (solution.length != 3) return false;
    // The first symbol is ignored
    int result = solution[0].number;
    for (int i = 1; i < 3; i++) {
      switch (solution[i].symbol) {
        case '+':
          result += solution[i].number;
          break;
        case '-':
          result -= solution[i].number;
          break;
        case 'x':
          result *= solution[i].number;
          break;
        case '/':
          if (solution[i].number == 0) return false; // avoid division by zero
          result ~/= solution[i].number; // integer division
          break;
        default:
          return false;
      }
    }
    return result == initialNumber;
  }

  int _randomNumber() => rand.nextInt(maxNumber) + 1;
}
