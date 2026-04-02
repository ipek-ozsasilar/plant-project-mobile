import 'package:equatable/equatable.dart';

/// Tek bir tahmin sınıfı ve güven skoru.
class InferenceClassScoreModel extends Equatable {
  const InferenceClassScoreModel({
    required this.label,
    required this.confidence,
  });

  final String label;
  final double confidence;

  @override
  List<Object?> get props => <Object?>[label, confidence];
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
