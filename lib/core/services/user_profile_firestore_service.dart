import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// [users/{uid}] belgesinde profil senkronizasyonu.
class UserProfileFirestoreService {
  UserProfileFirestoreService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> upsertFromFirebaseUser(
    User user, {
    required String authProvider,
  }) async {
    try {
      final String uid = user.uid;
      final String email = user.email ?? '';
      final String displayName = user.displayName ??
          (email.contains('@') ? email.split('@').first : email);
      final DocumentReference<Map<String, dynamic>> ref =
          _db.collection(FirestoreCollectionEnum.users.value).doc(uid);
      final DocumentSnapshot<Map<String, dynamic>> snap = await ref.get();
      final Map<String, dynamic> data = <String, dynamic>{
        'email': email,
        'displayName': displayName,
        'authProvider': authProvider,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (!snap.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }
      await ref.set(data, SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore user upsert', e, st);
    }
  }
}
