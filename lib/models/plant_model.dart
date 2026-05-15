import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Kullanıcının koleksiyonundaki bitki.
class PlantModel extends Equatable {
  const PlantModel({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.speciesLabel,
    required this.createdAt,
    this.photoUrl,
    this.isFavorite = false,
    this.lastHealthScore,
    this.lastScanDate,
    this.updatedAt,
  });

  final String id;
  final String ownerUid;
  final String name;
  final String speciesLabel;
  final DateTime createdAt;
  final String? photoUrl;
  final bool isFavorite;
  final int? lastHealthScore;
  final DateTime? lastScanDate;
  final DateTime? updatedAt;

  PlantModel copyWith({
    String? name,
    String? speciesLabel,
    String? photoUrl,
    bool? isFavorite,
    int? lastHealthScore,
    DateTime? lastScanDate,
    DateTime? updatedAt,
  }) {
    return PlantModel(
      id: id,
      ownerUid: ownerUid,
      name: name ?? this.name,
      speciesLabel: speciesLabel ?? this.speciesLabel,
      createdAt: createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      lastHealthScore: lastHealthScore ?? this.lastHealthScore,
      lastScanDate: lastScanDate ?? this.lastScanDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'ownerUid': ownerUid,
      'name': name,
      'speciesLabel': speciesLabel,
      'createdAt': Timestamp.fromDate(createdAt),
      'photoUrl': photoUrl,
      'isFavorite': isFavorite,
      'lastHealthScore': lastHealthScore,
      'lastScanDate': lastScanDate != null ? Timestamp.fromDate(lastScanDate!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  static PlantModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final String? id = json['id'] as String?;
    final String? ownerUid = json['ownerUid'] as String?;
    final String? name = json['name'] as String?;
    final String? speciesLabel = json['speciesLabel'] as String?;
    
    if (id == null || ownerUid == null || name == null || speciesLabel == null) {
      return null;
    }

    final DateTime createdAt = (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

    return PlantModel(
      id: id,
      ownerUid: ownerUid,
      name: name,
      speciesLabel: speciesLabel,
      createdAt: createdAt,
      photoUrl: json['photoUrl'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastHealthScore: json['lastHealthScore'] as int?,
      lastScanDate: (json['lastScanDate'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        ownerUid,
        name,
        speciesLabel,
        createdAt,
        photoUrl,
        isFavorite,
        lastHealthScore,
        lastScanDate,
        updatedAt,
      ];
}
