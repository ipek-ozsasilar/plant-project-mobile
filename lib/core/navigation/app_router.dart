import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/about/about_view.dart';
import 'package:bitirme_mobile/features/auth/login/login_view.dart';
import 'package:bitirme_mobile/features/auth/register/register_view.dart';
import 'package:bitirme_mobile/features/guide/guide_view.dart';
import 'package:bitirme_mobile/features/health_progress/health_progress_view.dart';
import 'package:bitirme_mobile/features/language/language_select_view.dart';
import 'package:bitirme_mobile/features/history/history_view.dart';
import 'package:bitirme_mobile/features/home/home_view.dart';
import 'package:bitirme_mobile/features/more/more_view.dart';
import 'package:bitirme_mobile/features/onboarding/onboarding_view.dart';
import 'package:bitirme_mobile/features/profile/profile_view.dart';
import 'package:bitirme_mobile/features/scan/scan_flow_view.dart';
import 'package:bitirme_mobile/features/settings/settings_view.dart';
import 'package:bitirme_mobile/features/shell/main_shell_view.dart';
import 'package:bitirme_mobile/features/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Uygulama yönlendirme grafiği.
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    initialLocation: AppPaths.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppPaths.language,
        builder: (BuildContext context, GoRouterState state) => const LanguageSelectView(),
      ),
      GoRoute(
        path: AppPaths.splash,
        builder: (BuildContext context, GoRouterState state) => const SplashView(),
      ),
      GoRoute(
        path: AppPaths.onboarding,
        builder: (BuildContext context, GoRouterState state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppPaths.login,
        builder: (BuildContext context, GoRouterState state) => const LoginView(),
      ),
      GoRoute(
        path: AppPaths.register,
        builder: (BuildContext context, GoRouterState state) => const RegisterView(),
      ),
      GoRoute(
        path: AppPaths.healthProgress,
        builder: (BuildContext context, GoRouterState state) => const HealthProgressView(),
      ),
      GoRoute(
        path: AppPaths.scan,
        builder: (BuildContext context, GoRouterState state) => const ScanFlowView(),
      ),
      GoRoute(
        path: AppPaths.guide,
        builder: (BuildContext context, GoRouterState state) => const GuideView(),
      ),
      GoRoute(
        path: AppPaths.profile,
        builder: (BuildContext context, GoRouterState state) => const ProfileView(),
      ),
      GoRoute(
        path: AppPaths.settings,
        builder: (BuildContext context, GoRouterState state) => const SettingsView(),
      ),
      GoRoute(
        path: AppPaths.about,
        builder: (BuildContext context, GoRouterState state) => const AboutView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return MainShellView(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.home,
                builder: (BuildContext context, GoRouterState state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.history,
                builder: (BuildContext context, GoRouterState state) => const HistoryView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.more,
                builder: (BuildContext context, GoRouterState state) => const MoreView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
