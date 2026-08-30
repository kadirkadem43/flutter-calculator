import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note: flutter_gen is auto-generated based on l10n.yaml after `flutter gen-l10n` runs.
// We use a delayed import or expect it to be generated.
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'presentation/calculator/screens/calculator_screen.dart';

import 'package:calculator_app/data/local/history_item_adapter.dart';
import 'package:calculator_app/data/repositories/hive_history_repository.dart';
import 'package:calculator_app/presentation/history/providers/history_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculator_app/presentation/settings/providers/theme_notifier.dart';

import 'package:calculator_app/data/services/admob_service.dart';
import 'package:calculator_app/data/services/iap_service.dart';
import 'package:calculator_app/presentation/monetization/providers/premium_notifier.dart';
import 'package:calculator_app/presentation/monetization/widgets/ad_banner_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryItemAdapter());
  
  final historyRepo = HiveHistoryRepository();
  await historyRepo.init();
  
  final prefs = await SharedPreferences.getInstance();
  
  final adService = AdMobService();
  await adService.init();
  
  final iapService = IapService(prefs);
  await iapService.init();
  
  runApp(
    ProviderScope(
      overrides: [
        historyRepositoryProvider.overrideWithValue(historyRepo),
        sharedPreferencesProvider.overrideWithValue(prefs),
        adServiceProvider.overrideWithValue(adService),
        iapServiceProvider.overrideWithValue(iapService),
      ],
      child: const CalculatorApp(),
    ),
  );
}

class CalculatorApp extends ConsumerWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Calculator App',
      debugShowCheckedModeBanner: false,
      
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      
      home: const CalculatorScreen(),
    );
  }
}
