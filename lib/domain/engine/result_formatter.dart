import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

class ResultFormatter {
  /// Formats the raw engine result (e.g., '1234.56') to a locale-aware display string (e.g., '1.234,56').
  static String format(String rawResult, {String locale = 'en', int maxDecimalPlaces = 10}) {
    if (rawResult.isEmpty) return '';
    
    try {
      if (rawResult == 'Error' || rawResult.startsWith('error')) {
        return rawResult; // Let UI handle translation
      }

      final decimal = Decimal.parse(rawResult);
      final doubleValue = decimal.toDouble();

      // If the number is too big or too small, use scientific notation
      if (doubleValue.abs() >= 1e11 || (doubleValue.abs() > 0 && doubleValue.abs() < 1e-7)) {
        final scientificFormat = NumberFormat.scientificPattern(locale);
        return scientificFormat.format(doubleValue);
      }

      // Normal formatting
      final numberFormat = NumberFormat.decimalPattern(locale);
      numberFormat.maximumFractionDigits = maxDecimalPlaces;
      numberFormat.minimumFractionDigits = 0; // Don't pad with zeros unless necessary

      return numberFormat.format(doubleValue);
    } catch (e) {
      return rawResult; // Fallback
    }
  }

  /// Removes trailing `.0` for integers.
  static String normalizeInternalResult(Decimal result) {
    String str = result.toString();
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0*$'), ''); // Remove trailing zeros
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
    }
    return str;
  }
}
