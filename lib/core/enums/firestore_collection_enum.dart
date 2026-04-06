/// Firestore koleksiyon adları (enhanced enum).
enum FirestoreCollectionEnum {
  users('users'),
  plants('plants'),
  scans('scans'),
  diseases('diseases'),
  species('species');

  const FirestoreCollectionEnum(this.value);
  final String value;
}
