import 'dart:collection';

/// `sink_classes.json` içeriği — modelin "sink" olma eğilimindeki ham sınıf anahtarları.
///
/// Örn: `plantnet__1391192`
final class SinkSpeciesClassRepository {
  Set<String> _rawKeys = <String>{};

  UnmodifiableSetView<String> get snapshot => UnmodifiableSetView<String>(_rawKeys);

  void setFromJsonList(List<dynamic> decoded) {
    final Set<String> next = <String>{};
    for (final dynamic e in decoded) {
      final String v = e.toString().trim();
      if (v.isEmpty) {
        continue;
      }
      next.add(v);
    }
    _rawKeys = next;
  }
}

