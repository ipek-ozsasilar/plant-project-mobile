import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Bakım ve fotoğraf ipuçları rehberi.
class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.guideTitle)),
      body: ListView(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        children: <Widget>[
          _Section(
            title: context.l10n.guideSectionPhoto,
            body: context.l10n.guidePhotoTips,
            icon: Icons.photo_camera_outlined,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _Section(
            title: context.l10n.guideSectionMulti,
            body: context.l10n.guideMultiTips,
            icon: Icons.grid_on_outlined,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _Section(
            title: context.l10n.guideSectionDisease,
            body: context.l10n.guideDiseaseTips,
            icon: Icons.biotech_outlined,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: context.palPrimary, size: IconSizesEnum.large.value),
            SizedBox(width: WidgetSizesEnum.cardRadius.value),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: TextSizesEnum.subtitle.value,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 4),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: TextSizesEnum.body.value,
                      color: context.palMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
