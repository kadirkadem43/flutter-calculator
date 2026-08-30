import 'package:flutter/material.dart';
import 'package:calculator_app/core/theme/app_colors.dart';
import 'package:calculator_app/core/theme/app_typography.dart';
import 'package:calculator_app/core/theme/app_radius.dart';

enum ButtonType { normal, action, operator }

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final int flex;
  final IconData? icon;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.normal,
    this.flex = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color fgColor;

    switch (type) {
      case ButtonType.operator:
        bgColor = isDark
            ? AppColors.darkButtonOperator
            : AppColors.lightButtonOperator;
        fgColor = Colors.white; // Always white on orange
        break;
      case ButtonType.action:
        bgColor =
            isDark ? AppColors.darkButtonAction : AppColors.lightButtonAction;
        fgColor =
            isDark ? AppColors.darkBackground : AppColors.lightTextPrimary;
        break;
      case ButtonType.normal:
        bgColor =
            isDark ? AppColors.darkButtonDefault : AppColors.lightButtonDefault;
        fgColor =
            isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Add haptic feedback here in Phase 9
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: fgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
            child: icon != null
                ? Icon(icon, size: 28)
                : Text(
                    text,
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: fgColor,
                    ),
                  ),
          ),
        ),
    );
  }
}
