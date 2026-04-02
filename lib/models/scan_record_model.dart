import 'package:equatable/equatable.dart';

/// Geçmişe kaydedilen bir tarama kaydı.
class ScanRecordModel extends Equatable {
  const ScanRecordModel({
    required this.id,
    required this.createdAt,
    required this.speciesLabel,
    required this.speciesConfidence,
    required this.diseaseLabel,
    required this.diseaseConfidence,
    this.thumbnailBase64,
  });

  final String id;
  final DateTime createdAt;
  final String speciesLabel;
  final double speciesConfidence;
  final String diseaseLabel;
  final double diseaseConfidence;
  final String? thumbnailBase64;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'speciesLabel': speciesLabel,
      'speciesConfidence': speciesConfidence,
      'diseaseLabel': diseaseLabel,
      'diseaseConfidence': diseaseConfidence,
      'thumbnailBase64': thumbnailBase64,
    };
  }

  static ScanRecordModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final String? id = json['id'] as String?;
    final String? createdRaw = json['createdAt'] as String?;
    if (id == null || createdRaw == null) {
      return null;
    }
    return ScanRecordModel(
      id: id,
      createdAt: DateTime.tryParse(createdRaw) ?? DateTime.now(),
      speciesLabel: json['speciesLabel'] as String? ?? '',
      speciesConfidence: (json['speciesConfidence'] as num?)?.toDouble() ?? 0,
      diseaseLabel: json['diseaseLabel'] as String? ?? '',
      diseaseConfidence: (json['diseaseConfidence'] as num?)?.toDouble() ?? 0,
      thumbnailBase64: json['thumbnailBase64'] as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        createdAt,
        speciesLabel,
        speciesConfidence,
        diseaseLabel,
        diseaseConfidence,
        thumbnailBase64,
      ];
}
