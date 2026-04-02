import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Alt gezinme ve ortada tarama FAB ile ana kabuk.
class MainShellView extends StatelessWidget {
  const MainShellView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: ColorName.primary,
        foregroundColor: Colors.white,
        onPressed: () => context.push(AppPaths.scan),
        child: Icon(Icons.photo_camera_outlined, size: IconSizesEnum.large.value),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: WidgetSizesEnum.bottomNavHeight.value,
        shape: const CircularNotchedRectangle(),
        color: ColorName.surfaceCard,
        child: Row(
          children: <Widget>[
            Expanded(
              child: _NavIcon(
                icon: Icons.home_outlined,
                selected: navigationShell.currentIndex == 0,
                label: StringsEnum.navHome.value,
                onTap: () => navigationShell.goBranch(0),
              ),
            ),
            Expanded(
              child: _NavIcon(
                icon: Icons.history,
                selected: navigationShell.currentIndex == 1,
                label: StringsEnum.navHistory.value,
                onTap: () => navigationShell.goBranch(1),
              ),
            ),
            const SizedBox(width: 56),
            Expanded(
              child: _NavIcon(
                icon: Icons.menu,
                selected: navigationShell.currentIndex == 2,
                label: StringsEnum.navMore.value,
                onTap: () => navigationShell.goBranch(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? ColorName.primary : ColorName.onSurfaceMuted;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: IconSizesEnum.medium.value),
          SizedBox(height: WidgetSizesEnum.divider.value * 2),
          Text(
            label,
            style: TextStyle(
              fontSize: TextSizesEnum.caption.value,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
