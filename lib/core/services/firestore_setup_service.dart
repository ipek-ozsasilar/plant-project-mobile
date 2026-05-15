import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore database yapısını başlatır ve test verisi ekler.
class FirestoreSetupService {
  FirestoreSetupService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// İlk kez login olan kullanıcı için Firestore yapısını hazırlar.
  Future<void> initializeUserData({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      _logger.i('Firestore user initialization starting for uid: $uid');

      // 1. User document zaten var mı kontrol et
      final userDoc = _db.collection(FirestoreCollectionEnum.users.value).doc(uid);
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        _logger.i('User document already exists, skipping initialization');
        return;
      }

      // 2. User profil oluştur
      await _createUserProfile(uid, email, displayName);

      // 3. Sample plants ekle (demo için)
      await _createSamplePlants(uid);

      _logger.i('Firestore user initialization completed');
    } catch (e, st) {
      _logger.e('Firestore initialization failed', e, st);
      rethrow;
    }
  }

  /// Kullanıcı profil belgesi oluşturur.
  Future<void> _createUserProfile(
    String uid,
    String email,
    String displayName,
  ) async {
    try {
      await _db.collection(FirestoreCollectionEnum.users.value).doc(uid).set(
        <String, dynamic>{
          'email': email,
          'displayName': displayName,
          'authProvider': _auth.currentUser?.providerData.isNotEmpty == true
              ? _auth.currentUser!.providerData.first.providerId
              : 'email',
          'photoUrl': _auth.currentUser?.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      _logger.i('User profile created: $uid');
    } catch (e, st) {
      _logger.e('Failed to create user profile', e, st);
      rethrow;
    }
  }

  /// Demo amaçlı örnek bitkiler oluşturur.
  Future<void> _createSamplePlants(String uid) async {
    try {
      final plantsRef = _db.collection(FirestoreCollectionEnum.plants.value);

      // Örnek bitki 1: Monstera
      await plantsRef.doc('monstera_${uid.substring(0, 8)}').set(
        <String, dynamic>{
          'id': 'monstera_${uid.substring(0, 8)}',
          'ownerUid': uid,
          'name': 'Ev Monsteramı',
          'speciesLabel': 'Monstera deliciosa',
          'isFavorite': true,
          'lastHealthScore': 85,
          'lastScanDate': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      // Örnek bitki 2: Ficus
      await plantsRef.doc('ficus_${uid.substring(0, 8)}').set(
        <String, dynamic>{
          'id': 'ficus_${uid.substring(0, 8)}',
          'ownerUid': uid,
          'name': 'Balkon Ficusu',
          'speciesLabel': 'Ficus lyrata',
          'isFavorite': false,
          'lastHealthScore': 72,
          'lastScanDate': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      _logger.i('Sample plants created for user: $uid');
    } catch (e, st) {
      _logger.e('Failed to create sample plants', e, st);
      rethrow;
    }
  }

  /// Örnek tarama kaydı oluşturur (belirli bir bitki için).
  Future<void> createSampleScan({
    required String uid,
    required String plantId,
  }) async {
    try {
      final scanId = 'scan_${DateTime.now().millisecondsSinceEpoch}';
      await _db.collection(FirestoreCollectionEnum.scans.value).doc(scanId).set(
        <String, dynamic>{
          'id': scanId,
          'ownerUid': uid,
          'plantId': plantId,
          'createdAt': FieldValue.serverTimestamp(),
          'speciesLabel': 'Monstera deliciosa',
          'speciesConfidence': 0.96,
          'diseaseKey': 'healthy',
          'diseaseConfidence': 0.99,
          'healthScore': 88,
        },
      );
      _logger.i('Sample scan created: $scanId');
    } catch (e, st) {
      _logger.e('Failed to create sample scan', e, st);
      rethrow;
    }
  }

  /// Tüm kullanıcı verilerini siler (debug/test için).
  Future<void> deleteAllUserData({required String uid}) async {
    try {
      _logger.w('Deleting all data for user: $uid');

      // Scans sil
      final scans = await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .where('ownerUid', isEqualTo: uid)
          .get();
      for (final doc in scans.docs) {
        await doc.reference.delete();
      }

      // Plants sil
      final plants = await _db
          .collection(FirestoreCollectionEnum.plants.value)
          .where('ownerUid', isEqualTo: uid)
          .get();
      for (final doc in plants.docs) {
        await doc.reference.delete();
      }

      // User sil
      await _db.collection(FirestoreCollectionEnum.users.value).doc(uid).delete();

      _logger.i('All user data deleted');
    } catch (e, st) {
      _logger.e('Failed to delete user data', e, st);
      rethrow;
    }
  }
}
