import 'package:bitirme_mobile/core/initializers/app_initializers.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/navigation/app_router.dart';
import 'package:bitirme_mobile/core/theme/app_theme.dart';
import 'package:bitirme_mobile/core/theme/theme_mode_provider.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  await AppInitializers.init();
  runApp(
    const ProviderScope(
      child: BitirmeApp(),
    ),
  );
}

/// Kök widget: tema, dil, responsive ve yönlendirme.
class BitirmeApp extends ConsumerWidget {
  const BitirmeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final AppLocaleMode localeMode = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'PhytoGuard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: materialLocaleFor(localeMode),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (List<Locale>? locales, Iterable<Locale> supported) {
        if (locales == null) {
          return const Locale('en');
        }
        for (final Locale deviceLocale in locales) {
          if (deviceLocale.languageCode == 'tr') {
            return const Locale('tr');
          }
          if (deviceLocale.languageCode == 'en') {
            return const Locale('en');
          }
        }
        return const Locale('en');
      },
      routerConfig: router,
      builder: (BuildContext context, Widget? child) {
        return ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox.shrink(),
          breakpoints: const <Breakpoint>[
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
    );
  }
}
