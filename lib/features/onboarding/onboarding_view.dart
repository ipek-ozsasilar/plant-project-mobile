import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// İlk kurulum slaytları — modern kart ve degrade düzen.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _index = 0;

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
    if (_index < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorName.surface,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ColorName.surface,
                ColorName.primaryLight.withValues(alpha: 0.55),
                ColorName.gradientEnd.withValues(alpha: 0.25),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: WidgetSizesEnum.cardRadius.value),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          StringsEnum.onboardingSkip.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ColorName.primary,
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
                      _OnboardingSlide(
                        icon: Icons.auto_awesome_rounded,
                        iconColor: ColorName.primary,
                        title: StringsEnum.onboardingTitle1.value,
                        body: StringsEnum.onboardingBody1.value,
                        chipLabel: StringsEnum.onboardingStep1.value,
                      ),
                      _OnboardingSlide(
                        icon: Icons.grid_view_rounded,
                        iconColor: ColorName.accent,
                        title: StringsEnum.onboardingTitle2.value,
                        body: StringsEnum.onboardingBody2.value,
                        chipLabel: StringsEnum.onboardingStep2.value,
                      ),
                      _OnboardingSlide(
                        icon: Icons.insights_rounded,
                        iconColor: ColorName.info,
                        title: StringsEnum.onboardingTitle3.value,
                        body: StringsEnum.onboardingBody3.value,
                        chipLabel: StringsEnum.onboardingStep3.value,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(3, (int i) {
                          final bool active = i == _index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: EdgeInsets.symmetric(
                              horizontal: WidgetSizesEnum.divider.value * 3,
                            ),
                            height: WidgetSizesEnum.divider.value * 3,
                            width: active ? WidgetSizesEnum.cardRadius.value : WidgetSizesEnum.divider.value * 3,
                            decoration: BoxDecoration(
                              color: active ? ColorName.primary : ColorName.outline.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.1),
                      AppPrimaryButton(
                        label: _index < 2
                            ? StringsEnum.onboardingNext.value
                            : StringsEnum.onboardingStart.value,
                        onPressed: _next,
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
    required this.chipLabel,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String chipLabel;

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
              color: ColorName.primary.withValues(alpha: 0.06),
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
              color: ColorName.accent.withValues(alpha: 0.12),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: WidgetSizesEnum.cardRadius.value * 0.75,
                      vertical: WidgetSizesEnum.divider.value * 5,
                    ),
                    decoration: BoxDecoration(
                      color: ColorName.primaryLight.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                    ),
                    child: Text(
                      chipLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: ColorName.primaryDark,
                        fontSize: TextSizesEnum.caption.value,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                Container(
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        iconColor.withValues(alpha: 0.2),
                        ColorName.gradientEnd.withValues(alpha: 0.35),
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
                    color: ColorName.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: tt.bodyLarge?.copyWith(
                    color: ColorName.onSurfaceMuted,
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
