import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: WidgetSizesEnum.cardRadius.value,
            vertical: WidgetSizesEnum.cardRadius.value * 0.85,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: WidgetSizesEnum.cardRadius.value * 1.85,
                height: WidgetSizesEnum.cardRadius.value * 1.85,
                decoration: BoxDecoration(
                  color: context.palPrimarySoftBg,
                  borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                ),
                child: Icon(icon, color: context.palPrimary, size: IconSizesEnum.large.value),
              ),
              SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
              Expanded(
                child: Text(
                  title,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.palMuted),
            ],
          ),
        ),
      ),
    );
  }
}

