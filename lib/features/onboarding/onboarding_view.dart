import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/language_picker_strings_enum.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// İlk kurulum slaytları — modern kart ve degrade düzen.
class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late final PageController _pageController;
  late bool _languageDone;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _languageDone = ref.read(appLocaleProvider) is! AppLocaleUnset;
    _index = _languageDone ? 1 : 0;
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final AuthStorageService svc = sl<AuthStorageService>();
    await svc.setOnboardingCompleted();
    if (!mounted) {
      return;
    }
    context.go(AppPaths.login);
  }

  void _next() {
    if (_index < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  int get _visibleSlidesCount => _languageDone ? 3 : 4;

  int get _visibleIndex {
    if (!_languageDone) {
      return _index;
    }
    final int v = _index - 1;
    if (v < 0) {
      return 0;
    }
    if (v > 2) {
      return 2;
    }
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations l10n = context.l10n;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.palSurface,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: context.palHeaderGradientColors,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: WidgetSizesEnum.cardRadius.value,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (_index > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            l10n.onboardingStep(_index, 3),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: context.palOnSurface,
                              fontSize: TextSizesEnum.subtitle.value,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      TextButton(
                        onPressed: (!_languageDone && _index == 0)
                            ? null
                            : _finish,
                        child: Text(
                          l10n.onboardingSkip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: context.palPrimary,
                            fontSize: TextSizesEnum.subtitle.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int i) => setState(() => _index = i),
                    children: <Widget>[
                      _LanguageSlide(
                        enabled: !_languageDone,
                        onTurkish: () async {
                          await ref
                              .read(appLocaleProvider.notifier)
                              .selectTurkishFirstRun();
                          if (!mounted) {
                            return;
                          }
                          setState(() => _languageDone = true);
                          await _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        onEnglish: () async {
                          await ref
                              .read(appLocaleProvider.notifier)
                              .selectEnglishFirstRun();
                          if (!mounted) {
                            return;
                          }
                          setState(() => _languageDone = true);
                          await _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      ),
                      _OnboardingSlide(
                        icon: Icons.auto_awesome_rounded,
                        iconColor: context.palPrimary,
                        title: l10n.onboardingTitle1,
                        body: l10n.onboardingBody1,
                      ),
                      _OnboardingSlide(
                        icon: Icons.grid_view_rounded,
                        iconColor: context.palAccent,
                        title: l10n.onboardingTitle2,
                        body: l10n.onboardingBody2,
                      ),
                      _OnboardingSlide(
                        icon: Icons.insights_rounded,
                        iconColor: ColorName.info,
                        title: l10n.onboardingTitle3,
                        body: l10n.onboardingBody3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    WidgetSizesEnum.cardRadius.value * 1.25,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(_visibleSlidesCount, (
                          int i,
                        ) {
                          final bool active = i == _visibleIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: EdgeInsets.symmetric(
                              horizontal: WidgetSizesEnum.divider.value * 3,
                            ),
                            height: WidgetSizesEnum.divider.value * 3,
                            width: active
                                ? WidgetSizesEnum.cardRadius.value
                                : WidgetSizesEnum.divider.value * 3,
                            decoration: BoxDecoration(
                              color: active
                                  ? context.palPrimary
                                  : context.palOutline.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(
                                WidgetSizesEnum.chipRadius.value,
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.1),
                      AppPrimaryButton(
                        label: _index < 3
                            ? l10n.onboardingNext
                            : l10n.onboardingStart,
                        onPressed: (!_languageDone && _index == 0)
                            ? null
                            : _next,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Stack(
      children: <Widget>[
        Positioned(
          right: -WidgetSizesEnum.decorativeBlob.value * 0.2,
          top: WidgetSizesEnum.cardRadius.value,
          child: Container(
            width: WidgetSizesEnum.decorativeBlob.value * 0.75,
            height: WidgetSizesEnum.decorativeBlob.value * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.palPrimary.withValues(alpha: 0.06),
            ),
          ),
        ),
        Positioned(
          left: -WidgetSizesEnum.homeHeaderExtend.value,
          bottom: WidgetSizesEnum.cardRadius.value * 3,
          child: Container(
            width: WidgetSizesEnum.decorativeBlob.value * 0.45,
            height: WidgetSizesEnum.decorativeBlob.value * 0.45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.palAccent.withValues(alpha: 0.12),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: WidgetSizesEnum.cardRadius.value * 1.35,
            vertical: WidgetSizesEnum.cardRadius.value * 0.5,
          ),
          child: SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(
                    WidgetSizesEnum.cardRadius.value * 1.5,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        iconColor.withValues(alpha: 0.2),
                        context.palAccent.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: ImageSizesEnum.hero.value * 0.55,
                    color: iconColor,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.palOnSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: tt.bodyLarge?.copyWith(
                    color: context.palMuted,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageSlide extends StatelessWidget {
  const _LanguageSlide({
    required this.enabled,
    required this.onTurkish,
    required this.onEnglish,
  });

  final bool enabled;
  final Future<void> Function() onTurkish;
  final Future<void> Function() onEnglish;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.35;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: pad,
        vertical: WidgetSizesEnum.cardRadius.value * 0.5,
      ),
      child: SoftElevationCard(
        onTap: null,
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      context.palAccent.withValues(alpha: 0.22),
                      context.palPrimary.withValues(alpha: 0.12),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.language_rounded,
                  size: ImageSizesEnum.hero.value * 0.48,
                  color: context.palPrimary,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.95),
              Text(
                LanguagePickerStringsEnum.headline.value,
                textAlign: TextAlign.center,
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.palOnSurface,
                  letterSpacing: -0.35,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 6),
              Text(
                LanguagePickerStringsEnum.subtitle.value,
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(
                  color: context.palMuted,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.1),
              _LanguageChoiceCard(
                enabled: enabled,
                title: LanguagePickerStringsEnum.turkishTitle.value,
                subtitle: LanguagePickerStringsEnum.turkishSubtitle.value,
                flag: '🇹🇷',
                onTap: onTurkish,
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.6),
              _LanguageChoiceCard(
                enabled: enabled,
                title: LanguagePickerStringsEnum.englishTitle.value,
                subtitle: LanguagePickerStringsEnum.englishSubtitle.value,
                flag: '🇬🇧',
                onTap: onEnglish,
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.4),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageChoiceCard extends StatelessWidget {
  const _LanguageChoiceCard({
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.onTap,
  });

  final bool enabled;
  final String title;
  final String subtitle;
  final String flag;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double r = WidgetSizesEnum.cardRadius.value * 1.15;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onTap() : null,
        borderRadius: BorderRadius.circular(r),
        child: Ink(
          decoration: BoxDecoration(
            color: context.palSurfaceCard,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(
              color: context.palOutline.withValues(alpha: 0.45),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: context.palAccent.withValues(alpha: 0.08),
                blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.8,
                offset: Offset(
                  0,
                  WidgetSizesEnum.cardShadowOffsetY.value * 0.45,
                ),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.85),
            child: Row(
              children: <Widget>[
                Text(
                  flag,
                  style: TextStyle(fontSize: TextSizesEnum.title.value * 0.9),
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
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
                        style: tt.bodySmall?.copyWith(
                          color: context.palMuted,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.palMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
