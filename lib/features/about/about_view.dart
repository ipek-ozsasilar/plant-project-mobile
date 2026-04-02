import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Proje hakkında bilgi.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.aboutTitle.value)),
      body: Padding(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              StringsEnum.appName.value,
              style: TextStyle(
                fontSize: TextSizesEnum.headline.value,
                fontWeight: FontWeight.bold,
                color: ColorName.primary,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Text(
              StringsEnum.aboutBody.value,
              style: TextStyle(
                fontSize: TextSizesEnum.body.value,
                color: ColorName.onSurfaceMuted,
                height: 1.5,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Text(
              StringsEnum.aboutThesis.value,
              style: TextStyle(
                fontSize: TextSizesEnum.body.value,
                color: ColorName.onSurface,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
