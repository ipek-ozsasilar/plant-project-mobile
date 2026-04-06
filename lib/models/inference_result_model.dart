import 'package:equatable/equatable.dart';

/// Tek bir tahmin sınıfı ve güven skoru.
class InferenceClassScoreModel extends Equatable {
  const InferenceClassScoreModel({
    required this.label,
    required this.confidence,
    this.rawKey,
  });

  final String label;
  final double confidence;

  /// Model `class_names.json` satırı (örn. `plantnet__1355868`). Tercih ve katalog için ham anahtar.
  final String? rawKey;

  @override
  List<Object?> get props => <Object?>[label, confidence, rawKey];
}

/// Tür veya hastalık servisinden dönen özet sonuç.
class InferenceResultModel extends Equatable {
  const InferenceResultModel({
    required this.top,
    this.alternatives = const <InferenceClassScoreModel>[],
  });

  final InferenceClassScoreModel top;
  final List<InferenceClassScoreModel> alternatives;

  @override
  List<Object?> get props => <Object?>[top, alternatives];
}
