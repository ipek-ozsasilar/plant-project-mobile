import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_state.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kullanıcının bitki koleksiyonu (liste).
class PlantsListView extends ConsumerStatefulWidget {
  const PlantsListView({super.key});

  @override
  ConsumerState<PlantsListView> createState() => _PlantsListViewState();
}

class _PlantsListViewState extends ConsumerState<PlantsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(plantsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final PlantsState state = ref.watch(plantsProvider);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.myPlantsTitle),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push('${AppPaths.myPlants}/add'),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.items.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(pad * 1.25),
                    child: Text(
                      context.l10n.myPlantsEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.palMuted, fontSize: TextSizesEnum.body.value),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(pad),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: WidgetSizesEnum.cardRadius.value),
                  itemBuilder: (BuildContext context, int index) {
                    final PlantModel p = state.items[index];
                    return SoftElevationCard(
                      onTap: () => context.push('${AppPaths.myPlants}/${p.id}'),
                      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: WidgetSizesEnum.cardRadius.value * 2.2,
                            height: WidgetSizesEnum.cardRadius.value * 2.2,
                            decoration: BoxDecoration(
                              color: context.palPrimary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                            ),
                            child: Icon(Icons.local_florist_rounded, color: context.palPrimary),
                          ),
                          SizedBox(width: WidgetSizesEnum.cardRadius.value),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: context.palOnSurface,
                                    fontSize: TextSizesEnum.subtitle.value,
                                  ),
                                ),
                                SizedBox(height: WidgetSizesEnum.divider.value * 6),
                                Text(
                                  p.speciesLabel,
                                  style: TextStyle(
                                    color: context.palMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: context.palMuted),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

