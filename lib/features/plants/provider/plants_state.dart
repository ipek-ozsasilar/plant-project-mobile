import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:equatable/equatable.dart';

final class PlantsState extends Equatable {
  const PlantsState({
    required this.items,
    required this.loading,
  });

  final List<PlantModel> items;
  final bool loading;

  PlantsState copyWith({
    List<PlantModel>? items,
    bool? loading,
  }) {
    return PlantsState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => <Object?>[items, loading];
}

