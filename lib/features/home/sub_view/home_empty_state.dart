import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Tarama geçmişi boşken gösterilen zengin boş durum.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({required this.onStartScan, super.key});

  final VoidCallback onStartScan;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.35),
      decoration: BoxDecoration(
        color: ColorName.surfaceCard,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.1),
        border: Border.all(color: ColorName.outline.withValues(alpha: 0.5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ColorName.onSurface.withValues(alpha: 0.05),
            blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.8,
            offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: <Color>[
                  ColorName.primaryLight.withValues(alpha: 0.85),
                  ColorName.gradientEnd.withValues(alpha: 0.5),
                ],
              ),
            ),
            child: Icon(
              Icons.park_rounded,
              size: ImageSizesEnum.preview.value * 0.55,
              color: ColorName.primary,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
          Text(
            StringsEnum.homeEmptyTitle.value,
            textAlign: TextAlign.center,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: ColorName.onSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            StringsEnum.homeEmptySubtitle.value,
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: ColorName.onSurfaceMuted,
              height: 1.45,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          FilledButton.icon(
            onPressed: onStartScan,
            icon: Icon(Icons.photo_camera_rounded, size: IconSizesEnum.medium.value),
            label: Text(StringsEnum.homeStartScan.value),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: WidgetSizesEnum.cardRadius.value * 1.5,
                vertical: WidgetSizesEnum.divider.value * 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
