import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// using FittedBox for responsiveness
import 'package:calculator_app/presentation/calculator/providers/calculator_notifier.dart';
import 'package:calculator_app/domain/engine/result_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculatorDisplay extends ConsumerWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();

    // Format the expression and result based on Locale
    String displayResult = ResultFormatter.format(state.displayValue, locale: localeName);
    
    // Translate error messages if any
    if (state.hasError) {
      if (state.errorType == 'errorDivideByZero') displayResult = l10n.errorDivideByZero;
      else if (state.errorType == 'errorInvalidFormat') displayResult = l10n.errorInvalidFormat;
      else displayResult = l10n.errorGeneric;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      alignment: Alignment.bottomRight,
      child: Stack(
        children: [
          if (state.memoryValue != '0')
            Positioned(
              top: 0,
              left: 0,
              child: Text(
                'M',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
          // Expression Display
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                state.expression,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Main Result / Input Display
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                displayResult.isEmpty ? "0" : displayResult,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: state.hasError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
              ),
            ),
          ),
            ],
          ), // End of Column
        ],
      ), // End of Stack
    );
  }
}
