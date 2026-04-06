import 'package:equatable/equatable.dart';

final class HealthProgressState extends Equatable {
  const HealthProgressState({
    required this.selectedPlantId,
  });

  final String? selectedPlantId;

  HealthProgressState copyWith({String? selectedPlantId}) {
    return HealthProgressState(
      selectedPlantId: selectedPlantId,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedPlantId];
}

