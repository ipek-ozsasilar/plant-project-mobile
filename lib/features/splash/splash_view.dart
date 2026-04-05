import 'package:bitirme_mobile/core/enums/duration_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
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
    final AuthStorageService svc = sl<AuthStorageService>();
    final bool langOk = await svc.isLanguageSelectionComplete();
    if (!mounted) {
      return;
    }
    if (!langOk) {
      context.go(AppPaths.language);
      return;
    }
    await Future<void>.delayed(DurationEnum.splashDelay.duration);
    await ref.read(authProvider.notifier).hydrate();
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> gradientColors = isDark
        ? <Color>[
            context.palSurface,
            ColorName.themeDarkHeader1,
            ColorName.themeDarkHeader2,
          ]
        : <Color>[
            context.palSurface,
            ColorName.primaryLight.withValues(alpha: 0.75),
            ColorName.gradientEnd.withValues(alpha: 0.45),
          ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
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
                color: context.palPrimary.withValues(alpha: 0.08),
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
                color: context.palAccent.withValues(alpha: 0.15),
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
                    color: context.palSurfaceCard,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: context.palPrimary.withValues(alpha: 0.18),
                        blurRadius: WidgetSizesEnum.cardShadowBlur.value,
                        offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.65),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.eco_rounded,
                    size: ImageSizesEnum.hero.value * 0.62,
                    color: context.palPrimary,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                Text(
                  context.l10n.appName,
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.palOnSurface,
                    letterSpacing: -0.6,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 6),
                Text(
                  context.l10n.appTagline,
                  textAlign: TextAlign.center,
                  style: tt.bodyLarge?.copyWith(
                    color: context.palMuted,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.65),
                Text(
                  context.l10n.splashLoading,
                  style: TextStyle(
                    fontSize: TextSizesEnum.body.value,
                    color: context.palMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                CircularProgressIndicator(
                  color: context.palPrimary,
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
