import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menü ve diğer sayfalara geçiş.
class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.navMore.value)),
      body: ListView(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(StringsEnum.guideTitle.value),
            onTap: () => context.push(AppPaths.guide),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(StringsEnum.profileTitle.value),
            onTap: () => context.push(AppPaths.profile),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(StringsEnum.settingsTitle.value),
            onTap: () => context.push(AppPaths.settings),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(StringsEnum.aboutTitle.value),
            onTap: () => context.push(AppPaths.about),
          ),
        ],
      ),
    );
  }
}
