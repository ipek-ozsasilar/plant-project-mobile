import 'package:bitirme_mobile/core/enums/confidence_threshold_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

final class ConfidenceIndicator extends StatelessWidget {
  const ConfidenceIndicator({
    required this.confidenceUnit,
    required this.label,
    super.key,
  });

  final double confidenceUnit;
  final String label;

  @override
  Widget build(BuildContext context) {
    final double v = confidenceUnit.clamp(0.0, 1.0);
    final Color color = _colorFor(context, v);

    return Container(
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
      decoration: BoxDecoration(
        color: context.palSurfaceCard,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
        border: Border.all(color: context.palOutline.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: ImageSizesEnum.thumb.value,
            height: ImageSizesEnum.thumb.value,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  value: v,
                  color: color,
                  backgroundColor: context.palOutline.withValues(alpha: 0.35),
                  strokeWidth: WidgetSizesEnum.divider.value * 6,
                ),
                Text(
                  '${confidenceToDisplayPercent(v)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: TextSizesEnum.caption.value,
                    color: context.palOnSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: TextSizesEnum.subtitle.value,
                    color: context.palOnSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                  child: LinearProgressIndicator(
                    value: v,
                    color: color,
                    backgroundColor: context.palOutline.withValues(alpha: 0.25),
                    minHeight: WidgetSizesEnum.divider.value * 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(BuildContext context, double unit) {
    if (unit < ConfidenceThresholdEnum.low.value) {
      return ColorName.error;
    }
    if (unit < ConfidenceThresholdEnum.medium.value) {
      return ColorName.warning;
    }
    return ColorName.success;
  }
}

