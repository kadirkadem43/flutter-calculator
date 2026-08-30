import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/domain/engine/calculator_engine.dart';
import 'package:calculator_app/domain/engine/evaluator.dart';

void main() {
  late CalculatorEngine engine;

  setUp(() {
    engine = CalculatorEngine();
  });

  group('Calculator Engine - Basic Operations', () {
    test('Addition', () => expect(engine.evaluate('2+2'), '4'));
    test('Subtraction', () => expect(engine.evaluate('10-3'), '7'));
    test('Multiplication', () => expect(engine.evaluate('5*5'), '25'));
    test('Division', () => expect(engine.evaluate('20/4'), '5'));
    test('Precedence', () => expect(engine.evaluate('2+3*4'), '14'));
    test('Parentheses', () => expect(engine.evaluate('(2+3)*4'), '20'));
    test('Negative numbers', () => expect(engine.evaluate('-5+3'), '-2'));
    test('Floating point precision (0.1 + 0.2)', () => expect(engine.evaluate('0.1+0.2'), '0.3'));
  });

  group('Calculator Engine - Advanced Operations', () {
    test('Square Root', () => expect(engine.evaluate('sqrt(16)'), '4'));
    test('Power 2^2', () => expect(engine.evaluate('2^2'), '4'));
    test('Power 2^3', () => expect(engine.evaluate('2^3'), '8'));
    test('Logarithm', () => expect(engine.evaluate('log(100)'), '2'));
    
    test('Trigonometry DEG', () {
      expect(engine.evaluate('sin(90)', angleMode: AngleMode.deg), '1');
      expect(engine.evaluate('cos(0)', angleMode: AngleMode.deg), '1');
    });
  });

  group('Calculator Engine - Percentages', () {
    test('100 + 10% = 110', () => expect(engine.evaluate('100+10%'), '110'));
    test('100 - 10% = 90', () => expect(engine.evaluate('100-10%'), '90'));
    test('100 * 10% = 10', () => expect(engine.evaluate('100*10%'), '10'));
    test('100 / 10% = 1000', () => expect(engine.evaluate('100/10%'), '1000'));
    test('10% = 0.1', () => expect(engine.evaluate('10%'), '0.1'));
    test('50 + 25% = 62.5', () => expect(engine.evaluate('50+25%'), '62.5'));
  });

  group('Calculator Engine - Errors', () {
    test('Divide by zero throws argument error', () {
      expect(() => engine.evaluate('10/0'), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'errorDivideByZero')));
    });
    test('Invalid format', () {
      expect(() => engine.evaluate('2+*2'), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'errorInvalidFormat')));
    });
  });
}
