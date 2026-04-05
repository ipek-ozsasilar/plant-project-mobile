import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Öne çıkan tarama kartı (hero CTA).
class HomeScanHeroCard extends StatelessWidget {
  const HomeScanHeroCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double r = WidgetSizesEnum.cardRadius.value * 1.15;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: context.palHeroCardGradient,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.45)
                    : context.palPrimary.withValues(alpha: 0.35),
                blurRadius: WidgetSizesEnum.cardShadowBlur.value * 1.1,
                offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: WidgetSizesEnum.cardRadius.value * 0.65,
                          vertical: WidgetSizesEnum.divider.value * 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                        ),
                        child: Text(
                          context.l10n.homeHeroBadge,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: TextSizesEnum.caption.value,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                      Text(
                        context.l10n.homeQuickScan,
                        style: tt.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.divider.value * 6),
                      Text(
                        context.l10n.homeQuickScanDesc,
                        style: tt.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value),
                Container(
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.85),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    Icons.document_scanner_rounded,
                    color: Colors.white,
                    size: IconSizesEnum.xlarge.value + 6,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: IconSizesEnum.small.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
