import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/presentation/calculator/providers/calculator_notifier.dart';
import 'calculator_button.dart';

class CalculatorKeyboard extends ConsumerWidget {
  const CalculatorKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(calculatorProvider.notifier);

    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              CalculatorButton(
                  text: 'AC',
                  type: ButtonType.action,
                  onPressed: notifier.onClear),
              CalculatorButton(
                  text: '±',
                  type: ButtonType.action,
                  onPressed: notifier.onToggleSign),
              CalculatorButton(
                  text: '%',
                  type: ButtonType.action,
                  onPressed: notifier.onPercentage),
              CalculatorButton(
                  text: '÷',
                  type: ButtonType.operator,
                  onPressed: () => notifier.onOperatorPressed('/')),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              CalculatorButton(
                  text: '7', onPressed: () => notifier.onNumberPressed('7')),
              CalculatorButton(
                  text: '8', onPressed: () => notifier.onNumberPressed('8')),
              CalculatorButton(
                  text: '9', onPressed: () => notifier.onNumberPressed('9')),
              CalculatorButton(
                  text: '×',
                  type: ButtonType.operator,
                  onPressed: () => notifier.onOperatorPressed('*')),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              CalculatorButton(
                  text: '4', onPressed: () => notifier.onNumberPressed('4')),
              CalculatorButton(
                  text: '5', onPressed: () => notifier.onNumberPressed('5')),
              CalculatorButton(
                  text: '6', onPressed: () => notifier.onNumberPressed('6')),
              CalculatorButton(
                  text: '−',
                  type: ButtonType.operator,
                  onPressed: () => notifier.onOperatorPressed('-')),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              CalculatorButton(
                  text: '1', onPressed: () => notifier.onNumberPressed('1')),
              CalculatorButton(
                  text: '2', onPressed: () => notifier.onNumberPressed('2')),
              CalculatorButton(
                  text: '3', onPressed: () => notifier.onNumberPressed('3')),
              CalculatorButton(
                  text: '+',
                  type: ButtonType.operator,
                  onPressed: () => notifier.onOperatorPressed('+')),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              CalculatorButton(
                  text: '0',
                  flex: 2,
                  onPressed: () => notifier.onNumberPressed('0')),
              CalculatorButton(
                  text: ',',
                  onPressed: notifier
                      .onDecimalPoint), // Will be handled accurately internally
              CalculatorButton(
                  text: '=',
                  type: ButtonType.operator,
                  onPressed: notifier.onCalculate),
            ],
          )),
        ],
      ),
    );
  }
}
