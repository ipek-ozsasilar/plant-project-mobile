import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Son taramalar — yatay kaydırmalı kart şeridi.
class HomeRecentStrip extends StatelessWidget {
  const HomeRecentStrip({
    required this.records,
    super.key,
  });

  final List<ScanRecordModel> records;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final DateFormat fmt = DateFormat.yMMMd('tr');
    return SizedBox(
      height: WidgetSizesEnum.recentCardHeight.value,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: records.length,
        separatorBuilder: (_, __) => SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
        itemBuilder: (BuildContext context, int i) {
          final ScanRecordModel e = records[i];
          final String dateStr = fmt.format(e.createdAt);
          return Container(
            width: WidgetSizesEnum.maxContentWidth.value * 0.52,
            decoration: BoxDecoration(
              color: ColorName.surfaceCard,
              borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
              border: Border.all(color: ColorName.outline.withValues(alpha: 0.45)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: ColorName.primary.withValues(alpha: 0.06),
                  blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.7,
                  offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.65),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
              child: Row(
                children: <Widget>[
                  Container(
                    width: WidgetSizesEnum.divider.value * 5,
                    color: ColorName.accent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.75),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.eco_rounded,
                                size: IconSizesEnum.small.value,
                                color: ColorName.primary,
                              ),
                              SizedBox(width: WidgetSizesEnum.divider.value * 4),
                              Expanded(
                                child: Text(
                                  e.speciesLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: ColorName.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: WidgetSizesEnum.divider.value * 6),
                          Text(
                            e.diseaseLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.bodySmall?.copyWith(
                              color: ColorName.onSurfaceMuted,
                              height: 1.25,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dateStr,
                            style: tt.labelSmall?.copyWith(
                              color: ColorName.onSurfaceMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
