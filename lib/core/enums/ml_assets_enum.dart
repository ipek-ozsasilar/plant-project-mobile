/// Yerel TFLite ve sınıf listesi asset yolları (enhanced enum).
enum MlAssetsEnum {
  speciesLabelsJson('assets/ml/class_names.json'),
  sinkSpeciesClassesJson('assets/ml/sink_classes.json'),
  /// PlantNet sınıf ID (string) → bilimsel / yaygın ad (isteğe bağlı; boş `{}` olabilir).
  plantnetSpeciesIdMapJson('assets/ml/plantnet_species_id_map.json'),
  diseaseLabelsJson('assets/ml/disease_class_names_10class.json'),
  speciesModel('assets/ml/plant_species_model.tflite'),
  diseaseModel('assets/ml/disease_10class.tflite');

  const MlAssetsEnum(this.value);
  final String value;
}
