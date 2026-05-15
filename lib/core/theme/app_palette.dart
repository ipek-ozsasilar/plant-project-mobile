import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Açık/koyu modda [ColorName] yerine tutarlı yüzey ve vurgu renkleri.
extension AppPalette on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  // Koyu modda daha belirgin koyu yeşil zemin
  Color get palSurface => _isDark ? const Color(0xFF0F1A16) : ColorName.surface;

  Color get palSurfaceCard => _isDark ? const Color(0xFF1D2E28) : ColorName.surfaceCard;

  Color get palOnSurface => _isDark ? ColorName.onSurfaceDark : ColorName.onSurface;

  Color get palMuted => _isDark ? const Color(0xFF9DB2A9) : ColorName.onSurfaceMuted;

  Color get palPrimary => _isDark ? ColorName.themeDarkPrimary : ColorName.primary;

  Color get palOnPrimary => _isDark ? ColorName.themeDarkOnPrimary : Colors.white;

  Color get palAccent => _isDark ? ColorName.themeDarkAccent : ColorName.accent;

  Color get palOutline => _isDark ? const Color(0xFF3A4D45) : ColorName.outline;

  Color get palPrimarySoftBg =>
      _isDark ? ColorName.themeDarkPrimary.withValues(alpha: 0.14) : ColorName.primaryLight.withValues(alpha: 0.55);

  List<Color> get palHeaderGradientColors {
    if (_isDark) {
      return <Color>[
        const Color(0xFF25503E), // Daha canlı koyu yeşil başlangıç
        const Color(0xFF18362B),
        const Color(0xFF0F1A16), // Zemine bağlanan son
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
        const Color(0xFF2D5A47),
        const Color(0xFF1D3B2F),
      ];
    }
    return <Color>[ColorName.primary, ColorName.accent];
  }

  List<Color> get palAuthHeroGradient {
    if (_isDark) {
      return <Color>[
        const Color(0xFF2D5A47),
        const Color(0xFF25503E),
        const Color(0xFF0F1A16),
      ];
    }
    return <Color>[ColorName.primary, ColorName.accent, ColorName.gradientEnd];
  }
}
