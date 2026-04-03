import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Giriş / kayıt üst bölümü: degrade arka plan ve marka alanı.
class AuthGradientHero extends StatelessWidget {
  const AuthGradientHero({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.expand,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ColorName.primary,
                ColorName.accent,
                ColorName.gradientEnd,
              ],
            ),
          ),
        ),
        Positioned(
          right: -WidgetSizesEnum.decorativeBlob.value * 0.35,
          top: -WidgetSizesEnum.decorativeBlob.value * 0.15,
          child: Container(
            width: WidgetSizesEnum.decorativeBlob.value,
            height: WidgetSizesEnum.decorativeBlob.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          left: -WidgetSizesEnum.homeHeaderExtend.value,
          bottom: WidgetSizesEnum.cardRadius.value * 2,
          child: Container(
            width: WidgetSizesEnum.decorativeBlob.value * 0.55,
            height: WidgetSizesEnum.decorativeBlob.value * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: WidgetSizesEnum.cardRadius.value * 1.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.22),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.5,
                          offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.eco_rounded,
                      size: IconSizesEnum.xlarge.value + 8,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                  Text(
                    StringsEnum.appName.value,
                    textAlign: TextAlign.center,
                    style: tt.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 6),
                  Text(
                    StringsEnum.appTagline.value,
                    textAlign: TextAlign.center,
                    style: tt.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
