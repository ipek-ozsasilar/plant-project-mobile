import 'package:bitirme_mobile/core/services/plant_scans_firestore_service.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestore'daki tüm kullanıcı taramalarını (bitkiye bağlı olsun olmasın) çeker.
final historyFirestoreProvider = FutureProvider<List<PlantScanModel>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final uid = authState.uid;
  if (uid == null) return <PlantScanModel>[];

  final scansService = sl<PlantScansFirestoreService>();
  return scansService.listUserScans(ownerUid: uid);
});
