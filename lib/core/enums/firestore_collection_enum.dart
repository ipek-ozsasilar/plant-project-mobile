/// Firestore koleksiyon adları (enhanced enum).
enum FirestoreCollectionEnum {
  users('users');

  const FirestoreCollectionEnum(this.value);
  final String value;
}
