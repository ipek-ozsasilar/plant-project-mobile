import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.historyTitle)),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 2),
                child: Text(
                  context.l10n.historyEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TextSizesEnum.body.value,
                    color: context.palMuted,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: WidgetSizesEnum.divider.value * 4),
              itemBuilder: (BuildContext context, int index) {
                final ScanRecordModel e = items[index];
                final String diseaseLine =
                    displayStoredDiseaseLabel(e.diseaseLabel, context.l10n);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.palPrimary.withValues(alpha: 0.14),
                      child: Icon(Icons.eco, color: context.palPrimary),
                    ),
                    title: Text(
                      e.speciesLabel,
                      style: TextStyle(fontSize: TextSizesEnum.subtitle.value),
                    ),
                    subtitle: Text(
                      '${fmt.format(e.createdAt)}\n$diseaseLine '
                      '(${confidencePercentLabel(e.diseaseConfidence)})',
                      style: TextStyle(fontSize: TextSizesEnum.caption.value),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
