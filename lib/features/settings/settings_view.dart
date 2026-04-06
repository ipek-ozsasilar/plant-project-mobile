import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/theme/theme_mode_provider.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
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
    final NotificationService notifications = sl<NotificationService>();
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(pad, pad, pad, WidgetSizesEnum.bottomNavHeight.value),
        children: <Widget>[
          Text(
            context.l10n.settingsHeadline,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            context.l10n.settingsSubtitle,
            style: tt.bodyLarge?.copyWith(
              color: context.palMuted,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
          FutureBuilder<bool>(
            future: notifications.isEnabled(),
            builder: (BuildContext context, AsyncSnapshot<bool> snap) {
              final bool enabled = snap.data ?? false;
              final String wateringTitle = context.l10n.notificationWateringTitle;
              final String wateringBody = context.l10n.notificationWateringBody;
              return SoftElevationCard(
                onTap: null,
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.65),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: WidgetSizesEnum.cardRadius.value * 0.45,
                    vertical: WidgetSizesEnum.divider.value * 2,
                  ),
                  value: enabled,
                  onChanged: (bool v) async {
                    await notifications.setEnabled(v);
                    if (v) {
                      await notifications.requestPermissions();
                      await notifications.scheduleDailyWatering(
                        title: wateringTitle,
                        body: wateringBody,
                      );
                    } else {
                      await notifications.cancelAll();
                    }
                    if (context.mounted) {
                      (context as Element).markNeedsBuild();
                    }
                  },
                  title: Text(
                    context.l10n.notificationsLabel,
                    style: TextStyle(fontWeight: FontWeight.w900, color: context.palOnSurface),
                  ),
                  subtitle: Text(
                    context.l10n.notificationsSubtitle,
                    style: TextStyle(color: context.palMuted, height: 1.3),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          Text(
            context.l10n.languageLabel,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
            child: SegmentedButton<_LocaleSegment>(
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
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          Text(
            context.l10n.themeLabel,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
            child: SegmentedButton<ThemeMode>(
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
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          Text(
            context.l10n.apiHint,
            style: TextStyle(
              fontSize: TextSizesEnum.caption.value,
              color: context.palMuted,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
