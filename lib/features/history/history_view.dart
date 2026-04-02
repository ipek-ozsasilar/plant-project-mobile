import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
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
    final DateFormat fmt = DateFormat.yMMMd('tr');

    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.historyTitle.value)),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 2),
                child: Text(
                  StringsEnum.historyEmpty.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TextSizesEnum.body.value,
                    color: ColorName.onSurfaceMuted,
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
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorName.primary.withValues(alpha: 0.12),
                      child: Icon(Icons.eco, color: ColorName.primary),
                    ),
                    title: Text(
                      e.speciesLabel,
                      style: TextStyle(fontSize: TextSizesEnum.subtitle.value),
                    ),
                    subtitle: Text(
                      '${fmt.format(e.createdAt)}\n${e.diseaseLabel} '
                      '(${(e.diseaseConfidence * 100).toStringAsFixed(0)}%)',
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
