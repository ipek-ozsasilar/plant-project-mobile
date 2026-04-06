import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Bitki taramaları: [scans] koleksiyonunda kullanıcı+bitki bazlı kayıt.
class PlantScansFirestoreService {
  PlantScansFirestoreService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<PlantScanModel>> listScans({
    required String ownerUid,
    required String plantId,
    int limit = 60,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .where('ownerUid', isEqualTo: ownerUid)
          .where('plantId', isEqualTo: plantId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => PlantScanModel.fromJson(d.data()))
          .whereType<PlantScanModel>()
          .toList(growable: false);
    } catch (e, st) {
      _logger.e('Firestore list scans', e, st);
      return <PlantScanModel>[];
    }
  }

  Future<void> addScan(PlantScanModel scan) async {
    try {
      await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .doc(scan.id)
          .set(scan.toJson());
    } catch (e, st) {
      _logger.e('Firestore add scan', e, st);
    }
  }
}

