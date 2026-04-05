import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/scan_flow_localized_error.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/features/scan/provider/scan_flow_provider.dart';
import 'package:bitirme_mobile/features/scan/sub_view/plant_region_picker_widget.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
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
      sl<AppLogger>().e('image_pick', e, st);
      if (mounted) {
        showAppSnackBar(context, message: context.l10n.errorImagePick, isError: true);
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
      speciesConfidence: confidenceToUnit(sp.top.confidence),
      diseaseLabel: dis.top.label,
      diseaseConfidence: confidenceToUnit(dis.top.confidence),
    );
    await ref.read(historyProvider.notifier).addRecord(record);
    if (mounted) {
      showAppSnackBar(context, message: context.l10n.successTitle, isError: false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    ref.listen<ScanFlowState>(scanFlowProvider, (ScanFlowState? previous, ScanFlowState next) {
      final String? msg = next.errorMessage;
      if (msg != null && msg.isNotEmpty) {
        showAppSnackBar(
          context,
          message: localizedScanFlowError(msg, l10n),
          isError: true,
        );
        ref.read(scanFlowProvider.notifier).clearError();
      }
    });

    final ScanFlowState state = ref.watch(scanFlowProvider);
    final ScanFlowNotifier notifier = ref.read(scanFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
          child: _buildBody(context, l10n, state, notifier),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    switch (state.step) {
      case ScanStep.pickImage:
        return _buildPick(context, l10n);
      case ScanStep.selectRegions:
        return _buildRegions(context, l10n, state, notifier);
      case ScanStep.speciesLoading:
        return _buildLoading(l10n.scanSpeciesLoading);
      case ScanStep.speciesDone:
        return _buildSpeciesDone(context, l10n, state, notifier);
      case ScanStep.diseaseLoading:
        return _buildLoading(l10n.scanDiseaseLoading);
      case ScanStep.diseaseDone:
        return _buildDiseaseDone(context, l10n, state, notifier);
      case ScanStep.summary:
        return _buildSummary(context, l10n, state, notifier);
    }
  }

  Widget _buildPick(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanPickTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
        AppPrimaryButton(
          label: l10n.scanPickCamera,
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: l10n.scanPickGallery,
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildRegions(
    BuildContext context,
    AppLocalizations l10n,
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
          l10n.scanRegionsTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Text(
          l10n.scanRegionsHint,
          style: TextStyle(
            fontSize: TextSizesEnum.body.value,
            color: context.palMuted,
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
              child: Text(l10n.scanRegionsClear),
            ),
            const Spacer(),
            Text(
              '${l10n.scanRegionsAdd}: ${state.regions.length}',
              style: TextStyle(color: context.palMuted),
            ),
          ],
        ),
        AppPrimaryButton(
          label: l10n.scanRegionsNext,
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
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? sp = state.species;
    if (sp == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanSpeciesTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(sp.top.label),
            subtitle: Text(
              '${l10n.scanSpeciesConfidence}: ${confidencePercentLabel(sp.top.confidence)}',
            ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: l10n.continueCta,
          onPressed: () async {
            await notifier.runDisease();
          },
        ),
      ],
    );
  }

  Widget _buildDiseaseDone(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? dis = state.disease;
    if (dis == null) {
      return const SizedBox.shrink();
    }
    final String diseaseText = diseaseClassKeyToDisplay(dis.top.label, l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanDiseaseTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Text(
          l10n.scanDiseaseNote,
          style: TextStyle(
            fontSize: TextSizesEnum.caption.value,
            color: context.palMuted,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(diseaseText),
            subtitle: Text(
              '${l10n.scanSpeciesConfidence}: ${confidencePercentLabel(dis.top.confidence)}',
            ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: l10n.continueCta,
          onPressed: notifier.goToSummary,
        ),
      ],
    );
  }

  Widget _buildSummary(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? sp = state.species;
    final InferenceResultModel? dis = state.disease;
    if (sp == null || dis == null) {
      return const SizedBox.shrink();
    }
    final String diseaseText = diseaseClassKeyToDisplay(dis.top.label, l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanSummaryTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(l10n.scanSpeciesTitle),
            subtitle: Text(
              '${sp.top.label} (${confidencePercentLabel(sp.top.confidence)})',
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(l10n.scanDiseaseTitle),
            subtitle: Text(
              '$diseaseText (${confidencePercentLabel(dis.top.confidence)})',
            ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: l10n.scanSaveHistory,
          onPressed: _onSaveToHistory,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        OutlinedButton(
          onPressed: () {
            notifier.reset();
          },
          child: Text(l10n.scanRetry),
        ),
      ],
    );
  }
}
