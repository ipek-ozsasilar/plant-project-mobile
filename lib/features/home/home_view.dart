import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Ana sayfa panosu.
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
    final DateFormat fmt = DateFormat.yMMMd('tr');

    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.homeTitle.value)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
          children: <Widget>[
            Text(
              '${StringsEnum.homeGreeting.value}, $name',
              style: TextStyle(
                fontSize: TextSizesEnum.headline.value,
                fontWeight: FontWeight.bold,
                color: ColorName.onSurface,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.5),
            Text(
              StringsEnum.appTagline.value,
              style: TextStyle(
                fontSize: TextSizesEnum.body.value,
                color: ColorName.onSurfaceMuted,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorName.primary.withValues(alpha: 0.12),
                  child: Icon(Icons.photo_camera_outlined, color: ColorName.primary),
                ),
                title: Text(StringsEnum.homeQuickScan.value),
                subtitle: Text(StringsEnum.homeQuickScanDesc.value),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppPaths.scan),
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
            Text(
              StringsEnum.homeStatsTitle.value,
              style: TextStyle(
                fontSize: TextSizesEnum.subtitle.value,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Row(
              children: <Widget>[
                Expanded(
                  child: _StatCard(
                    label: StringsEnum.homeStatScans.value,
                    value: '${history.length}',
                  ),
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value),
                Expanded(
                  child: _StatCard(
                    label: StringsEnum.homeStatSpecies.value,
                    value: '${history.length}',
                  ),
                ),
              ],
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  StringsEnum.homeRecent.value,
                  style: TextStyle(
                    fontSize: TextSizesEnum.subtitle.value,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppPaths.history),
                  child: Text(StringsEnum.homeSeeAll.value),
                ),
              ],
            ),
            if (history.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: WidgetSizesEnum.cardRadius.value),
                child: Text(
                  StringsEnum.emptyState.value,
                  style: TextStyle(color: ColorName.onSurfaceMuted),
                ),
              )
            else
              ...history.take(3).map((ScanRecordModel e) {
                final String dateStr = fmt.format(e.createdAt);
                return Card(
                  child: ListTile(
                    title: Text(e.speciesLabel),
                    subtitle: Text('$dateStr · ${e.diseaseLabel}'),
                    leading: const Icon(Icons.eco_outlined),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                fontSize: TextSizesEnum.headline.value,
                fontWeight: FontWeight.bold,
                color: ColorName.primary,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.divider.value * 2),
            Text(
              label,
              style: TextStyle(
                fontSize: TextSizesEnum.caption.value,
                color: ColorName.onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
