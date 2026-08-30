import 'engine_tokens.dart';

class Tokenizer {
  /// Converts an input string into a list of Tokens.
  /// Handles canonical expression format (e.g., uses '.' for decimals).
  List<Token> tokenize(String input) {
    final List<Token> tokens = [];
    int i = 0;

    // Remove all whitespace
    final text = input.replaceAll(RegExp(r'\s+'), '');

    while (i < text.length) {
      final char = text[i];

      if (_isDigit(char) || char == '.') {
        String number = char;
        i++;
        while (i < text.length && (_isDigit(text[i]) || text[i] == '.' || text[i] == 'e' || text[i] == 'E' || (text[i-1].toLowerCase() == 'e' && (text[i] == '+' || text[i] == '-')))) {
          number += text[i];
          i++;
        }
        tokens.add(Token(type: TokenType.number, value: number));
        continue;
      }

      if (_isLetter(char)) {
        String func = char;
        i++;
        while (i < text.length && _isLetter(text[i])) {
          func += text[i];
          i++;
        }
        
        final lowerFunc = func.toLowerCase();
        if (lowerFunc == 'pi' || lowerFunc == 'π') {
          tokens.add(const Token(type: TokenType.pi, value: 'pi'));
        } else if (lowerFunc == 'e') {
          tokens.add(const Token(type: TokenType.e, value: 'e'));
        } else if (lowerFunc == 'mod') {
          tokens.add(const Token(type: TokenType.modulo, value: 'mod'));
        } else {
          tokens.add(Token(type: TokenType.function, value: lowerFunc));
        }
        continue;
      }

      switch (char) {
        case '+':
          tokens.add(const Token(type: TokenType.plus, value: '+'));
          break;
        case '-':
        case '−':
          tokens.add(const Token(type: TokenType.minus, value: '-'));
          break;
        case '*':
        case '×':
          tokens.add(const Token(type: TokenType.multiply, value: '*'));
          break;
        case '/':
        case '÷':
          tokens.add(const Token(type: TokenType.divide, value: '/'));
          break;
        case '%':
          tokens.add(const Token(type: TokenType.percent, value: '%'));
          break;
        case '^':
          tokens.add(const Token(type: TokenType.power, value: '^'));
          break;
        case '!':
          tokens.add(const Token(type: TokenType.factorial, value: '!'));
          break;
        case '(':
          tokens.add(const Token(type: TokenType.lParen, value: '('));
          break;
        case ')':
          tokens.add(const Token(type: TokenType.rParen, value: ')'));
          break;
        case 'π':
          tokens.add(const Token(type: TokenType.pi, value: 'pi'));
          break;
        default:
          throw FormatException("Unknown character: $char");
      }
      i++;
    }

    return _insertImplicitMultiplication(tokens);
  }

  bool _isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);
  bool _isLetter(String char) => RegExp(r'[a-zA-Z]').hasMatch(char);

  List<Token> _insertImplicitMultiplication(List<Token> input) {
    final List<Token> tokens = [];
    for (int i = 0; i < input.length; i++) {
      tokens.add(input[i]);
      if (i < input.length - 1) {
        final current = input[i];
        final next = input[i + 1];

        bool implicit = false;
        if (current.type == TokenType.number || current.type == TokenType.rParen || current.type == TokenType.pi || current.type == TokenType.e || current.type == TokenType.percent || current.type == TokenType.factorial) {
          if (next.type == TokenType.lParen || next.type == TokenType.function || next.type == TokenType.pi || next.type == TokenType.e) {
            implicit = true;
          }
        }
        
        if (implicit) {
          tokens.add(const Token(type: TokenType.multiply, value: '*'));
        }
      }
    }
    return tokens;
  }
}
