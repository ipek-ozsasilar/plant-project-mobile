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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              ColorName.surface,
              ColorName.primaryLight.withValues(alpha: 0.65),
              ColorName.surface,
            ],
            stops: const <double>[0.0, 0.42, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.eco_rounded,
                size: ImageSizesEnum.hero.value,
                color: ColorName.primary,
                shadows: <Shadow>[
                  Shadow(
                    color: ColorName.primary.withValues(alpha: 0.25),
                    blurRadius: WidgetSizesEnum.fabBlurRadius.value,
                  ),
                ],
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              Text(
                StringsEnum.appName.value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: ColorName.onSurface,
                      letterSpacing: -0.5,
                    ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 4),
              Text(
                StringsEnum.splashLoading.value,
                style: TextStyle(
                  fontSize: TextSizesEnum.body.value,
                  color: ColorName.onSurfaceMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              CircularProgressIndicator(
                color: ColorName.primary,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
