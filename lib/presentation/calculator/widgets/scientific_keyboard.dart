import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/presentation/calculator/providers/calculator_notifier.dart';
import 'package:calculator_app/domain/engine/evaluator.dart';
import 'package:calculator_app/core/theme/app_colors.dart';
import 'package:calculator_app/core/theme/app_typography.dart';
import 'package:calculator_app/core/theme/app_radius.dart';

class ScientificKeyboard extends ConsumerWidget {
  const ScientificKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(calculatorProvider.notifier);
    final state = ref.watch(calculatorProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionBg = isDark ? AppColors.darkButtonAction : AppColors.lightButtonAction;
    final actionFg = isDark ? AppColors.darkBackground : AppColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildSciButton('2nd', () {}, actionBg, actionFg), // Toggle 2nd functions if needed later
              _buildSciButton(state.angleMode == AngleMode.deg ? 'DEG' : 'RAD', notifier.onToggleAngleMode, actionBg, actionFg),
              _buildSciButton('sin', () => notifier.onFunctionPressed('sin('), actionBg, actionFg),
              _buildSciButton('cos', () => notifier.onFunctionPressed('cos('), actionBg, actionFg),
              _buildSciButton('tan', () => notifier.onFunctionPressed('tan('), actionBg, actionFg),
            ],
          ),
          Row(
            children: [
              _buildSciButton('xʸ', () => notifier.onFunctionPressed('^'), actionBg, actionFg),
              _buildSciButton('log', () => notifier.onFunctionPressed('log('), actionBg, actionFg),
              _buildSciButton('ln', () => notifier.onFunctionPressed('ln('), actionBg, actionFg),
              _buildSciButton('(', () => notifier.onFunctionPressed('('), actionBg, actionFg),
              _buildSciButton(')', () => notifier.onFunctionPressed(')'), actionBg, actionFg),
            ],
          ),
          Row(
            children: [
              _buildSciButton('√', () => notifier.onFunctionPressed('sqrt('), actionBg, actionFg),
              _buildSciButton('!', () => notifier.onFunctionPressed('!'), actionBg, actionFg),
              _buildSciButton('1/x', () => notifier.onFunctionPressed('^-1'), actionBg, actionFg),
              _buildSciButton('π', () => notifier.onConstantPressed('pi'), actionBg, actionFg),
              _buildSciButton('e', () => notifier.onConstantPressed('e'), actionBg, actionFg),
            ],
          ),
          Row(
            children: [
              _buildSciButton('mod', () => notifier.onOperatorPressed('mod'), actionBg, actionFg),
              _buildSciButton('sinh', () => notifier.onFunctionPressed('sinh('), actionBg, actionFg),
              _buildSciButton('cosh', () => notifier.onFunctionPressed('cosh('), actionBg, actionFg),
              _buildSciButton('tanh', () => notifier.onFunctionPressed('tanh('), actionBg, actionFg),
              _buildSciButton('eˣ', () => notifier.onFunctionPressed('exp('), actionBg, actionFg),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSciButton(String text, VoidCallback onPressed, Color bgColor, Color fgColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 0,
            minimumSize: Size.zero,
          ),
          child: Text(
            text,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
