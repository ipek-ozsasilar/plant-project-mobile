import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/health_progress/provider/health_progress_provider.dart';
import 'package:bitirme_mobile/features/health_progress/view_model/health_progress_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Eklenen bitkilerin sağlık/hastalık ilerlemesi (UI demo).
class HealthProgressView extends ConsumerWidget {
  const HealthProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HealthProgressViewModel vm = HealthProgressViewModel(ref: ref);
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    final String? selected = ref.watch(healthProgressProvider).selectedPlantId;
    final List<_PlantOption> plants = <_PlantOption>[
      _PlantOption(id: 'p1', label: context.l10n.healthProgressPlant1),
      _PlantOption(id: 'p2', label: context.l10n.healthProgressPlant2),
      _PlantOption(id: 'p3', label: context.l10n.healthProgressPlant3),
    ];

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.healthProgressTitle),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(pad, pad, pad, pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SoftElevationCard(
              onTap: null,
              padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.healthProgressSubtitle,
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.palOnSurface,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 10),
                  Text(
                    context.l10n.healthProgressHint,
                    style: tt.bodySmall?.copyWith(color: context.palMuted, height: 1.35),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value),
                  DropdownButtonFormField<String>(
                    value: selected,
                    hint: Text(context.l10n.healthProgressSelectPlant),
                    items: plants
                        .map(
                          (_PlantOption p) => DropdownMenuItem<String>(
                            value: p.id,
                            child: Text(p.label),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) => vm.selectPlant(value),
                  ),
                ],
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Expanded(
              child: SoftElevationCard(
                onTap: null,
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            context.l10n.healthProgressChartTitle,
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: context.palOnSurface,
                            ),
                          ),
                        ),
                        _LegendDot(color: context.palPrimary, label: context.l10n.healthProgressLegendHealth),
                        SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                        _LegendDot(color: context.palAccent, label: context.l10n.healthProgressLegendDisease),
                      ],
                    ),
                    SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                    Expanded(
                      child: _ProgressLineChart(
                        primary: context.palPrimary,
                        accent: context.palAccent,
                        outline: context.palOutline,
                        muted: context.palMuted,
                        data: _demoSeriesFor(selected),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PlantOption {
  const _PlantOption({required this.id, required this.label});
  final String id;
  final String label;
}

final class _ProgressPoint {
  const _ProgressPoint({required this.dayIndex, required this.health, required this.disease});
  final double dayIndex;
  final double health;
  final double disease;
}

List<_ProgressPoint> _demoSeriesFor(String? plantId) {
  switch (plantId) {
    case 'p2':
      return const <_ProgressPoint>[
        _ProgressPoint(dayIndex: 0, health: 82, disease: 18),
        _ProgressPoint(dayIndex: 2, health: 74, disease: 26),
        _ProgressPoint(dayIndex: 4, health: 62, disease: 38),
        _ProgressPoint(dayIndex: 6, health: 58, disease: 42),
        _ProgressPoint(dayIndex: 8, health: 67, disease: 33),
        _ProgressPoint(dayIndex: 10, health: 76, disease: 24),
        _ProgressPoint(dayIndex: 12, health: 84, disease: 16),
      ];
    case 'p3':
      return const <_ProgressPoint>[
        _ProgressPoint(dayIndex: 0, health: 90, disease: 10),
        _ProgressPoint(dayIndex: 2, health: 88, disease: 12),
        _ProgressPoint(dayIndex: 4, health: 86, disease: 14),
        _ProgressPoint(dayIndex: 6, health: 85, disease: 15),
        _ProgressPoint(dayIndex: 8, health: 84, disease: 16),
        _ProgressPoint(dayIndex: 10, health: 83, disease: 17),
        _ProgressPoint(dayIndex: 12, health: 82, disease: 18),
      ];
    case 'p1':
    default:
      return const <_ProgressPoint>[
        _ProgressPoint(dayIndex: 0, health: 70, disease: 30),
        _ProgressPoint(dayIndex: 2, health: 72, disease: 28),
        _ProgressPoint(dayIndex: 4, health: 76, disease: 24),
        _ProgressPoint(dayIndex: 6, health: 80, disease: 20),
        _ProgressPoint(dayIndex: 8, health: 78, disease: 22),
        _ProgressPoint(dayIndex: 10, health: 83, disease: 17),
        _ProgressPoint(dayIndex: 12, health: 88, disease: 12),
      ];
  }
}

class _ProgressLineChart extends StatelessWidget {
  const _ProgressLineChart({
    required this.primary,
    required this.accent,
    required this.outline,
    required this.muted,
    required this.data,
  });

  final Color primary;
  final Color accent;
  final Color outline;
  final Color muted;
  final List<_ProgressPoint> data;

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> healthSpots =
        data.map((_ProgressPoint p) => FlSpot(p.dayIndex, p.health)).toList(growable: false);
    final List<FlSpot> diseaseSpots =
        data.map((_ProgressPoint p) => FlSpot(p.dayIndex, p.disease)).toList(growable: false);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 12,
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          verticalInterval: 2,
          getDrawingHorizontalLine: (double value) => FlLine(
            color: outline.withValues(alpha: 0.35),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (double value) => FlLine(
            color: outline.withValues(alpha: 0.18),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: outline.withValues(alpha: 0.5)),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: WidgetSizesEnum.cardRadius.value * 1.35,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Padding(
                  padding: EdgeInsets.only(right: WidgetSizesEnum.divider.value * 8),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: muted,
                      fontSize: TextSizesEnum.caption.value,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Padding(
                  padding: EdgeInsets.only(top: WidgetSizesEnum.divider.value * 8),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: muted,
                      fontSize: TextSizesEnum.caption.value,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
              reservedSize: WidgetSizesEnum.cardRadius.value * 0.95,
            ),
          ),
        ),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: healthSpots,
            isCurved: true,
            curveSmoothness: 0.22,
            color: primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) {
                return FlDotCirclePainter(
                  radius: 3.2,
                  color: primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  primary.withValues(alpha: 0.16),
                  primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          LineChartBarData(
            spots: diseaseSpots,
            isCurved: true,
            curveSmoothness: 0.22,
            color: accent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) {
                return FlDotCirclePainter(
                  radius: 3.2,
                  color: accent,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  accent.withValues(alpha: 0.14),
                  accent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: WidgetSizesEnum.divider.value * 10,
          height: WidgetSizesEnum.divider.value * 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        SizedBox(width: WidgetSizesEnum.divider.value * 6),
        Text(
          label,
          style: TextStyle(
            color: context.palMuted,
            fontSize: TextSizesEnum.caption.value,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

