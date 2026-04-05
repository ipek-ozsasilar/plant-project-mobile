/// İlk dil seçim ekranı (henüz [AppLocalizations] yüklenmeden önce çift dilli metin).
enum LanguagePickerStringsEnum {
  headline('Dil seçin · Choose language'),
  subtitle('Devam etmek için bir dil seçin · Pick a language to continue'),
  turkishTitle('Türkçe'),
  turkishSubtitle('Tüm arayüz Türkçe'),
  englishTitle('English'),
  englishSubtitle('Interface in English');

  const LanguagePickerStringsEnum(this.value);
  final String value;
}
