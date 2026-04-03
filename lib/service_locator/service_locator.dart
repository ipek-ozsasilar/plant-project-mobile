import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/services/google_sign_in_service.dart';
import 'package:bitirme_mobile/core/services/user_profile_firestore_service.dart';
import 'package:bitirme_mobile/core/services/image_crop_service.dart';
import 'package:bitirme_mobile/core/services/inference_api_service.dart';
import 'package:bitirme_mobile/core/services/scan_history_service.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<AppLogger>(() => AppLogger());
  sl.registerLazySingleton<AuthStorageService>(
    () => AuthStorageService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ScanHistoryService>(
    () => ScanHistoryService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<ImageCropService>(
    () => ImageCropService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<InferenceApiService>(
    () => InferenceApiService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<GoogleSignInService>(
    () => GoogleSignInService(logger: sl<AppLogger>()),
  );
  sl.registerLazySingleton<UserProfileFirestoreService>(
    () => UserProfileFirestoreService(logger: sl<AppLogger>()),
  );
}
