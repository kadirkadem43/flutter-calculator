import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/presentation/calculator/providers/calculator_notifier.dart';
import 'package:calculator_app/presentation/calculator/widgets/calculator_display.dart';
import 'package:calculator_app/presentation/calculator/widgets/calculator_keyboard.dart';
import 'package:calculator_app/presentation/calculator/widgets/scientific_keyboard.dart';
import 'package:calculator_app/presentation/calculator/widgets/memory_bar.dart';
import 'package:calculator_app/presentation/history/screens/history_screen.dart';
import 'package:calculator_app/presentation/settings/screens/settings_screen.dart';
import 'package:calculator_app/presentation/monetization/widgets/ad_banner_widget.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScientific =
        ref.watch(calculatorProvider.select((state) => state.isScientificMode));
    final notifier = ref.read(calculatorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Can add app name if desired
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout(context);
            } else {
              return _buildPortraitLayout(context, isScientific, notifier);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
      BuildContext context, bool isScientific, CalculatorNotifier notifier) {
    return Column(
      children: [
        // Display area
        const Expanded(
          flex: 3,
          child: CalculatorDisplay(),
        ),
        // Toggle Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: notifier.onToggleScientificMode,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isScientific ? Icons.expand_more : Icons.science_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isScientific ? "Basic" : "Scientific",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
        // Memory Bar
        const MemoryBar(),
        // Ad Banner
        const AdBannerWidget(),
        // Keyboards
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isScientific ? 210 : 0, // 4 rows of scientific keys
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: const ScientificKeyboard(),
          ),
        ),
        const Expanded(
          flex: 5,
          child: CalculatorKeyboard(),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      children: [
        // Display area spanning full width
        const Expanded(
          flex: 2,
          child: CalculatorDisplay(),
        ),
        // Keyboards
        Expanded(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Scientific Keyboard on the left
              const Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: ScientificKeyboard(),
                    ),
                  ],
                ),
              ),
              // Memory Bar and Basic Keyboard on the right
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    MemoryBar(),
                    Expanded(
                      child: CalculatorKeyboard(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
