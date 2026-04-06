import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

/// Yeni bitki ekleme (MVP: ad + tür etiketi).
class PlantsAddView extends ConsumerStatefulWidget {
  const PlantsAddView({super.key});

  @override
  ConsumerState<PlantsAddView> createState() => _PlantsAddViewState();
}

class _PlantsAddViewState extends ConsumerState<PlantsAddView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _species = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }
    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      return;
    }
    setState(() => _loading = true);
    final PlantModel plant = PlantModel(
      id: const Uuid().v4(),
      ownerUid: uid,
      name: _name.text.trim(),
      speciesLabel: _species.text.trim(),
      createdAt: DateTime.now(),
    );
    await ref.read(plantsProvider.notifier).add(plant);
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(title: Text(context.l10n.myPlantsAddTitle)),
      body: Padding(
        padding: EdgeInsets.all(pad),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppTextField(
                label: context.l10n.myPlantsNameLabel,
                controller: _name,
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? context.l10n.validationRequired : null,
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              AppTextField(
                label: context.l10n.myPlantsSpeciesLabel,
                controller: _species,
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? context.l10n.validationRequired : null,
              ),
              const Spacer(),
              AppPrimaryButton(
                label: context.l10n.save,
                isLoading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

