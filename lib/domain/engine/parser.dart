import 'package:decimal/decimal.dart';
import 'engine_tokens.dart';
import 'ast.dart';

class Parser {
  final List<Token> _tokens;
  int _pos = 0;

  Parser(this._tokens);

  Token? _current() => _pos < _tokens.length ? _tokens[_pos] : null;

  void _consume() => _pos++;

  AstNode parse() {
    if (_tokens.isEmpty) throw FormatException("Empty expression");
    final node = _parseExpression();
    if (_current() != null) {
      throw FormatException("Unexpected token: ${_current()!.value}");
    }
    return node;
  }

  // Expression -> Term ( ('+' | '-') Term )*
  AstNode _parseExpression() {
    AstNode node = _parseTerm();

    while (true) {
      final token = _current();
      if (token == null) break;

      if (token.type == TokenType.plus || token.type == TokenType.minus) {
        _consume();
        final right = _parseTerm();
        node = BinaryOpNode(op: token.value, left: node, right: right);
      } else {
        break;
      }
    }
    return node;
  }

  // Term -> Power ( ('*' | '/') Power )*
  AstNode _parseTerm() {
    AstNode node = _parsePower();

    while (true) {
      final token = _current();
      if (token == null) break;

      if (token.type == TokenType.multiply || token.type == TokenType.divide || token.type == TokenType.modulo) {
        _consume();
        final right = _parsePower();
        node = BinaryOpNode(op: token.value, left: node, right: right);
      } else {
        break;
      }
    }
    return node;
  }

  // Power -> Factor ( '^' Power )*  (Right-associative)
  AstNode _parsePower() {
    AstNode node = _parseFactor();

    final token = _current();
    if (token != null && token.type == TokenType.power) {
      _consume();
      final right = _parsePower();
      node = BinaryOpNode(op: '^', left: node, right: right);
    }
    return node;
  }

  // Factor -> Base ( PERCENT | FACTORIAL )*
  AstNode _parseFactor() {
    AstNode node = _parseBase();

    while (true) {
      final token = _current();
      if (token == null) break;

      if (token.type == TokenType.percent) {
        _consume();
        node = PercentageNode(node);
      } else if (token.type == TokenType.factorial) {
        _consume();
        node = FactorialNode(node);
      } else {
        break;
      }
    }
    return node;
  }

  // Base -> '+' Base | '-' Base | function Base | NUMBER | PI | E | '(' Expression ')'
  AstNode _parseBase() {
    final token = _current();
    if (token == null) throw FormatException("Unexpected end of expression");

    if (token.type == TokenType.plus || token.type == TokenType.minus) {
      _consume();
      return UnaryOpNode(op: token.value, operand: _parseBase());
    }

    if (token.type == TokenType.function) {
      _consume();
      // Functions like sin(x) usually require parentheses, but let's allow sin 45 as well
      return FunctionNode(func: token.value, operand: _parseBase());
    }

    if (token.type == TokenType.number) {
      _consume();
      try {
        return NumberNode(Decimal.parse(token.value));
      } catch (e) {
        throw FormatException("Invalid number format: ${token.value}");
      }
    }

    if (token.type == TokenType.pi) {
      _consume();
      return PiNode();
    }

    if (token.type == TokenType.e) {
      _consume();
      return ENode();
    }

    if (token.type == TokenType.lParen) {
      _consume();
      final node = _parseExpression();
      final nextToken = _current();
      if (nextToken == null || nextToken.type != TokenType.rParen) {
        throw FormatException("Missing closing parenthesis");
      }
      _consume(); // Consume ')'
      return node;
    }

    throw FormatException("Unexpected token in base: ${token.value}");
  }
}
