import '../core/ether_skill.dart';

class CalculatorSkill implements EtherSkill {
  @override
  String get id => 'calculator';

  @override
  String get name => 'Calculator';

  @override
  String get description =>
      'Performs arithmetic calculations and evaluates mathematical expressions.';

  @override
  bool canHandle(String input) {
    final text = input.toLowerCase().trim();

    // Business calculations.
    if (_isBusinessCalculation(text)) {
      return true;
    }

    // Normal mathematical expressions.
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
    final lower = original.toLowerCase().trim();

    // Handle business calculations before the generic expression parser.
    final businessResult = _calculateBusinessResult(original, lower);
    if (businessResult != null) {
      return businessResult;
    }

    var text = lower;

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

  static bool _isBusinessCalculation(String text) {
    return text.contains('profit') ||
        text.contains('margin') ||
        (text.contains('cost') && text.contains('selling price')) ||
        (text.contains('selling price') && text.contains('cost price'));
  }

  static String? _calculateBusinessResult(String original, String text) {
    if (!_isBusinessCalculation(text)) {
      return null;
    }

    final cost = _extractNumberAfterAny(text, ['cost price', 'cost']);

    final sellingPrice = _extractNumberAfterAny(text, [
      'selling price',
      'sale price',
      'selling',
    ]);

    if (cost == null || sellingPrice == null) {
      return 'I could not calculate "$original".';
    }

    final profit = sellingPrice - cost;
    final margin = sellingPrice == 0 ? 0 : (profit / sellingPrice) * 100;

    final profitFormatted = profit % 1 == 0
        ? profit.toInt().toString()
        : profit.toString();

    final marginFormatted = margin.toStringAsFixed(2);

    return [
      original,
      'Cost: ${_formatNumber(cost)}',
      'Selling price: ${_formatNumber(sellingPrice)}',
      'Profit: $profitFormatted',
      'Margin: $marginFormatted%',
    ].join('\n');
  }

  static double? _extractNumberAfterAny(String text, List<String> labels) {
    for (final label in labels) {
      final escaped = RegExp.escape(label);

      final match = RegExp(
        '$escaped\\s*[:=]?\\s*(-?\\d+(?:\\.\\d+)?)',
      ).firstMatch(text);

      if (match != null) {
        return double.tryParse(match.group(1)!);
      }
    }

    return null;
  }

  static String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
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
        throw FormatException('Expected closing parenthesis');
      }

      _position++;

      return result;
    }

    var sign = 1.0;

    if (expression[_position] == '-') {
      sign = -1.0;
      _position++;
    }

    final start = _position;

    while (_position < expression.length &&
        (RegExp(r'\d').hasMatch(expression[_position]) ||
            expression[_position] == '.')) {
      _position++;
    }

    if (start == _position) {
      throw FormatException('Expected number');
    }

    final number = double.tryParse(expression.substring(start, _position));

    if (number == null) {
      throw FormatException('Invalid number');
    }

    return sign * number;
  }
}
