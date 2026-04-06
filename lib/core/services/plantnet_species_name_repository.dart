/// `plantnet_species_id_map.json` içeriği — PlantNet sayısal sınıf ID → okunabilir ad.
final class PlantnetSpeciesNameRepository {
  Map<String, String> _map = <String, String>{};

  Map<String, String> get snapshot => _map;

  void setFromJson(Map<String, dynamic> decoded) {
    _map = <String, String>{};
    for (final MapEntry<String, dynamic> e in decoded.entries) {
      _map[e.key] = e.value.toString();
    }
  }
}
