import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/domain/engine/calculator_engine.dart';
import 'package:calculator_app/domain/engine/evaluator.dart';
import 'package:calculator_app/domain/entities/history_item.dart';
import 'package:calculator_app/presentation/history/providers/history_notifier.dart';
import 'calculator_state.dart';

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier(CalculatorEngine(), ref);
});

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  final CalculatorEngine _engine;
  final Ref _ref;

  CalculatorNotifier(this._engine, this._ref) : super(const CalculatorState());

  void onNumberPressed(String number) {
    if (state.hasError) _clearAll();
    
    if (state.isNewCalculation) {
      state = state.copyWith(
        currentInput: number,
        expression: '',
        result: '',
        isNewCalculation: false,
      );
    } else {
      if (state.currentInput == '0') {
        state = state.copyWith(currentInput: number);
      } else {
        state = state.copyWith(currentInput: state.currentInput + number);
      }
    }
  }

  void onDecimalPoint() {
    if (state.hasError) _clearAll();

    if (state.isNewCalculation) {
      state = state.copyWith(
        currentInput: '0.',
        expression: '',
        result: '',
        isNewCalculation: false,
      );
    } else if (!state.currentInput.contains('.')) {
      state = state.copyWith(currentInput: state.currentInput + '.');
    }
  }

  void onOperatorPressed(String operator) {
    if (state.hasError) return;

    String currentExp = state.expression;
    String input = state.currentInput;

    if (state.isNewCalculation && state.result.isNotEmpty) {
      input = state.result;
    }

    // If there is an input, append to expression
    if (input.isNotEmpty && input != '0' || (input == '0' && currentExp.isEmpty)) {
      currentExp += input + operator;
    } else if (currentExp.isNotEmpty) {
      // Change last operator
      final lastChar = currentExp.substring(currentExp.length - 1);
      if ('+-*/'.contains(lastChar)) {
        currentExp = currentExp.substring(0, currentExp.length - 1) + operator;
      }
    }

    state = state.copyWith(
      expression: currentExp,
      currentInput: '0',
      isNewCalculation: false,
    );
  }

  void onCalculate() {
    if (state.hasError || state.expression.isEmpty && state.currentInput == '0') return;

    String finalExpression = state.expression;
    if (state.currentInput != '0' || !state.isNewCalculation) {
      finalExpression += state.currentInput;
    }

    // Trim trailing operator if user pressed e.g. 5 + =
    if ('+-*/'.contains(finalExpression.substring(finalExpression.length - 1))) {
      finalExpression = finalExpression.substring(0, finalExpression.length - 1);
    }

    try {
      final rawResult = _engine.evaluate(finalExpression, angleMode: state.angleMode);
      
      // Update state first for instant UI response
      state = state.copyWith(
        expression: finalExpression + '=',
        result: rawResult,
        currentInput: rawResult,
        isNewCalculation: true,
        hasError: false,
      );

      // Save to History (Using UUID or timestamp for ID)
      final historyItem = HistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        expression: finalExpression,
        result: rawResult,
        timestamp: DateTime.now(),
      );
      
      _ref.read(historyProvider.notifier).addHistory(historyItem);
      
    } on ArgumentError catch (e) {
      state = state.copyWith(
        hasError: true,
        errorType: e.message,
        isNewCalculation: true,
      );
    }
  }

  void onClear() {
    _clearAll();
  }

  void _clearAll() {
    state = const CalculatorState();
  }

  void onDelete() {
    if (state.hasError || state.isNewCalculation) {
      _clearAll();
      return;
    }

    if (state.currentInput.length > 1) {
      state = state.copyWith(
        currentInput: state.currentInput.substring(0, state.currentInput.length - 1),
      );
    } else {
      state = state.copyWith(currentInput: '0');
    }
  }

  void onPercentage() {
    if (state.hasError) return;
    
    // In our AST, % is a suffix operator. We can just append it to input and evaluate if needed,
    // or just append to expression for full AST handling.
    // For a standard calculator, pressing % immediately converts the current input.
    if (state.expression.isEmpty) {
      // 10% -> 0.1
      try {
        final res = _engine.evaluate(state.currentInput + '%', angleMode: state.angleMode);
        state = state.copyWith(currentInput: res);
      } catch (_) {}
    } else {
      // We append it to expression and let evaluator handle context when '=' is pressed, 
      // or evaluate immediately. Let's append to input to be safe for `50 + 25%`
      state = state.copyWith(currentInput: state.currentInput + '%');
    }
  }

  void onToggleSign() {
    if (state.hasError) return;
    if (state.currentInput == '0') return;

    if (state.currentInput.startsWith('-')) {
      state = state.copyWith(currentInput: state.currentInput.substring(1));
    } else {
      state = state.copyWith(currentInput: '-' + state.currentInput);
    }
  }

  void onFunctionPressed(String func) {
    if (state.hasError) _clearAll();

    String currentExp = state.expression;
    String input = state.currentInput;

    if (state.isNewCalculation && state.result.isNotEmpty) {
      input = state.result;
    }

    if (input != '0' && input.isNotEmpty) {
       currentExp += input;
    }
    
    currentExp += func;
    
    state = state.copyWith(
      expression: currentExp,
      currentInput: '0',
      isNewCalculation: false,
    );
  }

  void onConstantPressed(String constant) {
    if (state.hasError) _clearAll();
    
    state = state.copyWith(
      currentInput: constant,
      isNewCalculation: false,
    );
  }

  void onToggleAngleMode() {
    state = state.copyWith(
      angleMode: state.angleMode == AngleMode.deg ? AngleMode.rad : AngleMode.deg,
    );
  }

  void onToggleScientificMode() {
    state = state.copyWith(
      isScientificMode: !state.isScientificMode,
    );
  }

  void onMemoryClear() {
    state = state.copyWith(memoryValue: '0');
  }

  void onMemoryRecall() {
    if (state.hasError) _clearAll();
    
    state = state.copyWith(
      currentInput: state.memoryValue,
      isNewCalculation: false,
    );
  }

  void onMemoryStore() {
    if (state.hasError) return;
    
    String valToStore = state.currentInput;
    if (state.isNewCalculation && state.result.isNotEmpty) {
      valToStore = state.result;
    }
    
    // Evaluate if it's an expression like 10%
    try {
      final evaluated = _engine.evaluate(valToStore, angleMode: state.angleMode);
      state = state.copyWith(memoryValue: evaluated);
    } catch (_) {
      state = state.copyWith(memoryValue: valToStore);
    }
  }

  void onMemoryAdd() {
    _memoryArithmetic('+');
  }

  void onMemorySubtract() {
    _memoryArithmetic('-');
  }

  void _memoryArithmetic(String operator) {
    if (state.hasError) return;
    
    String valToAdd = state.currentInput;
    if (state.isNewCalculation && state.result.isNotEmpty) {
      valToAdd = state.result;
    }
    
    try {
      final exp = '${state.memoryValue}$operator$valToAdd';
      final evaluated = _engine.evaluate(exp, angleMode: state.angleMode);
      state = state.copyWith(memoryValue: evaluated);
    } catch (_) {
      // Ignore if input is not evaluable
    }
  }
}
