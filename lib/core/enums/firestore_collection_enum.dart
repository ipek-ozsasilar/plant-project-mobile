/// Firestore koleksiyon adları (enhanced enum).
enum FirestoreCollectionEnum {
  users('users'),
  plants('plants'),
  scans('scans');

  const FirestoreCollectionEnum(this.value);
  final String value;
}
