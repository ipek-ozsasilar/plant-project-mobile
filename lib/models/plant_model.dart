import 'package:equatable/equatable.dart';

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
  });

  final String id;
  final String ownerUid;
  final String name;
  final String speciesLabel;
  final DateTime createdAt;
  final String? photoUrl;
  final bool isFavorite;

  PlantModel copyWith({
    String? name,
    String? speciesLabel,
    String? photoUrl,
    bool? isFavorite,
  }) {
    return PlantModel(
      id: id,
      ownerUid: ownerUid,
      name: name ?? this.name,
      speciesLabel: speciesLabel ?? this.speciesLabel,
      createdAt: createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'ownerUid': ownerUid,
      'name': name,
      'speciesLabel': speciesLabel,
      'createdAt': createdAt.toIso8601String(),
      'photoUrl': photoUrl,
      'isFavorite': isFavorite,
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
    final String? createdRaw = json['createdAt'] as String?;
    if (id == null || ownerUid == null || name == null || speciesLabel == null || createdRaw == null) {
      return null;
    }
    return PlantModel(
      id: id,
      ownerUid: ownerUid,
      name: name,
      speciesLabel: speciesLabel,
      createdAt: DateTime.tryParse(createdRaw) ?? DateTime.now(),
      photoUrl: json['photoUrl'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
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
      ];
}

