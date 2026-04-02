import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// İlk kurulum slaytları.
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: _finish,
            child: Text(StringsEnum.onboardingSkip.value),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int i) => setState(() => _index = i),
                children: <Widget>[
                  _OnboardingPage(
                    icon: Icons.psychology_outlined,
                    title: StringsEnum.onboardingTitle1.value,
                    body: StringsEnum.onboardingBody1.value,
                  ),
                  _OnboardingPage(
                    icon: Icons.touch_app,
                    title: StringsEnum.onboardingTitle2.value,
                    body: StringsEnum.onboardingBody2.value,
                  ),
                  _OnboardingPage(
                    icon: Icons.history_edu,
                    title: StringsEnum.onboardingTitle3.value,
                    body: StringsEnum.onboardingBody3.value,
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
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: WidgetSizesEnum.divider.value * 2,
                        ),
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: i == _index
                              ? ColorName.primary
                              : ColorName.outline,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value),
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
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: ImageSizesEnum.hero.value, color: ColorName.primary),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: TextSizesEnum.title.value,
              fontWeight: FontWeight.bold,
              color: ColorName.onSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: TextSizesEnum.body.value,
              color: ColorName.onSurfaceMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
