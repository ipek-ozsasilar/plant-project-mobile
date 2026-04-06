import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Üst arama çubuğu görünümü (dokununca [onTap] — örn. tarama).
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value * 1.1),
        child: Ink(
          decoration: BoxDecoration(
            color: context.palSurfaceCard,
            borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value * 1.1),
            border: Border.all(color: context.palOutline.withValues(alpha: 0.55)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: context.palOnSurface.withValues(alpha: 0.05),
                blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.55,
                offset: Offset(0, WidgetSizesEnum.divider.value * 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: WidgetSizesEnum.cardRadius.value,
              vertical: WidgetSizesEnum.divider.value * 14,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search_rounded,
                  color: context.palPrimary,
                  size: IconSizesEnum.large.value,
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                Expanded(
                  child: Text(
                    context.l10n.homeSearchHint,
                    style: tt.bodyMedium?.copyWith(
                      color: context.palMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 8),
                  decoration: BoxDecoration(
                    color: context.palPrimarySoftBg,
                    borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: IconSizesEnum.medium.value,
                    color: context.palPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
