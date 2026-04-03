import 'package:bitirme_mobile/core/enums/duration_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// İlk yükleme ve yönlendirme ekranı.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future<void>.delayed(DurationEnum.splashDelay.duration);
    await ref.read(authProvider.notifier).hydrate();
    final AuthStorageService svc = sl<AuthStorageService>();
    final bool done = await svc.hasCompletedOnboarding();
    final String? email = await svc.getEmail();
    if (!mounted) {
      return;
    }
    if (!done) {
      context.go(AppPaths.onboarding);
    } else if (email == null || email.isEmpty) {
      context.go(AppPaths.login);
    } else {
      context.go(AppPaths.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorName.surface,
                  ColorName.primaryLight.withValues(alpha: 0.75),
                  ColorName.gradientEnd.withValues(alpha: 0.45),
                ],
                stops: const <double>[0.0, 0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            right: -WidgetSizesEnum.decorativeBlob.value * 0.15,
            top: WidgetSizesEnum.cardRadius.value * 2,
            child: Container(
              width: WidgetSizesEnum.decorativeBlob.value,
              height: WidgetSizesEnum.decorativeBlob.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorName.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -WidgetSizesEnum.homeHeaderExtend.value,
            bottom: WidgetSizesEnum.cardRadius.value * 4,
            child: Container(
              width: WidgetSizesEnum.decorativeBlob.value * 0.55,
              height: WidgetSizesEnum.decorativeBlob.value * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorName.accent.withValues(alpha: 0.15),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorName.surfaceCard,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: ColorName.primary.withValues(alpha: 0.18),
                        blurRadius: WidgetSizesEnum.cardShadowBlur.value,
                        offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.65),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.eco_rounded,
                    size: ImageSizesEnum.hero.value * 0.62,
                    color: ColorName.primary,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                Text(
                  StringsEnum.appName.value,
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: ColorName.onSurface,
                    letterSpacing: -0.6,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 6),
                Text(
                  StringsEnum.appTagline.value,
                  textAlign: TextAlign.center,
                  style: tt.bodyLarge?.copyWith(
                    color: ColorName.onSurfaceMuted,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.65),
                Text(
                  StringsEnum.splashLoading.value,
                  style: TextStyle(
                    fontSize: TextSizesEnum.body.value,
                    color: ColorName.onSurfaceMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                CircularProgressIndicator(
                  color: ColorName.primary,
                  strokeWidth: WidgetSizesEnum.divider.value * 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
