import 'package:equatable/equatable.dart';

/// Bir bitki için günlük/tekil tarama kaydı.
class PlantScanModel extends Equatable {
  const PlantScanModel({
    required this.id,
    required this.ownerUid,
    required this.plantId,
    required this.createdAt,
    required this.speciesLabel,
    required this.speciesConfidence,
    required this.diseaseKey,
    required this.diseaseConfidence,
    required this.healthScore,
    this.imageUrl,
  });

  final String id;
  final String ownerUid;
  final String plantId;
  final DateTime createdAt;
  final String speciesLabel;
  final double speciesConfidence;
  final String diseaseKey;
  final double diseaseConfidence;

  /// 0..100 — grafik için tek metrik.
  final int healthScore;

  final String? imageUrl;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'ownerUid': ownerUid,
      'plantId': plantId,
      'createdAt': createdAt.toIso8601String(),
      'speciesLabel': speciesLabel,
      'speciesConfidence': speciesConfidence,
      'diseaseKey': diseaseKey,
      'diseaseConfidence': diseaseConfidence,
      'healthScore': healthScore,
      'imageUrl': imageUrl,
    };
  }

  static PlantScanModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final String? id = json['id'] as String?;
    final String? ownerUid = json['ownerUid'] as String?;
    final String? plantId = json['plantId'] as String?;
    final String? createdRaw = json['createdAt'] as String?;
    if (id == null || ownerUid == null || plantId == null || createdRaw == null) {
      return null;
    }
    return PlantScanModel(
      id: id,
      ownerUid: ownerUid,
      plantId: plantId,
      createdAt: DateTime.tryParse(createdRaw) ?? DateTime.now(),
      speciesLabel: json['speciesLabel'] as String? ?? '',
      speciesConfidence: (json['speciesConfidence'] as num?)?.toDouble() ?? 0,
      diseaseKey: json['diseaseKey'] as String? ?? '',
      diseaseConfidence: (json['diseaseConfidence'] as num?)?.toDouble() ?? 0,
      healthScore: (json['healthScore'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        ownerUid,
        plantId,
        createdAt,
        speciesLabel,
        speciesConfidence,
        diseaseKey,
        diseaseConfidence,
        healthScore,
        imageUrl,
      ];
}

