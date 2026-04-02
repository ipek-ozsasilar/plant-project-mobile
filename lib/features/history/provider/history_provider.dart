import 'package:bitirme_mobile/core/services/scan_history_service.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Geçmiş taramalar listesi.
class HistoryNotifier extends Notifier<List<ScanRecordModel>> {
  @override
  List<ScanRecordModel> build() {
    return <ScanRecordModel>[];
  }

  Future<void> load() async {
    final ScanHistoryService svc = sl<ScanHistoryService>();
    final List<ScanRecordModel> items = await svc.loadRecords();
    state = items;
  }

  Future<void> addRecord(ScanRecordModel record) async {
    final ScanHistoryService svc = sl<ScanHistoryService>();
    await svc.addRecord(record);
    await load();
  }
}

final NotifierProvider<HistoryNotifier, List<ScanRecordModel>> historyProvider =
    NotifierProvider<HistoryNotifier, List<ScanRecordModel>>(HistoryNotifier.new);
