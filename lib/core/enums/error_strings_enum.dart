/// Hata ve bilgi mesajları (enhanced enum).
enum ErrorStringsEnum {
  generic('Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'),
  network('Ağ bağlantısı kurulamadı. İnternetinizi kontrol edin.'),
  imagePick('Görüntü seçilirken bir sorun oluştu.'),
  imageDecode('Görüntü işlenemedi.'),
  crop('Seçilen bölge kırpılamadı.'),
  inference('Tahmin servisi yanıt vermedi.'),
  auth('Oturum bilgisi doğrulanamadı.'),
  storage('Yerel kayıt okunamadı veya yazılamadı.');

  const ErrorStringsEnum(this.value);
  final String value;
}
