import 'package:bitirme_mobile/core/services/plants_firestore_service.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_state.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NotifierProvider<PlantsNotifier, PlantsState> plantsProvider =
    NotifierProvider<PlantsNotifier, PlantsState>(PlantsNotifier.new);

final class PlantsNotifier extends Notifier<PlantsState> {
  @override
  PlantsState build() {
    return const PlantsState(items: <PlantModel>[], loading: false);
  }

  Future<void> load() async {
    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      state = state.copyWith(items: <PlantModel>[], loading: false);
      return;
    }
    state = state.copyWith(loading: true);
    final PlantsFirestoreService svc = sl<PlantsFirestoreService>();
    final List<PlantModel> items = await svc.listPlants(ownerUid: uid);
    state = state.copyWith(items: items, loading: false);
  }

  Future<void> add(PlantModel plant) async {
    final PlantsFirestoreService svc = sl<PlantsFirestoreService>();
    await svc.upsertPlant(plant);
    await load();
  }
}

