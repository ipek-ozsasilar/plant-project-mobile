import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Kullanıcının bitki koleksiyonunu yöneten Firestore servisi.
class PlantsFirestoreService {
  PlantsFirestoreService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Kullanıcının tüm bitkilerini en yeniden eskiye doğru listeler.
  Future<List<PlantModel>> listPlants({required String ownerUid}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.plants.value)
          .where('ownerUid', isEqualTo: ownerUid)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => PlantModel.fromJson(d.data()))
          .whereType<PlantModel>()
          .toList(growable: false);
    } catch (e, st) {
      _logger.e('Firestore list plants error', e, st);
      return <PlantModel>[];
    }
  }

  /// Kullanıcının favori bitkilerini listeler.
  Future<List<PlantModel>> listFavorites({required String ownerUid}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.plants.value)
          .where('ownerUid', isEqualTo: ownerUid)
          .where('isFavorite', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => PlantModel.fromJson(d.data()))
          .whereType<PlantModel>()
          .toList(growable: false);
    } catch (e, st) {
      _logger.e('Firestore list favorite plants error', e, st);
      return <PlantModel>[];
    }
  }

  /// Bitki bilgisini kaydeder veya günceller (merge: true).
  Future<void> upsertPlant(PlantModel plant) async {
    try {
      final Map<String, dynamic> data = plant.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _db
          .collection(FirestoreCollectionEnum.plants.value)
          .doc(plant.id)
          .set(data, SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore upsert plant error', e, st);
      rethrow;
    }
  }

  /// Bitkiyi siler.
  Future<void> deletePlant(String plantId) async {
    try {
      await _db.collection(FirestoreCollectionEnum.plants.value).doc(plantId).delete();
    } catch (e, st) {
      _logger.e('Firestore delete plant error', e, st);
      rethrow;
    }
  }
}