import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menü — kart ızgarası ve kısa açıklamalar.
class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    return Scaffold(
      backgroundColor: ColorName.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                pad,
                WidgetSizesEnum.cardRadius.value * 1.75,
                pad,
                WidgetSizesEnum.cardRadius.value * 0.65,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    StringsEnum.moreScreenTitle.value,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: ColorName.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 8),
                  Text(
                    StringsEnum.moreScreenSubtitle.value,
                    style: tt.bodyLarge?.copyWith(
                      color: ColorName.onSurfaceMuted,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, pad, pad, WidgetSizesEnum.bottomNavHeight.value),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: WidgetSizesEnum.cardRadius.value,
                crossAxisSpacing: WidgetSizesEnum.cardRadius.value,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildListDelegate(
                <Widget>[
                  _MoreTileCard(
                    icon: Icons.menu_book_rounded,
                    iconBg: ColorName.primary.withValues(alpha: 0.12),
                    iconColor: ColorName.primary,
                    title: StringsEnum.guideTitle.value,
                    subtitle: StringsEnum.moreTileGuideDesc.value,
                    onTap: () => context.push(AppPaths.guide),
                  ),
                  _MoreTileCard(
                    icon: Icons.person_rounded,
                    iconBg: ColorName.accent.withValues(alpha: 0.14),
                    iconColor: ColorName.accent,
                    title: StringsEnum.profileTitle.value,
                    subtitle: StringsEnum.moreTileProfileDesc.value,
                    onTap: () => context.push(AppPaths.profile),
                  ),
                  _MoreTileCard(
                    icon: Icons.settings_rounded,
                    iconBg: ColorName.info.withValues(alpha: 0.14),
                    iconColor: ColorName.info,
                    title: StringsEnum.settingsTitle.value,
                    subtitle: StringsEnum.moreTileSettingsDesc.value,
                    onTap: () => context.push(AppPaths.settings),
                  ),
                  _MoreTileCard(
                    icon: Icons.info_outline_rounded,
                    iconBg: ColorName.warning.withValues(alpha: 0.35),
                    iconColor: ColorName.primaryDark,
                    title: StringsEnum.aboutTitle.value,
                    subtitle: StringsEnum.moreTileAboutDesc.value,
                    onTap: () => context.push(AppPaths.about),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreTileCard extends StatelessWidget {
  const _MoreTileCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: onTap,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                ),
                child: Icon(icon, color: iconColor, size: IconSizesEnum.large.value),
              ),
              const Spacer(),
              Icon(
                Icons.north_east_rounded,
                size: IconSizesEnum.small.value,
                color: ColorName.onSurfaceMuted,
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: ColorName.onSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 6),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: tt.bodySmall?.copyWith(
              color: ColorName.onSurfaceMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
