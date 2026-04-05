import 'dart:convert';
import 'dart:math';
import 'package:bitirme_mobile/core/enums/ml_assets_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/species_label_formatter.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Yerel [plant_species_model] / [plant_disease_model] TFLite çıkarımı.
class TflitePlantInferenceService {
  TflitePlantInferenceService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  Interpreter? _speciesInterpreter;
  Interpreter? _diseaseInterpreter;
  List<String>? _speciesLabels;
  List<String>? _diseaseLabels;
  Future<void>? _initFuture;

  Future<void> _ensureReady() async {
    _initFuture ??= _loadAll();
    await _initFuture;
  }

  Future<void> _loadAll() async {
    try {
      final String speciesJson = await rootBundle.loadString(MlAssetsEnum.speciesLabelsJson.value);
      final String diseaseJson = await rootBundle.loadString(MlAssetsEnum.diseaseLabelsJson.value);
      final Object? spDec = json.decode(speciesJson);
      final Object? dsDec = json.decode(diseaseJson);
      if (spDec is! List<dynamic> || dsDec is! List<dynamic>) {
        throw const FormatException('Sınıf JSON beklenen formatta değil.');
      }
      _speciesLabels = spDec.map((dynamic e) => e.toString()).toList();
      _diseaseLabels = dsDec.map((dynamic e) => e.toString()).toList();

      final InterpreterOptions opts = InterpreterOptions()..threads = 4;
      _speciesInterpreter = await Interpreter.fromAsset(
        MlAssetsEnum.speciesModel.value,
        options: opts,
      );
      _diseaseInterpreter = await Interpreter.fromAsset(
        MlAssetsEnum.diseaseModel.value,
        options: opts,
      );
    } catch (e, st) {
      _logger.e('TFLite yükleme', e, st);
      rethrow;
    }
  }

  Future<InferenceResultModel> predictSpecies(Uint8List imageBytes) async {
    await _ensureReady();
    final Interpreter i = _speciesInterpreter!;
    final List<String> labels = _speciesLabels!;
    return _runClassification(
      interpreter: i,
      rawLabels: labels,
      imageBytes: imageBytes,
      formatLabel: formatSpeciesRawLabel,
    );
  }

  Future<InferenceResultModel> predictDisease(Uint8List imageBytes) async {
    await _ensureReady();
    final Interpreter i = _diseaseInterpreter!;
    final List<String> labels = _diseaseLabels!;
    return _runClassification(
      interpreter: i,
      rawLabels: labels,
      imageBytes: imageBytes,
      formatLabel: (String raw) => raw,
    );
  }

  InferenceResultModel _runClassification({
    required Interpreter interpreter,
    required List<String> rawLabels,
    required Uint8List imageBytes,
    required String Function(String raw) formatLabel,
  }) {
    final img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw FormatException('Görüntü çözülemedi.');
    }

    final Tensor inputTensor = interpreter.getInputTensor(0);
    final Tensor outputTensor = interpreter.getOutputTensor(0);
    final List<int> inShape = List<int>.from(inputTensor.shape);
    for (int i = 0; i < inShape.length; i++) {
      if (inShape[i] < 0) {
        inShape[i] = 224;
      }
    }
    final List<int> outShape = List<int>.from(outputTensor.shape);
    final TensorType inType = inputTensor.type;

    final int? h = _spatialSize(inShape, isHeight: true);
    final int? w = _spatialSize(inShape, isHeight: false);
    if (h == null || w == null) {
      throw StateError('Model giriş şekli desteklenmiyor: $inShape');
    }

    final img.Image resized = img.copyResize(decoded, width: w, height: h, interpolation: img.Interpolation.linear);
    final Object input = _buildInputNesting(
      shape: inShape,
      image: resized,
      tensorType: inType,
    );

    final Object output = _allocOutputBuffer(outShape, outputTensor.type);
    interpreter.run(input, output);

    List<double> scores = _flattenOutput(output, outShape);
    if (scores.isEmpty) {
      throw StateError('Model çıktısı boş.');
    }

    if (!_looksLikeProbabilities(scores)) {
      scores = _softmax(scores);
    }

    final int n = min(rawLabels.length, scores.length);
    if (rawLabels.length != scores.length) {
      _logger.w(
        'Sınıf sayısı (${rawLabels.length}) ile çıktı boyutu (${scores.length}) farklı; ilk $n eşleştiriliyor.',
      );
    }

    final List<int> order = List<int>.generate(n, (int i) => i);
    order.sort((int a, int b) => scores[b].compareTo(scores[a]));

    final int topIdx = order.first;
    final String rawTop = rawLabels[topIdx];
    final InferenceClassScoreModel top = InferenceClassScoreModel(
      label: formatLabel(rawTop),
      confidence: scores[topIdx].clamp(0.0, 1.0),
    );

