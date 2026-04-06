/// `leafsnap__quercus_velutina` → okunabilir kısa etiket.
/// `plantnet__1355868` → [plantnetMap] içinde varsa doğrudan ad; yoksa sayısal ID (UI'da l10n ile düzeltilir).
String formatSpeciesRawLabel(
  String raw, {
  Map<String, String> plantnetMap = const <String, String>{},
}) {
  if (raw.startsWith('plantnet__')) {
    final String id = raw.split('__').last;
    final String? mapped = plantnetMap[id];
    if (mapped != null && mapped.trim().isNotEmpty) {
      return mapped.trim();
    }
    return id;
  }
  final String tail = raw.contains('__') ? raw.split('__').last : raw;
  if (tail.isEmpty) {
    return raw;
  }
  final List<String> parts = tail.split('_');
  return parts
      .where((String p) => p.isNotEmpty)
      .map(
        (String w) =>
            '${w[0].toUpperCase()}${w.length > 1 ? w.substring(1).toLowerCase() : ''}',
      )
      .join(' ');
}
