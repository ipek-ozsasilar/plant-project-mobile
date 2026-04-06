import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/pdf_report_service.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

/// Geçmiş taramalar listesi.
class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ScanRecordModel> items = ref.watch(historyProvider);
    final String loc = Localizations.localeOf(context).languageCode;
    final DateFormat fmt = DateFormat.yMMMd(loc);
    final DateFormat timeFmt = DateFormat.Hm(loc);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.historyTitle),
        actions: <Widget>[
          IconButton(
            tooltip: context.l10n.search,
            onPressed: null,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: items.isEmpty
          ? ListView(
              padding: EdgeInsets.fromLTRB(pad, pad, pad, WidgetSizesEnum.bottomNavHeight.value),
              children: <Widget>[
                Text(
                  context.l10n.historyHeadline,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 8),
                Text(
                  context.l10n.historySubtitle,
                  style: tt.bodyLarge?.copyWith(
                    color: context.palMuted,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                SoftElevationCard(
                  onTap: null,
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: WidgetSizesEnum.cardRadius.value * 2.1,
                            height: WidgetSizesEnum.cardRadius.value * 2.1,
                            decoration: BoxDecoration(
                              color: context.palPrimarySoftBg,
                              borderRadius:
                                  BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                            ),
                            child: Icon(Icons.history_rounded, color: context.palPrimary),
                          ),
                          SizedBox(width: WidgetSizesEnum.cardRadius.value),
                          Expanded(
                            child: Text(
                              context.l10n.historyEmpty,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: context.palOnSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value),
                      Text(
                        context.l10n.homeEmptySubtitle,
                        style: tt.bodyMedium?.copyWith(
                          color: context.palMuted,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value),
                      Row(
                        children: <Widget>[
                          Icon(Icons.arrow_forward_rounded,
                              color: context.palPrimary, size: IconSizesEnum.small.value),
                          SizedBox(width: WidgetSizesEnum.divider.value * 6),
                          Text(
                            context.l10n.homeStartScan,
                            style: tt.labelLarge?.copyWith(
                              color: context.palPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(pad, pad, pad, WidgetSizesEnum.bottomNavHeight.value),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final ScanRecordModel e = items[index];
                final bool showHeader = index == 0 || !_sameDay(items[index - 1].createdAt, e.createdAt);
                final String diseaseLine = displayStoredDiseaseLabel(e.diseaseLabel, context.l10n);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (index == 0) ...<Widget>[
                      Text(
                        context.l10n.historyHeadline,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.palOnSurface,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.divider.value * 8),
                      Text(
                        context.l10n.historySubtitle,
                        style: tt.bodyLarge?.copyWith(
                          color: context.palMuted,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                    ],
                    if (showHeader) ...<Widget>[
                      SizedBox(height: index == 0 ? 0 : WidgetSizesEnum.cardRadius.value * 0.85),
                      Text(
                        fmt.format(e.createdAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: context.palOnSurface,
                          fontSize: TextSizesEnum.subtitle.value,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                    ],
                    _TimelineRow(
                      isFirstOfDay: showHeader,
                      isLast: index == items.length - 1,
                      child: SoftElevationCard(
                        onTap: () => _openActions(context, e),
                        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: WidgetSizesEnum.cardRadius.value * 2.2,
                              height: WidgetSizesEnum.cardRadius.value * 2.2,
                              decoration: BoxDecoration(
                                color: context.palPrimary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                              ),
                              child: Icon(Icons.eco_rounded, color: context.palPrimary),
                            ),
                            SizedBox(width: WidgetSizesEnum.cardRadius.value),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          speciesClassDisplayForRaw(context, e.speciesLabel),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: context.palOnSurface,
                                            fontSize: TextSizesEnum.subtitle.value,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        timeFmt.format(e.createdAt),
                                        style: TextStyle(
                                          color: context.palMuted,
                                          fontWeight: FontWeight.w800,
                                          fontSize: TextSizesEnum.caption.value,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: WidgetSizesEnum.divider.value * 8),
                                  Text(
                                    '$diseaseLine (${confidencePercentLabel(e.diseaseConfidence)})',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: context.palMuted,
                                      fontWeight: FontWeight.w600,
                                      fontSize: TextSizesEnum.caption.value,
                                      height: 1.25,
                                    ),
                                  ),
                                  SizedBox(height: WidgetSizesEnum.divider.value * 10),
                                  Row(
                                    children: <Widget>[
                                      _ActionChip(
                                        icon: Icons.spa_rounded,
                                        label: context.l10n.scanSpeciesTitle,
                                        onTap: () => context.push(
                                          '${AppPaths.speciesDetail}/${Uri.encodeComponent(e.speciesLabel)}'
                                          '?confidence=${e.speciesConfidence}',
                                        ),
                                      ),
                                      SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.65),
                                      _ActionChip(
                                        icon: Icons.healing_rounded,
                                        label: context.l10n.scanDiseaseTitle,
                                        onTap: () => context.push(
                                          '${AppPaths.diseaseDetail}/${Uri.encodeComponent(e.diseaseLabel)}'
                                          '?confidence=${e.diseaseConfidence}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.5),
                            Icon(Icons.more_horiz_rounded, color: context.palMuted),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _openActions(BuildContext context, ScanRecordModel e) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
        final String diseaseLine = displayStoredDiseaseLabel(e.diseaseLabel, context.l10n);
        return Padding(
          padding: EdgeInsets.fromLTRB(pad, pad, pad, pad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                speciesClassDisplayForRaw(context, e.speciesLabel),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: TextSizesEnum.subtitle.value,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 8),
              Text(
                diseaseLine,
                style: TextStyle(color: context.palMuted, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              SoftElevationCard(
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push(
                    '${AppPaths.speciesDetail}/${Uri.encodeComponent(e.speciesLabel)}?confidence=${e.speciesConfidence}',
                  );
                },
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.9),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.spa_rounded, color: context.palPrimary),
                    SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                    Expanded(child: Text(context.l10n.scanSpeciesTitle)),
                    Icon(Icons.chevron_right_rounded, color: context.palMuted),
                  ],
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
              SoftElevationCard(
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push(
                    '${AppPaths.diseaseDetail}/${Uri.encodeComponent(e.diseaseLabel)}?confidence=${e.diseaseConfidence}',
                  );
                },
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.9),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.healing_rounded, color: context.palAccent),
                    SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                    Expanded(child: Text(context.l10n.scanDiseaseTitle)),
                    Icon(Icons.chevron_right_rounded, color: context.palMuted),
                  ],
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
              SoftElevationCard(
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final PdfReportService pdf = sl<PdfReportService>();
                  final Uint8List bytes =
                      await pdf.buildScanReportPdf(record: e, l10n: context.l10n);
                  await Printing.sharePdf(bytes: bytes, filename: 'phytoguard_report.pdf');
                },
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.9),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.picture_as_pdf_rounded, color: context.palPrimary),
                    SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                    Expanded(child: Text(context.l10n.scanExportPdfCta)),
                    Icon(Icons.chevron_right_rounded, color: context.palMuted),
                  ],
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
              OutlinedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(context.l10n.cancel),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.child,
    required this.isFirstOfDay,
    required this.isLast,
  });

  final Widget child;
  final bool isFirstOfDay;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final double dot = WidgetSizesEnum.divider.value * 10;
    final double lineX = (dot / 2);
    return Padding(
      padding: EdgeInsets.only(bottom: WidgetSizesEnum.cardRadius.value * 0.85),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: WidgetSizesEnum.cardRadius.value,
            child: Stack(
              children: <Widget>[
                if (!isLast)
                  Positioned(
                    left: lineX,
                    top: isFirstOfDay ? dot : 0,
                    bottom: 0,
                    child: Container(
                      width: WidgetSizesEnum.divider.value * 2,
                      color: context.palOutline.withValues(alpha: 0.35),
                    ),
                  ),
                Positioned(
                  left: 0,
                  top: isFirstOfDay ? 0 : (dot * 0.35),
                  child: Container(
                    width: dot,
                    height: dot,
                    decoration: BoxDecoration(
                      color: context.palPrimary,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: context.palPrimary.withValues(alpha: 0.25),
                          blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
      child: Ink(
        padding: EdgeInsets.symmetric(
          horizontal: WidgetSizesEnum.cardRadius.value * 0.65,
          vertical: WidgetSizesEnum.divider.value * 10,
        ),
        decoration: BoxDecoration(
          color: context.palPrimarySoftBg,
          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
          border: Border.all(color: context.palOutline.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: IconSizesEnum.small.value, color: context.palPrimary),
            SizedBox(width: WidgetSizesEnum.divider.value * 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: context.palOnSurface,
                fontSize: TextSizesEnum.caption.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
