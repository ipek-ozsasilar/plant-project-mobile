import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Yatay hızlı erişim: tarama, geçmiş, rehber, ayarlar.
class HomeQuickActionsRow extends StatelessWidget {
  const HomeQuickActionsRow({
    required this.onScan,
    required this.onHistory,
    required this.onGuide,
    required this.onSettings,
    super.key,
  });

  final VoidCallback onScan;
  final VoidCallback onHistory;
  final VoidCallback onGuide;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          StringsEnum.homeQuickAccessTitle.value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorName.onSurface,
              ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
        Row(
          children: <Widget>[
            Expanded(
              child: _QuickChip(
                icon: Icons.photo_camera_rounded,
                label: StringsEnum.navScan.value,
                highlight: true,
                onTap: onScan,
              ),
            ),
            SizedBox(width: WidgetSizesEnum.divider.value * 10),
            Expanded(
              child: _QuickChip(
                icon: Icons.history_rounded,
                label: StringsEnum.navHistory.value,
                onTap: onHistory,
              ),
            ),
            SizedBox(width: WidgetSizesEnum.divider.value * 10),
            Expanded(
              child: _QuickChip(
                icon: Icons.menu_book_rounded,
                label: StringsEnum.guideTitle.value,
                onTap: onGuide,
              ),
            ),
            SizedBox(width: WidgetSizesEnum.divider.value * 10),
            Expanded(
              child: _QuickChip(
                icon: Icons.tune_rounded,
                label: StringsEnum.settingsTitle.value,
                onTap: onSettings,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color bg = highlight
        ? ColorName.primary.withValues(alpha: 0.12)
        : ColorName.surfaceCard;
    final Color fg = highlight ? ColorName.primary : ColorName.onSurfaceMuted;
    final double r = WidgetSizesEnum.chipRadius.value * 1.1;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: WidgetSizesEnum.cardRadius.value * 0.65,
            horizontal: WidgetSizesEnum.divider.value * 4,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(
              color: highlight
                  ? ColorName.primary.withValues(alpha: 0.25)
                  : ColorName.outline.withValues(alpha: 0.5),
            ),
            boxShadow: highlight
                ? <BoxShadow>[
                    BoxShadow(
                      color: ColorName.primary.withValues(alpha: 0.12),
                      blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.45,
                      offset: Offset(0, WidgetSizesEnum.divider.value * 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: IconSizesEnum.large.value, color: fg),
              SizedBox(height: WidgetSizesEnum.divider.value * 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: TextSizesEnum.caption.value,
                  fontWeight: FontWeight.w600,
                  color: highlight ? ColorName.primaryDark : ColorName.onSurface,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
