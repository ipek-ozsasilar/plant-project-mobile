/// Model girişine uygulanacak ön işleme tipi.
enum MlPreprocessEnum {
  /// Float input'a ham [0..255] değerlerini ver (model içinde preprocess varsa).
  raw0to255,

  /// [0..255] → [0..1]
  unit0to1,

  /// [0..255] → [-1..1]
  minus1to1;
}

