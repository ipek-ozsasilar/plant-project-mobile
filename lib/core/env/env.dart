import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'http://127.0.0.1:8000')
  static const String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'USE_MOCK_INFERENCE', defaultValue: 'true')
  static const String useMockInferenceRaw = _Env.useMockInferenceRaw;

  /// `false` iken ve mock kapalıyken HTTP API; `true` iken assets/ml içindeki TFLite modelleri.
  @EnviedField(varName: 'USE_LOCAL_TFLITE', defaultValue: 'true')
  static const String useLocalTfliteRaw = _Env.useLocalTfliteRaw;

  /// Firebase Console → Proje ayarları → Genel → Web uygulaması OAuth istemci kimliği
  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID', defaultValue: '')
  static const String googleWebClientId = _Env.googleWebClientId;

  static bool get useMockInference => useMockInferenceRaw.toLowerCase() == 'true';

  static bool get useLocalTflite => useLocalTfliteRaw.toLowerCase() == 'true';
}
