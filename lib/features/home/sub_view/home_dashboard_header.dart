import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Ana sayfa üst karşılama alanı (degrade + selamlama).
class HomeDashboardHeader extends StatelessWidget {
  const HomeDashboardHeader({
    required this.displayName,
    super.key,
  });

  final String displayName;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final String trimmed = displayName.trim();
    final String initial =
        trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        WidgetSizesEnum.cardRadius.value * 1.25,
        WidgetSizesEnum.cardRadius.value * 0.75,
        WidgetSizesEnum.cardRadius.value * 1.25,
        WidgetSizesEnum.homeHeaderExtend.value * 1.05,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.palHeaderGradientColors,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(WidgetSizesEnum.homeHeaderExtend.value * 1.1),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.55)
                : context.palPrimary.withValues(alpha: 0.22),
            blurRadius: WidgetSizesEnum.cardShadowBlur.value,
            offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.homeGreeting,
                    style: tt.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 4),
                  Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 5),
                  Text(
                    context.l10n.appTagline,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: WidgetSizesEnum.quickActionTileWidth.value * 0.62,
              height: WidgetSizesEnum.quickActionTileWidth.value * 0.62,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: Text(
                initial,
                style: tt.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
