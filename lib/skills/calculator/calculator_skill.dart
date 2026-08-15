import '../core/ether_skill.dart';

class CalculatorSkill implements EtherSkill {
  @override
  String get id => 'calculator';

  @override
  String get name => 'Calculator';

  @override
  bool canHandle(String input) {
    final text = input.toLowerCase().trim();

    if (RegExp(r'[\d\)]\s*[+\-*/]\s*[\d\(]').hasMatch(text)) {
      return true;
    }

    return text.startsWith('calculate ') ||
        text.startsWith('compute ') ||
        text.contains(' plus ') ||
        text.contains(' minus ') ||
        text.contains(' times ') ||
        text.contains(' multiplied by ') ||
        text.contains(' divided by ');
  }

  @override
  Future<String> execute(String input) async {
    final original = input.trim();

    var text = original.toLowerCase().trim();

    text = text.replaceAll('?', '');

    text = text.replaceFirst(
      RegExp(r"^(what is|what's|calculate|compute)\s+"),
      '',
    );

    text = text
        .replaceAll('multiplied by', '*')
        .replaceAll('divided by', '/')
        .replaceAll('plus', '+')
        .replaceAll('minus', '-')
        .replaceAll('times', '*');

    text = text.replaceAll(' ', '');

    try {
      final result = _evaluate(text);

      final formatted = result % 1 == 0
          ? result.toInt().toString()
          : result.toString();

      return '$original = $formatted';
    } catch (_) {
      return 'I could not calculate "$original".';
    }
  }

  double _evaluate(String expression) {
    final parser = _ExpressionParser(expression);
    return parser.parse();
  }
}

class _ExpressionParser {
  final String expression;
  int _position = 0;

  _ExpressionParser(this.expression);

  double parse() {
    final result = _parseExpression();

    if (_position != expression.length) {
      throw FormatException('Unexpected character');
    }

    return result;
  }

  double _parseExpression() {
    var result = _parseTerm();

    while (_position < expression.length) {
      final operator = expression[_position];

      if (operator == '+') {
        _position++;
        result += _parseTerm();
      } else if (operator == '-') {
        _position++;
        result -= _parseTerm();
      } else {
        break;
      }
    }

    return result;
  }

  double _parseTerm() {
    var result = _parseFactor();

    while (_position < expression.length) {
      final operator = expression[_position];

      if (operator == '*') {
        _position++;
        result *= _parseFactor();
      } else if (operator == '/') {
        _position++;

        final divisor = _parseFactor();

        if (divisor == 0) {
          throw FormatException('Cannot divide by zero');
        }

        result /= divisor;
      } else {
        break;
      }
    }

    return result;
  }

  double _parseFactor() {
    if (_position >= expression.length) {
      throw FormatException('Expected number');
    }

    if (expression[_position] == '(') {
      _position++;

      final result = _parseExpression();

      if (_position >= expression.length || expression[_position] != ')') {
        throw FormatException('Missing closing parenthesis');
      }

      _position++;

      return result;
    }

    final start = _position;

    while (_position < expression.length &&
        RegExp(r'[0-9.]').hasMatch(expression[_position])) {
      _position++;
    }

    if (start == _position) {
      throw FormatException('Expected number');
    }

    return double.parse(expression.substring(start, _position));
  }
}
