import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dil seçenekleri (ayarlar segmenti).
enum _LocaleSegment { system, turkish, english }

/// Tema ve dil.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  static Set<_LocaleSegment> _selectedLocale(AppLocaleMode mode) {
    return switch (mode) {
      AppLocaleUnset() => <_LocaleSegment>{_LocaleSegment.turkish},
      AppLocaleFollowSystem() => <_LocaleSegment>{_LocaleSegment.system},
      AppLocaleFixed(:final Locale locale) => locale.languageCode == 'en'
          ? <_LocaleSegment>{_LocaleSegment.english}
          : <_LocaleSegment>{_LocaleSegment.turkish},
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode mode = ref.watch(themeModeProvider);
    final AppLocaleMode localeMode = ref.watch(appLocaleProvider);
    final AppLocaleNotifier localeNotifier = ref.read(appLocaleProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        children: <Widget>[
          Text(
            context.l10n.languageLabel,
            style: TextStyle(
              fontSize: TextSizesEnum.subtitle.value,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SegmentedButton<_LocaleSegment>(
            segments: <ButtonSegment<_LocaleSegment>>[
              ButtonSegment<_LocaleSegment>(
                value: _LocaleSegment.system,
                label: Text(context.l10n.languageSystem),
                icon: const Icon(Icons.language),
              ),
              ButtonSegment<_LocaleSegment>(
                value: _LocaleSegment.turkish,
                label: Text(context.l10n.languageTurkish),
              ),
              ButtonSegment<_LocaleSegment>(
                value: _LocaleSegment.english,
                label: Text(context.l10n.languageEnglish),
              ),
            ],
            selected: _selectedLocale(localeMode),
            onSelectionChanged: (Set<_LocaleSegment> next) {
              final _LocaleSegment v = next.first;
              if (v == _LocaleSegment.system) {
                localeNotifier.setFollowSystem();
              } else if (v == _LocaleSegment.turkish) {
                localeNotifier.setTurkish();
              } else {
                localeNotifier.setEnglish();
              }
            },
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 2),
          Text(
            context.l10n.themeLabel,
            style: TextStyle(
              fontSize: TextSizesEnum.subtitle.value,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SegmentedButton<ThemeMode>(
            segments: <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text(context.l10n.themeSystem),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text(context.l10n.themeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text(context.l10n.themeDark),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: <ThemeMode>{mode},
            onSelectionChanged: (Set<ThemeMode> next) {
              ref.read(themeModeProvider.notifier).setMode(next.first);
            },
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 2),
          Text(
            context.l10n.apiHint,
            style: TextStyle(
              fontSize: TextSizesEnum.caption.value,
              color: context.palMuted,
            ),
          ),
        ],
      ),
    );
  }
}
