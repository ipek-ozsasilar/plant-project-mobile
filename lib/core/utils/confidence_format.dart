/// Güven skorunu 0–1 aralığına indirger; API 0–100 gönderirse böler.
double confidenceToUnit(num value) {
  double x = value.toDouble();
  if (x.isNaN || x.isInfinite) {
    return 0;
  }
  if (x > 1.000001) {
    x = x / 100.0;
  }
  return x.clamp(0.0, 1.0);
}

/// Arayüzde gösterim: 0–100 tam sayı, üst sınır %100.
int confidenceToDisplayPercent(num value) {
  return (confidenceToUnit(value) * 100).round().clamp(0, 100);
}

String confidencePercentLabel(num value) => '${confidenceToDisplayPercent(value)}%';
