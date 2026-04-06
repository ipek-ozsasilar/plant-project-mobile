import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
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
        color: context.palSurfaceCard,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.1),
        border: Border.all(color: context.palOutline.withValues(alpha: 0.5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.palOnSurface.withValues(alpha: 0.05),
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
                colors: context.palHeroCardGradient,
              ),
            ),
            child: Icon(
              Icons.park_rounded,
              size: ImageSizesEnum.preview.value * 0.55,
              color: context.palOnSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
          Text(
            context.l10n.homeEmptyTitle,
            textAlign: TextAlign.center,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            context.l10n.homeEmptySubtitle,
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: context.palMuted,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          FilledButton.icon(
            onPressed: onStartScan,
            icon: Icon(Icons.photo_camera_rounded, size: IconSizesEnum.medium.value),
            label: Text(context.l10n.homeStartScan),
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
