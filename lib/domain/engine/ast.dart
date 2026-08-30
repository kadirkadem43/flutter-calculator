import 'package:decimal/decimal.dart';

abstract class AstNode {}

class NumberNode extends AstNode {
  final Decimal value;
  NumberNode(this.value);
}

class PiNode extends AstNode {}
class ENode extends AstNode {}

class BinaryOpNode extends AstNode {
  final String op; // '+', '-', '*', '/', '^'
  final AstNode left;
  final AstNode right;

  BinaryOpNode({required this.op, required this.left, required this.right});
}

class UnaryOpNode extends AstNode {
  final String op; // '+' or '-'
  final AstNode operand;

  UnaryOpNode({required this.op, required this.operand});
}

class FunctionNode extends AstNode {
  final String func; // 'sin', 'cos', 'ln', etc.
  final AstNode operand;

  FunctionNode({required this.func, required this.operand});
}

class PercentageNode extends AstNode {
  final AstNode operand;
  PercentageNode(this.operand);
}

class FactorialNode extends AstNode {
  final AstNode operand;
  FactorialNode(this.operand);
}
