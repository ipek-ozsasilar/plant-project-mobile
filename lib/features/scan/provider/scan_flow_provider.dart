import 'dart:typed_data';

import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/image_crop_service.dart';
import 'package:bitirme_mobile/core/services/inference_api_service.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Tarama adımları.
enum ScanStep {
  pickImage,
  selectRegions,
  speciesLoading,
  speciesDone,
  diseaseLoading,
  diseaseDone,
  summary,
}

/// Tarama akışı durumu.
class ScanFlowState {
  const ScanFlowState({
    required this.step,
    this.imageBytes,
    this.regions = const <PlantRegionModel>[],
    this.selectedRegionIndex = 0,
    this.species,
    this.disease,
    this.errorMessage,
  });

  final ScanStep step;
  final Uint8List? imageBytes;
  final List<PlantRegionModel> regions;
  final int selectedRegionIndex;
  final InferenceResultModel? species;
  final InferenceResultModel? disease;
  final String? errorMessage;

  ScanFlowState copyWith({
    ScanStep? step,
    Uint8List? imageBytes,
    List<PlantRegionModel>? regions,
    int? selectedRegionIndex,
    InferenceResultModel? species,
    InferenceResultModel? disease,
    String? errorMessage,
    bool clearSpecies = false,
    bool clearDisease = false,
    bool clearError = false,
  }) {
    return ScanFlowState(
      step: step ?? this.step,
      imageBytes: imageBytes ?? this.imageBytes,
      regions: regions ?? this.regions,
      selectedRegionIndex: selectedRegionIndex ?? this.selectedRegionIndex,
      species: clearSpecies ? null : (species ?? this.species),
      disease: clearDisease ? null : (disease ?? this.disease),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Tarama akışı iş mantığı (tür → hastalık).
class ScanFlowNotifier extends Notifier<ScanFlowState> {
  final Uuid _uuid = const Uuid();

  @override
  ScanFlowState build() {
    return const ScanFlowState(step: ScanStep.pickImage);
  }

  void reset() {
    state = const ScanFlowState(step: ScanStep.pickImage);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void setImage(Uint8List bytes) {
    state = ScanFlowState(
      step: ScanStep.selectRegions,
      imageBytes: bytes,
      regions: const <PlantRegionModel>[],
      selectedRegionIndex: 0,
    );
  }

  void addRegionAtNormalized(double nx, double ny) {
    final Uint8List? bytes = state.imageBytes;
    if (bytes == null) {
      return;
    }
    final ImageCropService crop = sl<ImageCropService>();
    final PlantRegionModel base = crop.regionAroundTap(nx: nx, ny: ny);
    final PlantRegionModel region = PlantRegionModel(
      id: _uuid.v4(),
      nx: base.nx,
      ny: base.ny,
      nw: base.nw,
      nh: base.nh,
    );
    final List<PlantRegionModel> next = List<PlantRegionModel>.from(state.regions)..add(region);
    state = state.copyWith(
      regions: next,
      selectedRegionIndex: next.length - 1,
      clearError: true,
    );
  }

  void selectRegion(int index) {
    if (index < 0 || index >= state.regions.length) {
      return;
    }
    state = state.copyWith(selectedRegionIndex: index);
  }

  void clearRegions() {
    state = state.copyWith(regions: <PlantRegionModel>[], selectedRegionIndex: 0, clearError: true);
  }

  Future<void> runSpecies() async {
    final List<PlantRegionModel> regions = state.regions;
    final Uint8List? imageBytes = state.imageBytes;
    if (imageBytes == null || regions.isEmpty) {
      state = state.copyWith(errorMessage: '@@scanRegionsSelectPrompt');
      return;
    }
    final int idx = state.selectedRegionIndex.clamp(0, regions.length - 1);
    final PlantRegionModel region = regions[idx];
    state = ScanFlowState(
      step: ScanStep.speciesLoading,
      imageBytes: imageBytes,
      regions: regions,
      selectedRegionIndex: idx,
      species: state.species,
      disease: state.disease,
    );
    try {
      final Uint8List? cropped = sl<ImageCropService>().cropRegion(
        imageBytes: imageBytes,
        region: region,
      );
      if (cropped == null) {
        state = ScanFlowState(
          step: ScanStep.selectRegions,
          imageBytes: imageBytes,
          regions: regions,
          selectedRegionIndex: idx,
          errorMessage: '@@errorCrop',
        );
        return;
      }
      final InferenceResultModel result = await sl<InferenceApiService>().predictSpecies(cropped);
      state = ScanFlowState(
        step: ScanStep.speciesDone,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: idx,
        species: result,
        disease: state.disease,
      );
    } catch (e, st) {
      sl<AppLogger>().e('inference_species', e, st);
      state = ScanFlowState(
        step: ScanStep.selectRegions,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: idx,
        errorMessage: '@@errorInference',
      );
    }
  }

  Future<void> runDisease() async {
    final List<PlantRegionModel> regions = state.regions;
    final Uint8List? imageBytes = state.imageBytes;
    if (imageBytes == null || regions.isEmpty) {
      return;
    }
    final int idx = state.selectedRegionIndex.clamp(0, regions.length - 1);
    final PlantRegionModel region = regions[idx];
    state = ScanFlowState(
      step: ScanStep.diseaseLoading,
      imageBytes: imageBytes,
      regions: regions,
      selectedRegionIndex: idx,
      species: state.species,
      disease: state.disease,
    );
    try {
      final Uint8List? cropped = sl<ImageCropService>().cropRegion(
        imageBytes: imageBytes,
        region: region,
      );
      if (cropped == null) {
        state = ScanFlowState(
          step: ScanStep.speciesDone,
          imageBytes: imageBytes,
          regions: regions,
          selectedRegionIndex: idx,
          species: state.species,
          errorMessage: '@@errorCrop',
        );
        return;
      }
      final InferenceResultModel result = await sl<InferenceApiService>().predictDisease(cropped);
      state = ScanFlowState(
        step: ScanStep.diseaseDone,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: idx,
        species: state.species,
        disease: result,
      );
    } catch (e, st) {
      sl<AppLogger>().e('inference_disease', e, st);
      state = ScanFlowState(
        step: ScanStep.speciesDone,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: idx,
        species: state.species,
        errorMessage: '@@errorInference',
      );
    }
  }

  void goToSummary() {
    state = state.copyWith(step: ScanStep.summary);
  }
}

final NotifierProvider<ScanFlowNotifier, ScanFlowState> scanFlowProvider =
    NotifierProvider<ScanFlowNotifier, ScanFlowState>(ScanFlowNotifier.new);
