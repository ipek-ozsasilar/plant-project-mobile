import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Yüzen alt bar + yumuşak gölgeli tarama FAB.
class MainShellView extends StatelessWidget {
  const MainShellView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final double hPad = WidgetSizesEnum.bottomNavHorizontalPadding.value;
    final double bPad = WidgetSizesEnum.bottomNavBottomPadding.value;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorName.primary.withValues(alpha: 0.4),
              blurRadius: WidgetSizesEnum.fabBlurRadius.value,
              offset: Offset(0, WidgetSizesEnum.fabYOffset.value),
            ),
          ],
        ),
        child: FloatingActionButton.large(
          backgroundColor: ColorName.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.5),
          ),
          onPressed: () => context.push(AppPaths.scan),
          child: Icon(Icons.photo_camera_rounded, size: IconSizesEnum.large.value),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, bPad),
        child: Material(
          elevation: 12,
          shadowColor: ColorName.primary.withValues(alpha: 0.22),
          surfaceTintColor: ColorName.primaryLight.withValues(alpha: 0.35),
          color: ColorName.surfaceCard,
          borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.35),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: WidgetSizesEnum.bottomNavHeight.value,
            child: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _NavIcon(
                      icon: Icons.home_rounded,
                      selected: navigationShell.currentIndex == 0,
                      label: StringsEnum.navHome.value,
                      onTap: () => navigationShell.goBranch(0),
                    ),
                  ),
                  Expanded(
                    child: _NavIcon(
                      icon: Icons.history_rounded,
                      selected: navigationShell.currentIndex == 1,
                      label: StringsEnum.navHistory.value,
                      onTap: () => navigationShell.goBranch(1),
                    ),
                  ),
                  const SizedBox(width: 56),
                  Expanded(
                    child: _NavIcon(
                      icon: Icons.menu_rounded,
                      selected: navigationShell.currentIndex == 2,
                      label: StringsEnum.navMore.value,
                      onTap: () => navigationShell.goBranch(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    final Color active = ColorName.primary;
    final Color idle = ColorName.onSurfaceMuted;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 2),
              decoration: BoxDecoration(
                color: selected ? ColorName.primaryLight.withValues(alpha: 0.55) : Colors.transparent,
                borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
              ),
              child: Icon(
                icon,
                color: selected ? active : idle,
                size: IconSizesEnum.medium.value + 2,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.divider.value),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: TextSizesEnum.caption.value,
                height: 1.15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? active : idle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
