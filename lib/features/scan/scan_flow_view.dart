import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/features/scan/provider/scan_flow_provider.dart';
import 'package:bitirme_mobile/features/scan/sub_view/plant_region_picker_widget.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/models/scan_record_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Tarama sihirbazı: görüntü → bölge → tür → hastalık → özet.
class ScanFlowView extends ConsumerStatefulWidget {
  const ScanFlowView({super.key});

  @override
  ConsumerState<ScanFlowView> createState() => _ScanFlowViewState();
}

class _ScanFlowViewState extends ConsumerState<ScanFlowView> with ScaffoldMessageMixin {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scanFlowProvider.notifier).reset();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source, imageQuality: 88);
      if (file == null) {
        return;
      }
      final Uint8List bytes = await file.readAsBytes();
      ref.read(scanFlowProvider.notifier).setImage(bytes);
    } catch (e, st) {
      sl<AppLogger>().e(ErrorStringsEnum.imagePick.value, e, st);
      if (mounted) {
        showAppSnackBar(context, message: ErrorStringsEnum.imagePick.value, isError: true);
      }
    }
  }

  Future<void> _onSaveToHistory() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) {
      return;
    }
    final ScanRecordModel record = ScanRecordModel(
      id: Uuid().v4(),
      createdAt: DateTime.now(),
      speciesLabel: sp.top.label,
      speciesConfidence: sp.top.confidence,
      diseaseLabel: dis.top.label,
      diseaseConfidence: dis.top.confidence,
    );
    await ref.read(historyProvider.notifier).addRecord(record);
    if (mounted) {
      showAppSnackBar(context, message: StringsEnum.successTitle.value, isError: false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ScanFlowState>(scanFlowProvider, (ScanFlowState? previous, ScanFlowState next) {
      final String? msg = next.errorMessage;
      if (msg != null && msg.isNotEmpty) {
        showAppSnackBar(context, message: msg, isError: true);
        ref.read(scanFlowProvider.notifier).clearError();
      }
    });

    final ScanFlowState state = ref.watch(scanFlowProvider);
    final ScanFlowNotifier notifier = ref.read(scanFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(StringsEnum.scanTitle.value),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
          child: _buildBody(context, state, notifier),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    switch (state.step) {
      case ScanStep.pickImage:
        return _buildPick(context);
      case ScanStep.selectRegions:
        return _buildRegions(context, state, notifier);
      case ScanStep.speciesLoading:
        return _buildLoading(StringsEnum.scanSpeciesLoading.value);
      case ScanStep.speciesDone:
        return _buildSpeciesDone(context, state, notifier);
      case ScanStep.diseaseLoading:
        return _buildLoading(StringsEnum.scanDiseaseLoading.value);
      case ScanStep.diseaseDone:
        return _buildDiseaseDone(context, state, notifier);
      case ScanStep.summary:
        return _buildSummary(context, state, notifier);
    }
  }

  Widget _buildPick(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          StringsEnum.scanPickTitle.value,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
        AppPrimaryButton(
          label: StringsEnum.scanPickCamera.value,
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: StringsEnum.scanPickGallery.value,
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildRegions(
    BuildContext context,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final Uint8List? bytes = state.imageBytes;
    if (bytes == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          StringsEnum.scanRegionsTitle.value,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Text(
          StringsEnum.scanRegionsHint.value,
          style: TextStyle(
            fontSize: TextSizesEnum.body.value,
            color: ColorName.onSurfaceMuted,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Expanded(
          child: PlantRegionPickerWidget(
            bytes: bytes,
            regions: state.regions,
            selectedIndex: state.selectedRegionIndex,
            onTapNormalized: notifier.addRegionAtNormalized,
            onSelectRegion: notifier.selectRegion,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Row(
          children: <Widget>[
            TextButton(
              onPressed: state.regions.isEmpty ? null : notifier.clearRegions,
              child: Text(StringsEnum.scanRegionsClear.value),
            ),
            const Spacer(),
            Text(
              '${StringsEnum.scanRegionsAdd.value}: ${state.regions.length}',
              style: TextStyle(color: ColorName.onSurfaceMuted),
            ),
          ],
        ),
        AppPrimaryButton(
          label: StringsEnum.scanRegionsNext.value,
          onPressed: state.regions.isEmpty
              ? null
              : () async {
                  await notifier.runSpecies();
                },
        ),
      ],
    );
  }

  Widget _buildLoading(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSpeciesDone(
    BuildContext context,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? sp = state.species;
    if (sp == null) {
      return const SizedBox.shrink();
    }
    final double pct = sp.top.confidence * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          StringsEnum.scanSpeciesTitle.value,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(sp.top.label),
            subtitle: Text('${StringsEnum.scanSpeciesConfidence.value}: ${pct.toStringAsFixed(1)}%'),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: StringsEnum.continueCta.value,
          onPressed: () async {
            await notifier.runDisease();
          },
        ),
      ],
    );
  }

  Widget _buildDiseaseDone(
    BuildContext context,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? dis = state.disease;
    if (dis == null) {
      return const SizedBox.shrink();
    }
    final double pct = dis.top.confidence * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          StringsEnum.scanDiseaseTitle.value,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Text(
          StringsEnum.scanDiseaseNote.value,
          style: TextStyle(
            fontSize: TextSizesEnum.caption.value,
            color: ColorName.onSurfaceMuted,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(dis.top.label),
            subtitle: Text('${StringsEnum.scanSpeciesConfidence.value}: ${pct.toStringAsFixed(1)}%'),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: StringsEnum.continueCta.value,
          onPressed: notifier.goToSummary,
        ),
      ],
    );
  }

  Widget _buildSummary(
    BuildContext context,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? sp = state.species;
    final InferenceResultModel? dis = state.disease;
    if (sp == null || dis == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          StringsEnum.scanSummaryTitle.value,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(StringsEnum.scanSpeciesTitle.value),
            subtitle: Text(
              '${sp.top.label} (${(sp.top.confidence * 100).toStringAsFixed(1)}%)',
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(StringsEnum.scanDiseaseTitle.value),
            subtitle: Text(
              '${dis.top.label} (${(dis.top.confidence * 100).toStringAsFixed(1)}%)',
            ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: StringsEnum.scanSaveHistory.value,
          onPressed: _onSaveToHistory,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        OutlinedButton(
          onPressed: () {
            notifier.reset();
          },
          child: Text(StringsEnum.scanRetry.value),
        ),
      ],
    );
  }
}
