/// Represents different types of tokens in a mathematical expression.
enum TokenType {
  number,
  plus,
  minus,
  multiply,
  divide,
  modulo,
  percent,
  power,
  factorial,
  lParen,
  rParen,
  function, // e.g., sin, cos, tan, log, ln, sqrt
  pi,
  e,
}

/// A token extracted from the input string.
class Token {
  final TokenType type;
  final String value;

  const Token({required this.type, required this.value});

  @override
  String toString() => 'Token($type, "$value")';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Token && other.type == type && other.value == value;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}
