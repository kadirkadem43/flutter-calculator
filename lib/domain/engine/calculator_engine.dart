import 'tokenizer.dart';
import 'parser.dart';
import 'evaluator.dart';
import 'result_formatter.dart';

/// The Facade for the Calculator Engine. 
/// UI components should only interact with this class.
class CalculatorEngine {
  final Tokenizer _tokenizer = Tokenizer();

  /// Evaluates an internal mathematical expression.
  /// Throws [ArgumentError] with localization keys (e.g., 'errorDivideByZero') on failure.
  String evaluate(String expression, {AngleMode angleMode = AngleMode.deg}) {
    if (expression.trim().isEmpty) return '';

    try {
      final tokens = _tokenizer.tokenize(expression);
      final parser = Parser(tokens);
      final ast = parser.parse();
      
      final evaluator = Evaluator(angleMode: angleMode);
      final result = evaluator.evaluate(ast);
      
      return ResultFormatter.normalizeInternalResult(result);
    } on ArgumentError catch (e) {
      // E.g. 'errorDivideByZero'
      throw ArgumentError(e.message);
    } catch (e) {
      throw ArgumentError('errorInvalidFormat');
    }
  }
}
