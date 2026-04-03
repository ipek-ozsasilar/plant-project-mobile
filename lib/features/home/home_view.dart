import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_dashboard_header.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_empty_state.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_insight_banner.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_quick_actions_row.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_recent_strip.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_scan_hero_card.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_search_bar.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ana sayfa panosu — modern kart ve degrade düzeni.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authProvider);
    final List<ScanRecordModel> history = ref.watch(historyProvider);
    final String name = auth.displayName ?? StringsEnum.homeGreeting.value;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final List<ScanRecordModel> recent = history.take(8).toList();

    return Scaffold(
      backgroundColor: ColorName.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(child: HomeDashboardHeader(displayName: name)),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -WidgetSizesEnum.homeHeaderExtend.value * 0.55),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: pad),
                child: HomeSearchBar(onTap: () => context.push(AppPaths.scan)),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              pad,
              WidgetSizesEnum.divider.value * 2,
              pad,
              pad,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  HomeQuickActionsRow(
                    onScan: () => context.push(AppPaths.scan),
                    onHistory: () => context.go(AppPaths.history),
                    onGuide: () => context.push(AppPaths.guide),
                    onSettings: () => context.push(AppPaths.settings),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                  HomeScanHeroCard(onTap: () => context.push(AppPaths.scan)),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                  HomeInsightBanner(),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                  Text(
                    StringsEnum.homeStatsTitle.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: ColorName.onSurface,
                        ),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _HomeStatTile(
                          icon: Icons.analytics_rounded,
                          label: StringsEnum.homeStatScans.value,
                          value: '${history.length}',
                          accent: ColorName.primary,
                        ),
                      ),
                      SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
                      Expanded(
                        child: _HomeStatTile(
                          icon: Icons.biotech_rounded,
                          label: StringsEnum.homeStatSpecies.value,
                          value: '${history.length}',
                          accent: ColorName.accent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        StringsEnum.homeRecent.value,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: ColorName.onSurface,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppPaths.history),
                        child: Text(StringsEnum.homeSeeAll.value),
                      ),
                    ],
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                  if (recent.isEmpty)
                    HomeEmptyState(onStartScan: () => context.push(AppPaths.scan))
                  else
                    HomeRecentStrip(records: recent),
                  SizedBox(height: WidgetSizesEnum.bottomNavHeight.value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeStatTile extends StatelessWidget {
  const _HomeStatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: null,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
            ),
            child: Icon(icon, color: accent, size: IconSizesEnum.large.value),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: ColorName.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 4),
                Text(
                  label,
                  style: tt.labelMedium?.copyWith(
                    color: ColorName.onSurfaceMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
