import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:bitirme_mobile/core/services/plant_scans_firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Bitki detay: chart + son taramalar (timeline).
class PlantsDetailView extends ConsumerStatefulWidget {
  const PlantsDetailView({required this.plantId, super.key});

  final String plantId;

  @override
  ConsumerState<PlantsDetailView> createState() => _PlantsDetailViewState();
}

class _PlantsDetailViewState extends ConsumerState<PlantsDetailView> {
  bool _loading = true;
  List<PlantScanModel> _items = <PlantScanModel>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final PlantScansFirestoreService svc = sl<PlantScansFirestoreService>();
    final List<PlantScanModel> items = await svc.listScans(ownerUid: uid, plantId: widget.plantId);
    if (!mounted) {
      return;
    }
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final String loc = Localizations.localeOf(context).languageCode;
    final DateFormat fmt = DateFormat.yMMMd(loc);

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(title: Text(context.l10n.myPlantsDetailTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(pad, pad, pad, WidgetSizesEnum.bottomNavHeight.value),
              children: <Widget>[
                SoftElevationCard(
                  onTap: null,
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                  child: SizedBox(
                    height: WidgetSizesEnum.homeHeaderHeight.value * 0.85,
                    child: _items.isEmpty
                        ? Center(
                            child: Text(
                              context.l10n.myPlantsNoScans,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: context.palMuted),
                            ),
                          )
                        : LineChart(_chartData(context, _items)),
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                Text(
                  context.l10n.myPlantsTimelineTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    fontSize: TextSizesEnum.subtitle.value,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                if (_items.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: WidgetSizesEnum.cardRadius.value),
                    child: Text(
                      context.l10n.myPlantsTimelineEmpty,
                      style: TextStyle(color: context.palMuted),
                    ),
                  )
                else
                  ..._items.map((PlantScanModel e) {
                    final String disease = diseaseClassKeyToDisplay(e.diseaseKey, context.l10n);
                    return Padding(
                      padding: EdgeInsets.only(bottom: WidgetSizesEnum.cardRadius.value * 0.75),
                      child: SoftElevationCard(
                        onTap: null,
                        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: WidgetSizesEnum.cardRadius.value * 2.1,
                              height: WidgetSizesEnum.cardRadius.value * 2.1,
                              decoration: BoxDecoration(
                                color: context.palPrimary.withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                              ),
                              child: Icon(Icons.analytics_rounded, color: context.palPrimary),
                            ),
                            SizedBox(width: WidgetSizesEnum.cardRadius.value),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    fmt.format(e.createdAt),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: context.palOnSurface,
                                    ),
                                  ),
                                  SizedBox(height: WidgetSizesEnum.divider.value * 6),
                                  Text(
                                    '$disease • ${context.l10n.myPlantsHealthScoreLabel} ${e.healthScore}',
                                    style: TextStyle(color: context.palMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }

  LineChartData _chartData(BuildContext context, List<PlantScanModel> items) {
    final List<PlantScanModel> sorted = List<PlantScanModel>.from(items)
      ..sort((PlantScanModel a, PlantScanModel b) => a.createdAt.compareTo(b.createdAt));
    final List<FlSpot> spots = <FlSpot>[];
    for (int i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), sorted[i].healthScore.toDouble()));
    }
    return LineChartData(
      minY: 0,
      maxY: 100,
      gridData: FlGridData(show: true, horizontalInterval: 20),
      titlesData: const FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: context.palOutline)),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: context.palPrimary,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: context.palPrimary.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

