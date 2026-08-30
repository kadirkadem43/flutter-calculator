import 'dart:math' as math;
import 'package:decimal/decimal.dart';
// removed rational import
import 'ast.dart';

enum AngleMode { deg, rad }

class Evaluator {
  final AngleMode angleMode;

  Evaluator({this.angleMode = AngleMode.deg});

  Decimal evaluate(AstNode node) {
    if (node is NumberNode) {
      return node.value;
    }

    if (node is PiNode) {
      return Decimal.parse(math.pi.toString());
    }

    if (node is ENode) {
      return Decimal.parse(math.e.toString());
    }

    if (node is UnaryOpNode) {
      final operandVal = evaluate(node.operand);
      if (node.op == '-') {
        return -operandVal;
      }
      return operandVal;
    }

    if (node is PercentageNode) {
      // Standalone percentage, e.g. "10%" -> 0.1
      final val = evaluate(node.operand);
      return _divide(val, Decimal.fromInt(100));
    }

    if (node is FactorialNode) {
      final val = evaluate(node.operand);
      return _factorial(val);
    }

    if (node is FunctionNode) {
      return _evaluateFunction(node);
    }

    if (node is BinaryOpNode) {
      return _evaluateBinary(node);
    }

    throw FormatException("Unknown AST Node");
  }

  Decimal _evaluateBinary(BinaryOpNode node) {
    final leftVal = evaluate(node.left);

    // Percentage Context Rules:
    // 100 + 10% = 110 (100 + 100*0.1)
    // 100 * 10% = 10  (100 * 0.1)
    if (node.right is PercentageNode) {
      final pctNode = node.right as PercentageNode;
      final pctVal = evaluate(pctNode.operand);
      final pctFraction = _divide(pctVal, Decimal.fromInt(100));

      if (node.op == '+' || node.op == '-') {
        final amount = leftVal * pctFraction;
        return node.op == '+' ? leftVal + amount : leftVal - amount;
      } else if (node.op == '*' || node.op == '/') {
        return node.op == '*' ? leftVal * pctFraction : _divide(leftVal, pctFraction);
      }
    }

    // Normal Binary Op
    final rightVal = evaluate(node.right);

    switch (node.op) {
      case '+':
        return leftVal + rightVal;
      case '-':
        return leftVal - rightVal;
      case '*':
        return leftVal * rightVal;
      case '/':
        return _divide(leftVal, rightVal);
      case 'mod':
        return leftVal % rightVal;
      case '^':
        final doubleResult = math.pow(leftVal.toDouble(), rightVal.toDouble()).toDouble();
        _checkDoubleError(doubleResult);
        return Decimal.parse(doubleResult.toString());
      default:
        throw FormatException("Unknown binary operator: ${node.op}");
    }
  }

  Decimal _divide(Decimal a, Decimal b) {
    if (b == Decimal.zero) throw ArgumentError('errorDivideByZero');
    // Using rational to handle infinite precision divisions like 1/3 safely up to 15 decimal places.
    final rationalA = a.toRational();
    final rationalB = b.toRational();
    final result = rationalA / rationalB;
    return result.toDecimal(scaleOnInfinitePrecision: 15);
  }

  Decimal _factorial(Decimal n) {
    if (n < Decimal.zero) throw ArgumentError('errorInvalidFormat');
    if (n.toDouble() % 1 != 0) throw ArgumentError('errorInvalidFormat'); // Only integers
    
    final int num = n.toBigInt().toInt();
    if (num > 170) throw ArgumentError('errorOverflow'); // 170! is the limit for 64-bit IEEE 754 double

    Decimal result = Decimal.one;
    for (int i = 2; i <= num; i++) {
      result = result * Decimal.fromInt(i);
    }
    return result;
  }

  Decimal _evaluateFunction(FunctionNode node) {
    final operandVal = evaluate(node.operand);
    final double val = operandVal.toDouble();
    double result;

    switch (node.func) {
      case 'sin':
        result = math.sin(_toRadians(val));
        break;
      case 'cos':
        result = math.cos(_toRadians(val));
        break;
      case 'tan':
        if (_isMultipleOf90AndNot180(val)) throw ArgumentError('errorInvalidFormat'); // tan(90) undefined
        result = math.tan(_toRadians(val));
        break;
      case 'asin':
        if (val < -1 || val > 1) throw ArgumentError('errorInvalidFormat');
        result = _fromRadians(math.asin(val));
        break;
      case 'acos':
        if (val < -1 || val > 1) throw ArgumentError('errorInvalidFormat');
        result = _fromRadians(math.acos(val));
        break;
      case 'atan':
        result = _fromRadians(math.atan(val));
        break;
      case 'sinh':
        result = (math.exp(val) - math.exp(-val)) / 2.0;
        break;
      case 'cosh':
        result = (math.exp(val) + math.exp(-val)) / 2.0;
        break;
      case 'tanh':
        result = (math.exp(val) - math.exp(-val)) / (math.exp(val) + math.exp(-val));
        break;
      case 'log':
        if (val <= 0) throw ArgumentError('errorInvalidFormat');
        result = math.log(val) / math.ln10; // Log base 10
        break;
      case 'ln':
        if (val <= 0) throw ArgumentError('errorInvalidFormat');
        result = math.log(val);
        break;
      case 'sqrt':
      case '√':
        if (val < 0) throw ArgumentError('errorInvalidFormat');
        final doubleResult = math.sqrt(val);
        result = doubleResult;
        break;
      case 'exp':
        result = math.exp(val);
        break;
      default:
        throw FormatException("Unknown function: ${node.func}");
    }

    _checkDoubleError(result);
    
    // Fix very small floating point errors from trig functions (e.g. sin(180) = 1.22e-16)
    if (result.abs() < 1e-14) result = 0.0;
    
    return Decimal.parse(result.toString());
  }

  double _toRadians(double value) {
    if (angleMode == AngleMode.rad) return value;
    return value * (math.pi / 180.0);
  }

  double _fromRadians(double value) {
    if (angleMode == AngleMode.rad) return value;
    return value * (180.0 / math.pi);
  }

  bool _isMultipleOf90AndNot180(double value) {
    if (angleMode == AngleMode.rad) {
      double degrees = value * (180.0 / math.pi);
      return (degrees % 180 != 0) && (degrees % 90 == 0);
    }
    return (value % 180 != 0) && (value % 90 == 0);
  }

  void _checkDoubleError(double value) {
    if (value.isNaN) throw ArgumentError('errorNaN');
    if (value.isInfinite) throw ArgumentError('errorOverflow');
  }
}
