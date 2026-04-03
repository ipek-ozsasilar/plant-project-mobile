/// Hata ve bilgi mesajları (enhanced enum).
enum ErrorStringsEnum {
  generic('Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'),
  network('Ağ bağlantısı kurulamadı. İnternetinizi kontrol edin.'),
  imagePick('Görüntü seçilirken bir sorun oluştu.'),
  imageDecode('Görüntü işlenemedi.'),
  crop('Seçilen bölge kırpılamadı.'),
  inference('Tahmin servisi yanıt vermedi.'),
  auth('Oturum bilgisi doğrulanamadı.'),
  googleSignIn('Google ile giriş tamamlanamadı. İnternet ve yapılandırmayı kontrol edin.'),
  storage('Yerel kayıt okunamadı veya yazılamadı.'),
  authEmailInUse('Bu e-posta adresi zaten kayıtlı.'),
  authWeakPassword('Şifre çok zayıf. Daha güçlü bir şifre seçin.'),
  authInvalidEmail('Geçersiz e-posta adresi.'),
  authUserNotFound('Bu e-posta ile kayıtlı kullanıcı bulunamadı.'),
  authWrongPassword('Şifre hatalı.'),
  authInvalidCredential('E-posta veya şifre hatalı.'),
  authUserDisabled('Bu hesap devre dışı bırakılmış.'),
  authTooManyRequests('Çok fazla deneme yapıldı. Lütfen bir süre sonra tekrar deneyin.'),
  authOperationNotAllowed('Bu giriş yöntemi şu an kullanılamıyor. Firebase konsolunda etkinleştirin.');

  const ErrorStringsEnum(this.value);
  final String value;
}
