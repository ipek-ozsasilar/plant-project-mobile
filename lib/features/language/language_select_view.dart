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
    final double pad = WidgetSizesEnum.cardRadius.value * 1.35;

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
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 2),
              Text(
                LanguagePickerStringsEnum.headline.value,
                textAlign: TextAlign.center,
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.palOnSurface,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 8),
              Text(
                LanguagePickerStringsEnum.subtitle.value,
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(
                  color: context.palMuted,
                  height: 1.35,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 2.5),
              _LanguageCard(
                title: LanguagePickerStringsEnum.turkishTitle.value,
                subtitle: LanguagePickerStringsEnum.turkishSubtitle.value,
                flag: '🇹🇷',
                onTap: onTurkish,
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              _LanguageCard(
                title: LanguagePickerStringsEnum.englishTitle.value,
                subtitle: LanguagePickerStringsEnum.englishSubtitle.value,
                flag: '🇬🇧',
                onTap: onEnglish,
              ),
            ],
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
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.15),
            child: Row(
              children: <Widget>[
                Text(flag, style: TextStyle(fontSize: TextSizesEnum.title.value)),
                SizedBox(width: WidgetSizesEnum.cardRadius.value),
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
                      SizedBox(height: WidgetSizesEnum.divider.value * 4),
                      Text(
                        subtitle,
                        style: tt.bodySmall?.copyWith(color: context.palMuted, height: 1.3),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.palMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
