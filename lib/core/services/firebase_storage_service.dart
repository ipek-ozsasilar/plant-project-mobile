import 'dart:typed_data';

import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage upload/download yardımcı servisi.
class FirebaseStorageService {
  FirebaseStorageService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadJpegBytes({
    required String path,
    required Uint8List bytes,
  }) async {
    try {
      final Reference ref = _storage.ref(path);
      final SettableMetadata meta = SettableMetadata(contentType: 'image/jpeg');
      final UploadTask task = ref.putData(bytes, meta);
      final TaskSnapshot snap = await task;
      return await snap.ref.getDownloadURL();
    } catch (e, st) {
      _logger.e('storage_upload', e, st);
      return null;
    }
  }
}

