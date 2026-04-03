import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
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
            color: ColorName.surfaceCard,
            borderRadius: BorderRadius.circular(WidgetSizesEnum.inputFieldRadius.value * 1.1),
            border: Border.all(color: ColorName.outline.withValues(alpha: 0.55)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: ColorName.onSurface.withValues(alpha: 0.05),
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
                  color: ColorName.primary,
                  size: IconSizesEnum.large.value,
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                Expanded(
                  child: Text(
                    StringsEnum.homeSearchHint.value,
                    style: tt.bodyMedium?.copyWith(
                      color: ColorName.onSurfaceMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 8),
                  decoration: BoxDecoration(
                    color: ColorName.primaryLight.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: IconSizesEnum.medium.value,
                    color: ColorName.primaryDark,
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
