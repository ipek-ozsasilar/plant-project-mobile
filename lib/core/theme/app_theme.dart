import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pembe–beyaz, yumuşak ve güncel Material 3 teması.
abstract final class AppTheme {
  static ThemeData light() {
    final ColorScheme scheme = ColorScheme.light(
      primary: ColorName.primary,
      onPrimary: Colors.white,
      primaryContainer: ColorName.primaryLight,
      onPrimaryContainer: ColorName.primaryDark,
      secondary: ColorName.accent,
      onSecondary: ColorName.onSurface,
      surface: ColorName.surface,
      onSurface: ColorName.onSurface,
      error: ColorName.error,
      onError: Colors.white,
      outline: ColorName.outline,
      surfaceContainerHighest: ColorName.surfaceCard,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: ColorName.surface,
      splashFactory: InkSparkle.splashFactory,
    );

    final TextTheme textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: ColorName.onSurface,
      displayColor: ColorName.onSurface,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ColorName.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorName.surfaceCard,
        elevation: WidgetSizesEnum.divider.value * 2,
        shadowColor: ColorName.primary.withValues(alpha: 0.14),
        surfaceTintColor: ColorName.primary.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
          side: BorderSide(color: ColorName.outline.withValues(alpha: 0.55)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: WidgetSizesEnum.cardRadius.value * 1.25,
            vertical: WidgetSizesEnum.divider.value * 6,
          ),
          shape: const StadiumBorder(),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: WidgetSizesEnum.cardRadius.value * 1.25,
            vertical: WidgetSizesEnum.divider.value * 6,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(color: ColorName.outline, width: 1.5),
          foregroundColor: ColorName.primaryDark,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorName.primary,
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorName.primary,
        foregroundColor: Colors.white,
        elevation: WidgetSizesEnum.fabYOffset.value,
        highlightElevation: WidgetSizesEnum.fabYOffset.value + 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorName.surfaceCard,
        indicatorColor: ColorName.primaryLight.withValues(alpha: 0.85),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorName.surfaceCard,
        contentPadding: EdgeInsets.symmetric(
          horizontal: WidgetSizesEnum.cardRadius.value * 1.1,
          vertical: WidgetSizesEnum.divider.value * 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value),
          borderSide: BorderSide(color: ColorName.outline.withValues(alpha: 0.9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value),
          borderSide: BorderSide(color: ColorName.outline.withValues(alpha: 0.9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value),
          borderSide: BorderSide(color: ColorName.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value),
          borderSide: BorderSide(color: ColorName.error.withValues(alpha: 0.85)),
        ),
        labelStyle: TextStyle(color: ColorName.onSurfaceMuted, fontSize: TextSizesEnum.body.value),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          return TextStyle(
            color: states.contains(WidgetState.focused) ? ColorName.primary : ColorName.onSurfaceMuted,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(BorderSide(color: ColorName.outline)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value),
            ),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: ColorName.outline.withValues(alpha: 0.5), thickness: 1),
    );
  }

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.dark(
      primary: ColorName.primaryLight,
      onPrimary: ColorName.primaryDark,
      primaryContainer: ColorName.primary.withValues(alpha: 0.35),
      onPrimaryContainer: ColorName.onSurfaceDark,
      secondary: ColorName.accent,
      onSecondary: ColorName.surfaceDark,
      surface: ColorName.surfaceDark,
      onSurface: ColorName.onSurfaceDark,
      error: ColorName.error,
      onError: Colors.white,
      outline: ColorName.outline.withValues(alpha: 0.4),
      surfaceContainerHighest: ColorName.surfaceCardDark,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: ColorName.surfaceDark,
      splashFactory: InkSparkle.splashFactory,
    );

    final TextTheme textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: ColorName.onSurfaceDark,
      displayColor: ColorName.onSurfaceDark,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ColorName.onSurfaceDark,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: ColorName.surfaceCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
          side: BorderSide(color: ColorName.outline.withValues(alpha: 0.25)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorName.surfaceCardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value),
        ),
      ),
    );
  }
}
