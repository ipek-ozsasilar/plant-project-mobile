/// Hastalık anahtarı + güven skorundan 0..100 sağlık skoru üretir.
///
/// MVP: "healthy" yüksek, diğerleri düşük skor verir; güven skoru ile ağırlıklandırılır.
int computeHealthScore({
  required String diseaseKey,
  required double diseaseConfidenceUnit,
}) {
  final double conf = diseaseConfidenceUnit.clamp(0.0, 1.0);
  final bool isHealthy = diseaseKey == 'healthy';

  final double base = isHealthy ? 92.0 : 42.0;
  final double swing = isHealthy ? 8.0 : 28.0;

  // conf=1 → base±swing; conf=0 → base
  final double score = isHealthy ? (base + swing * conf) : (base - swing * conf);
  return score.round().clamp(0, 100);
}

