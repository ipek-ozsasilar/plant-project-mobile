import 'package:bitirme_mobile/core/enums/language_picker_strings_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// İlk açılışta dil seçimi (splash öncesi).
class LanguageSelectView extends ConsumerWidget {
  const LanguageSelectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 0.95;

    Future<void> onTurkish() async {
      await ref.read(appLocaleProvider.notifier).selectTurkishFirstRun();
      if (context.mounted) {
        context.go(AppPaths.splash);
      }
    }

    Future<void> onEnglish() async {
      await ref.read(appLocaleProvider.notifier).selectEnglishFirstRun();
      if (context.mounted) {
        context.go(AppPaths.splash);
      }
    }

    return Scaffold(
      backgroundColor: context.palSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: pad * 0.75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                Text(
                  LanguagePickerStringsEnum.headline.value,
                  textAlign: TextAlign.center,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.palOnSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 5),
                Text(
                  LanguagePickerStringsEnum.subtitle.value,
                  textAlign: TextAlign.center,
                  style: tt.bodyLarge?.copyWith(
                    color: context.palMuted,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.8),
                _LanguageCard(
                  title: LanguagePickerStringsEnum.turkishTitle.value,
                  subtitle: LanguagePickerStringsEnum.turkishSubtitle.value,
                  flag: '🇹🇷',
                  onTap: onTurkish,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
                _LanguageCard(
                  title: LanguagePickerStringsEnum.englishTitle.value,
                  subtitle: LanguagePickerStringsEnum.englishSubtitle.value,
                  flag: '🇬🇧',
                  onTap: onEnglish,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String flag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double r = WidgetSizesEnum.cardRadius.value * 1.15;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r),
        child: Ink(
          decoration: BoxDecoration(
            color: context.palSurfaceCard,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(color: context.palOutline.withValues(alpha: 0.45)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: context.palPrimary.withValues(alpha: 0.06),
                blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.8,
                offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
            child: Row(
              children: <Widget>[
                Text(flag, style: TextStyle(fontSize: TextSizesEnum.title.value * 0.95)),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.palOnSurface,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.divider.value * 3),
                      Text(
                        subtitle,
                        style: tt.bodySmall?.copyWith(color: context.palMuted, height: 1.25),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.palMuted, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
