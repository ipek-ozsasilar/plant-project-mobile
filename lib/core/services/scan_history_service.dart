import 'dart:convert';

import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tarama geçmişini yerel olarak saklar.
class ScanHistoryService {
  ScanHistoryService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  static const String _keyRecords = 'scan_records_json';

  Future<List<ScanRecordModel>> loadRecords() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_keyRecords);
      if (raw == null || raw.isEmpty) {
        return <ScanRecordModel>[];
      }
      final Object? decoded = json.decode(raw);
      if (decoded is! List<Object?>) {
        return <ScanRecordModel>[];
      }
      final List<ScanRecordModel> out = <ScanRecordModel>[];
      for (final Object? item in decoded) {
        if (item is Map<String, dynamic>) {
          final ScanRecordModel? m = ScanRecordModel.fromJson(item);
          if (m != null) {
            out.add(m);
          }
        }
      }
      out.sort((ScanRecordModel a, ScanRecordModel b) => b.createdAt.compareTo(a.createdAt));
      return out;
    } catch (e, st) {
      _logger.e('scan_history_storage', e, st);
      return <ScanRecordModel>[];
    }
  }

  Future<void> addRecord(ScanRecordModel record) async {
    try {
      final List<ScanRecordModel> list = await loadRecords();
      list.insert(0, record);
      final List<Map<String, Object?>> encoded =
          list.map((ScanRecordModel e) => e.toJson()).toList();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyRecords, json.encode(encoded));
    } catch (e, st) {
      _logger.e('scan_history_storage', e, st);
    }
  }

  Future<void> clear() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyRecords);
    } catch (e, st) {
      _logger.e('scan_history_storage', e, st);
    }
  }
}
