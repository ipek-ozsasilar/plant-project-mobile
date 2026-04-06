/// Sınıflandırma sonucunu "tanınamadı" saymak için eşikler.
enum InferenceThresholdEnum {
  /// Tür/hastalık sonucunu gösterme alt sınırı (0–1).
  unrecognized(0.30);

  const InferenceThresholdEnum(this.value);
  final double value;
}

