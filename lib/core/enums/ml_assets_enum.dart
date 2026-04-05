/// Yerel TFLite ve sınıf listesi asset yolları (enhanced enum).
enum MlAssetsEnum {
  speciesLabelsJson('assets/ml/class_names.json'),
  diseaseLabelsJson('assets/ml/disease_class_names.json'),
  speciesModel('assets/ml/plant_species_model.tflite'),
  diseaseModel('assets/ml/plant_disease_model.tflite');

  const MlAssetsEnum(this.value);
  final String value;
}
