/// `leafsnap__quercus_velutina` → okunabilir kısa etiket.
String formatSpeciesRawLabel(String raw) {
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
