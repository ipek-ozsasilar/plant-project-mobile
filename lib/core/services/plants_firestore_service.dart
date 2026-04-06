import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Bitki koleksiyonu: [plants] koleksiyonunda kullanıcı bazlı kayıt.
class PlantsFirestoreService {
  PlantsFirestoreService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
      _logger.e('Firestore list plants', e, st);
      return <PlantModel>[];
    }
  }

  Future<void> upsertPlant(PlantModel plant) async {
    try {
      await _db
          .collection(FirestoreCollectionEnum.plants.value)
          .doc(plant.id)
          .set(plant.toJson(), SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore upsert plant', e, st);
    }
  }

  Future<void> deletePlant({required String plantId}) async {
    try {
      await _db.collection(FirestoreCollectionEnum.plants.value).doc(plantId).delete();
    } catch (e, st) {
      _logger.e('Firestore delete plant', e, st);
    }
  }
}

