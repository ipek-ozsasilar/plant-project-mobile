import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Bakım ve fotoğraf ipuçları rehberi.
class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.guideTitle.value)),
      body: ListView(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        children: <Widget>[
          _Section(
            title: StringsEnum.guideSectionPhoto.value,
            body: StringsEnum.guidePhotoTips.value,
            icon: Icons.photo_camera_outlined,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _Section(
            title: StringsEnum.guideSectionMulti.value,
            body: StringsEnum.guideMultiTips.value,
            icon: Icons.grid_on_outlined,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _Section(
            title: StringsEnum.guideSectionDisease.value,
            body: StringsEnum.guideDiseaseTips.value,
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
            Icon(icon, color: ColorName.primary, size: IconSizesEnum.large.value),
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
                      color: ColorName.onSurfaceMuted,
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
