import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Açık/koyu modda [ColorName] yerine tutarlı yüzey ve vurgu renkleri.
extension AppPalette on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get palSurface => _isDark ? ColorName.surfaceDark : ColorName.surface;

  Color get palSurfaceCard => _isDark ? ColorName.surfaceCardDark : ColorName.surfaceCard;

  Color get palOnSurface => _isDark ? ColorName.onSurfaceDark : ColorName.onSurface;

  Color get palMuted => _isDark ? ColorName.onSurfaceDarkMuted : ColorName.onSurfaceMuted;

  Color get palPrimary => _isDark ? ColorName.themeDarkPrimary : ColorName.primary;

  Color get palOnPrimary => _isDark ? ColorName.themeDarkOnPrimary : Colors.white;

  Color get palAccent => _isDark ? ColorName.themeDarkAccent : ColorName.accent;

  Color get palOutline => _isDark ? ColorName.outlineDark : ColorName.outline;

  Color get palPrimarySoftBg =>
      _isDark ? ColorName.themeDarkPrimary.withValues(alpha: 0.14) : ColorName.primaryLight.withValues(alpha: 0.55);

  List<Color> get palHeaderGradientColors {
    if (_isDark) {
      return <Color>[
        ColorName.themeDarkHeader1,
        ColorName.themeDarkHeader2,
        ColorName.themeDarkHeader3,
      ];
    }
    return <Color>[
      ColorName.primary,
      ColorName.accent,
      ColorName.gradientEnd.withValues(alpha: 0.95),
    ];
  }

  List<Color> get palHeroCardGradient {
    if (_isDark) {
      return <Color>[
        ColorName.themeDarkHeader2,
        ColorName.themeDarkHeader3,
      ];
    }
    return <Color>[ColorName.primary, ColorName.accent];
  }

  List<Color> get palAuthHeroGradient {
    if (_isDark) {
      return <Color>[
        ColorName.themeDarkHeader1,
        ColorName.themeDarkHeader2,
        ColorName.themeDarkHeader3,
      ];
    }
    return <Color>[ColorName.primary, ColorName.accent, ColorName.gradientEnd];
  }
}
