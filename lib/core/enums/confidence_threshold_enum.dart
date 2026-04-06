/// Güven skoruna göre görsel sınıflandırma eşikleri.
enum ConfidenceThresholdEnum {
  low(0.4),
  medium(0.7);

  const ConfidenceThresholdEnum(this.value);
  final double value;
}

