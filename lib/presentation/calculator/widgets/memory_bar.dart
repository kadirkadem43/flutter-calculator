import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/presentation/calculator/providers/calculator_notifier.dart';
import 'package:calculator_app/core/theme/app_typography.dart';
import 'package:calculator_app/core/theme/app_colors.dart';
import 'package:calculator_app/core/theme/app_radius.dart';

class MemoryBar extends ConsumerWidget {
  const MemoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(calculatorProvider.notifier);
    final state = ref.watch(calculatorProvider);
    final hasMemory = state.memoryValue != '0';
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final disabledColor = fgColor.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMemBtn('MC', hasMemory ? notifier.onMemoryClear : null, hasMemory ? fgColor : disabledColor),
          _buildMemBtn('MR', hasMemory ? notifier.onMemoryRecall : null, hasMemory ? fgColor : disabledColor),
          _buildMemBtn('M+', notifier.onMemoryAdd, fgColor),
          _buildMemBtn('M-', notifier.onMemorySubtract, fgColor),
          _buildMemBtn('MS', notifier.onMemoryStore, fgColor),
        ],
      ),
    );
  }

  Widget _buildMemBtn(String text, VoidCallback? onPressed, Color color) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: Text(
        text,
        style: AppTypography.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
