import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitirme_mobile/core/env/env.dart';
import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:http/http.dart' as http;

/// Bitki türü ve hastalık tahmini için API veya mock uygulaması.
class InferenceApiService {
  InferenceApiService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final Random _random = Random();

  static const List<String> _mockSpecies = <String>[
    'Domates',
    'Biber',
    'Patlıcan',
    'Salatalık',
    'Marul',
    'Çilek',
    'Gül',
    'Lavanta',
  ];

  static const List<String> _mockDiseases = <String>[
    'Sağlıklı / belirsiz',
    'Yaprak lekesi',
    'Külleme',
    'Pas hastalığı',
    'Kurumaya bağlı stres',
    'Mosaic virüs belirtileri',
  ];

  Future<InferenceResultModel> predictSpecies(Uint8List imageBytes) async {
    if (Env.useMockInference) {
      return _mockResult(_mockSpecies);
    }
    try {
      final Uri uri = Uri.parse('${Env.apiBaseUrl}/predict/species');
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'crop.jpg',
        ),
      );
      final http.StreamedResponse streamed = await request.send();
      final String body = await streamed.stream.bytesToString();
      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return _parseInferenceJson(body);
      }
      throw Exception('HTTP ${streamed.statusCode}');
    } catch (e, st) {
      _logger.e(ErrorStringsEnum.inference.value, e, st);
      rethrow;
    }
  }

  Future<InferenceResultModel> predictDisease(Uint8List imageBytes) async {
    if (Env.useMockInference) {
      return _mockResult(_mockDiseases);
    }
    try {
      final Uri uri = Uri.parse('${Env.apiBaseUrl}/predict/disease');
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'crop.jpg',
        ),
      );
      final http.StreamedResponse streamed = await request.send();
      final String body = await streamed.stream.bytesToString();
      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return _parseInferenceJson(body);
      }
      throw Exception('HTTP ${streamed.statusCode}');
    } catch (e, st) {
      _logger.e(ErrorStringsEnum.inference.value, e, st);
      rethrow;
    }
  }

  InferenceResultModel _mockResult(List<String> labels) {
    final int topIdx = _random.nextInt(labels.length);
    final String topLabel = labels[topIdx];
    final double topConf = 0.55 + _random.nextDouble() * 0.44;
    final List<InferenceClassScoreModel> alt = <InferenceClassScoreModel>[];
    for (int i = 0; i < labels.length && i < 4; i++) {
      if (i == topIdx) {
        continue;
      }
      alt.add(
        InferenceClassScoreModel(
          label: labels[i],
          confidence: _random.nextDouble() * 0.4,
        ),
      );
    }
    return InferenceResultModel(
      top: InferenceClassScoreModel(label: topLabel, confidence: topConf),
      alternatives: alt,
    );
  }

  InferenceResultModel _parseInferenceJson(String body) {
    final Object? decoded = json.decode(body);
    if (decoded is! Map<String, Object?>) {
      throw FormatException('Invalid JSON', body);
    }
    final String? topLabel = decoded['label'] as String? ?? decoded['top_label'] as String?;
    final num? topConf = decoded['confidence'] as num? ?? decoded['score'] as num?;
    if (topLabel == null || topConf == null) {
      throw FormatException('Missing fields', body);
    }
    return InferenceResultModel(
      top: InferenceClassScoreModel(
        label: topLabel,
        confidence: topConf.toDouble(),
      ),
    );
  }
}
