import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Yuvarlatılmış köşe, hafif gölge ve ince çerçeve ile modern kart.
class SoftElevationCard extends StatelessWidget {
  const SoftElevationCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final double r = borderRadius ?? WidgetSizesEnum.cardRadius.value;
    final Color bg = backgroundColor ?? context.palSurfaceCard;
    final Widget inner = Padding(
      padding: padding ?? EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
      child: child,
    );
    final Widget body = onTap == null
        ? inner
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(r),
            child: inner,
          );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: context.palOutline.withValues(alpha: 0.45)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.palPrimary.withValues(alpha: 0.07),
            blurRadius: WidgetSizesEnum.cardShadowBlur.value,
            offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: body,
      ),
    );
  }
}
