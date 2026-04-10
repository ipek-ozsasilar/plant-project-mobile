/// Sınıflandırma sonucunu "tanınamadı" saymak için eşikler.
enum InferenceThresholdEnum {
  /// Genel "tanımlanamadı" eşiği (0–1).
  ///
  /// Kural: confidence < %60 → "Tanımlanamadı"
  unrecognizedGlobal(0.60),

  /// "Sink" (kolay seçilen) sınıflar için daha sıkı eşik (0–1).
  ///
  /// Kural: sink sınıfı && confidence < %78 → "Tanımlanamadı"
  unrecognizedSink(0.78);

  const InferenceThresholdEnum(this.value);
  final double value;
}

