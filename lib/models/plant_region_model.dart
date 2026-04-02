import 'package:equatable/equatable.dart';

/// Görüntü üzerinde normalize (0–1) dikdörtgen bölge.
class PlantRegionModel extends Equatable {
  const PlantRegionModel({
    required this.id,
    required this.nx,
    required this.ny,
    required this.nw,
    required this.nh,
  });

  final String id;
  final double nx;
  final double ny;
  final double nw;
  final double nh;

  PlantRegionModel copyWith({
    String? id,
    double? nx,
    double? ny,
    double? nw,
    double? nh,
  }) {
    return PlantRegionModel(
      id: id ?? this.id,
      nx: nx ?? this.nx,
      ny: ny ?? this.ny,
      nw: nw ?? this.nw,
      nh: nh ?? this.nh,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, nx, ny, nw, nh];
}
