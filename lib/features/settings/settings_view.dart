import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/theme/theme_mode_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tema ve basit ayarlar.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.settingsTitle.value)),
      body: ListView(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        children: <Widget>[
          Text(
            StringsEnum.themeLabel.value,
            style: TextStyle(
              fontSize: TextSizesEnum.subtitle.value,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SegmentedButton<ThemeMode>(
            segments: <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text(StringsEnum.themeSystem.value),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text(StringsEnum.themeLight.value),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text(StringsEnum.themeDark.value),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: <ThemeMode>{mode},
            onSelectionChanged: (Set<ThemeMode> next) {
              ref.read(themeModeProvider.notifier).setMode(next.first);
            },
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 2),
          Text(
            StringsEnum.apiHint.value,
            style: TextStyle(
              fontSize: TextSizesEnum.caption.value,
              color: ColorName.onSurfaceMuted,
            ),
          ),
        ],
      ),
    );
  }
}
