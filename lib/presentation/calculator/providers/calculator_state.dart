import 'package:calculator_app/domain/engine/evaluator.dart';
import 'package:flutter/foundation.dart';

@immutable
class CalculatorState {
  final String expression;
  final String currentInput;
  final String result;
  final bool hasError;
  final String errorType;
  final bool isNewCalculation;
  final bool isScientificMode;
  final AngleMode angleMode;
  final String memoryValue;

  const CalculatorState({
    this.expression = '',
    this.currentInput = '0',
    this.result = '',
    this.hasError = false,
    this.errorType = '',
    this.isNewCalculation = true,
    this.isScientificMode = false,
    this.angleMode = AngleMode.deg,
    this.memoryValue = '0',
  });

  CalculatorState copyWith({
    String? expression,
    String? currentInput,
    String? result,
    bool? hasError,
    String? errorType,
    bool? isNewCalculation,
    bool? isScientificMode,
    AngleMode? angleMode,
    String? memoryValue,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      currentInput: currentInput ?? this.currentInput,
      result: result ?? this.result,
      hasError: hasError ?? this.hasError,
      errorType: errorType ?? this.errorType,
      isNewCalculation: isNewCalculation ?? this.isNewCalculation,
      isScientificMode: isScientificMode ?? this.isScientificMode,
      angleMode: angleMode ?? this.angleMode,
      memoryValue: memoryValue ?? this.memoryValue,
    );
  }

  // To easily determine if we should format currentInput or result on the display
  String get displayValue => hasError ? errorType : (result.isNotEmpty && isNewCalculation ? result : currentInput);
}
