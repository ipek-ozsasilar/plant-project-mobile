import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Kısa ipucu / içgörü kartı.
class HomeInsightBanner extends StatelessWidget {
  const HomeInsightBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: null,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
            decoration: BoxDecoration(
              color: ColorName.warning.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: ColorName.primaryDark,
              size: IconSizesEnum.large.value,
            ),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringsEnum.homeTipTitle.value,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: ColorName.onSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 6),
                Text(
                  StringsEnum.homeTipBody.value,
                  style: tt.bodySmall?.copyWith(
                    color: ColorName.onSurfaceMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