    final List<InferenceClassScoreModel> alternatives = <InferenceClassScoreModel>[];
    for (int k = 1; k < order.length && alternatives.length < 4; k++) {
      final int idx = order[k];
      alternatives.add(
        InferenceClassScoreModel(
          label: formatLabel(rawLabels[idx]),
          confidence: scores[idx].clamp(0.0, 1.0),
        ),
      );
    }

    return InferenceResultModel(top: top, alternatives: alternatives);
  }

  static int? _spatialSize(List<int> shape, {required bool isHeight}) {
    if (shape.length == 4) {
      if (shape[1] == 3 || shape[1] == 1) {
        return isHeight ? _positiveOrNull(shape[2]) : _positiveOrNull(shape[3]);
      }
      if (shape[3] == 3 || shape[3] == 1) {
        return isHeight ? _positiveOrNull(shape[1]) : _positiveOrNull(shape[2]);
      }
    }
    return null;
  }

  static int? _positiveOrNull(int v) {
    if (v <= 0) {
      return null;
    }
    return v;
  }

  Object _buildInputNesting({
    required List<int> shape,
    required img.Image image,
    required TensorType tensorType,
  }) {
    if (shape.length != 4) {
      throw StateError('4 boyutlu giriş bekleniyordu: $shape');
    }
    final bool nchw = shape[1] == 3 || shape[1] == 1;
    final int h = nchw ? shape[2] : shape[1];
    final int w = nchw ? shape[3] : shape[2];
    final bool useFloat = tensorType == TensorType.float32;

    double packCh(num v) {
      if (useFloat) {
        return (v.toDouble() / 255.0).clamp(0.0, 1.0);
      }
      return v.toDouble().clamp(0.0, 255.0);
    }

    if (nchw && shape[1] == 1) {
      return List<List<List<List<double>>>>.generate(
        1,
        (_) => List<List<List<double>>>.generate(
          1,
          (_) => List<List<double>>.generate(
            h,
            (int y) => List<double>.generate(
              w,
              (int x) {
                final dynamic px = image.getPixel(x, y);
                final double g = (px.r + px.g + px.b) / 3.0;
                return packCh(g);
              },
            ),
          ),
        ),
      );
    }

    if (nchw) {
      return List<List<List<List<double>>>>.generate(
        1,
        (_) => List<List<List<double>>>.generate(
          3,
          (int c) => List<List<double>>.generate(
            h,
            (int y) => List<double>.generate(
              w,
              (int x) {
                final dynamic px = image.getPixel(x, y);
                final num r = px.r;
                final num g = px.g;
                final num b = px.b;
                if (c == 0) {
                  return packCh(r);
                }
                if (c == 1) {
                  return packCh(g);
                }
                return packCh(b);
              },
            ),
          ),
        ),
      );
    }

    return List<List<List<List<double>>>>.generate(
      1,
      (_) => List<List<List<double>>>.generate(
        h,
        (int y) => List<List<double>>.generate(
          w,
          (int x) {
            final dynamic px = image.getPixel(x, y);
            return <double>[
              packCh(px.r),
              packCh(px.g),
              packCh(px.b),
            ];
          },
        ),
      ),
    );
  }

  Object _allocOutputBuffer(List<int> shape, TensorType type) {
    if (shape.length == 2) {
      final int a = shape[0] < 1 ? 1 : shape[0];
      final int b = shape[1];
      return List<List<double>>.generate(
        a,
        (_) => List<double>.filled(b, 0.0),
      );
    }
    if (shape.length == 1) {
      return List<double>.filled(shape[0], 0.0);
    }
    throw StateError('Çıktı şekli desteklenmiyor: $shape');
  }

  List<double> _flattenOutput(Object output, List<int> shape) {
    if (shape.length == 2) {
      final List<dynamic> row = (output as List<dynamic>)[0] as List<dynamic>;
      return row.map((dynamic e) => (e as num).toDouble()).toList();
    }
    if (shape.length == 1) {
      final List<dynamic> row = output as List<dynamic>;
      return row.map((dynamic e) => (e as num).toDouble()).toList();
    }
    return <double>[];
  }

  bool _looksLikeProbabilities(List<double> s) {
    if (s.isEmpty) {
      return false;
    }
    final double sum = s.fold<double>(0, (double a, double b) => a + b);
    if ((sum - 1.0).abs() > 0.08) {
      return false;
    }
    for (final double e in s) {
      if (e < -0.01 || e > 1.01) {
        return false;
      }
    }
    return true;
  }

  List<double> _softmax(List<double> logits) {
    if (logits.isEmpty) {
      return logits;
    }
    final double m = logits.reduce(max);
    final List<double> ex = logits.map((double e) => exp(e - m)).toList();
    final double s = ex.fold<double>(0, (double a, double b) => a + b);
    if (s <= 0) {
      return logits;
    }
    return ex.map((double e) => e / s).toList();
  }

  void close() {
    _speciesInterpreter?.close();
    _diseaseInterpreter?.close();
    _speciesInterpreter = null;
    _diseaseInterpreter = null;
    _initFuture = null;
  }
}
