// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'PhytoGuard';

  @override
  String get appTagline => 'Bitki türü ve hastalık analizi';

  @override
  String get splashLoading => 'Yükleniyor…';

  @override
  String get onboardingTitle1 => 'Akıllı bitki analizi';

  @override
  String get onboardingBody1 =>
      'Fotoğrafınızdan önce bitki türünü, ardından hastalık riskini yapay zeka ile tahmin edin.';

  @override
  String get onboardingTitle2 => 'Çoklu bitki desteği';

  @override
  String get onboardingBody2 =>
      'Aynı karede birden fazla bitki varsa bölgeleri işaretleyin; hangisini analiz edeceğinizi seçin.';

  @override
  String get onboardingTitle3 => 'Geçmiş ve rehber';

  @override
  String get onboardingBody3 =>
      'Taramalarınızı kaydedin, özet raporları görüntüleyin ve bakım ipuçlarına göz atın.';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingStart => 'Başla';

  @override
  String onboardingStep(int current, int total) {
    return '$current / $total';
  }

  @override
  String get loginTitle => 'Hoş geldiniz';

  @override
  String get loginSubtitle => 'Hesabınıza giriş yapın';

  @override
  String get registerTitle => 'Kayıt ol';

  @override
  String get registerSubtitle => 'Yeni hesap oluşturun';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get nameLabel => 'Ad soyad';

  @override
  String get loginCta => 'Giriş yap';

  @override
  String get registerCta => 'Kayıt ol';

  @override
  String get goRegister => 'Hesabınız yok mu? Kayıt olun';

  @override
  String get goLogin => 'Zaten hesabınız var mı? Giriş yapın';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get authOrDivider => 'veya';

  @override
  String get loginWithGoogle => 'Google ile devam et';

  @override
  String get homeTitle => 'Ana sayfa';

  @override
  String get homeGreeting => 'Merhaba';

  @override
  String get homeQuickScan => 'Hızlı tarama';

  @override
  String get homeQuickScanDesc => 'Kamera veya galeriden fotoğraf yükleyin';

  @override
  String get homeRecent => 'Son taramalar';

  @override
  String get homeSeeAll => 'Tümü';

  @override
  String get homeStatsTitle => 'Özet';

  @override
  String get homeStatScans => 'Toplam tarama';

  @override
  String get homeStatSpecies => 'Tür tespiti';

  @override
  String get homeStatAlerts => 'Uyarı';

  @override
  String get homeSearchHint => 'Bitki, hastalık veya rehber ara…';

  @override
  String get homeQuickAccessTitle => 'Hızlı erişim';

  @override
  String get homeHeroBadge => 'Yapay zeka';

  @override
  String get homeTipTitle => 'Günün ipucu';

  @override
  String get homeTipBody =>
      'Yaprak damarları net görünsün diye yumuşak ışık kullanın; gölgede çekim güven skorunu düşürür.';

  @override
  String get homeEmptyTitle => 'Henüz taramanız yok';

  @override
  String get homeEmptySubtitle =>
      'İlk fotoğrafınızı ekleyerek bitkilerinizi izlemeye başlayın.';

  @override
  String get homeStartScan => 'Tarama başlat';

  @override
  String get moreScreenTitle => 'Keşfet ve yönet';

  @override
  String get moreScreenSubtitle => 'Rehber, profil ve ayarlar tek yerde.';

  @override
  String get moreTileGuideDesc => 'Çekim ve çoklu bitki önerileri';

  @override
  String get moreTileProfileDesc => 'Hesap ve görünen ad';

  @override
  String get moreTileSettingsDesc => 'Tema ve uygulama tercihleri';

  @override
  String get moreTileHealthProgressDesc =>
      'Bitkilerinizin sağlık ve hastalık trendlerini görün';

  @override
  String get moreTileAboutDesc => 'Proje ve sorumluluk reddi';

  @override
  String get navHome => 'Ana';

  @override
  String get navScan => 'Tarama';

  @override
  String get navHistory => 'Geçmiş';

  @override
  String get navMore => 'Menü';

  @override
  String get scanTitle => 'Yeni tarama';

  @override
  String get scanPickTitle => 'Görüntü kaynağı';

  @override
  String get scanPickCamera => 'Kamera';

  @override
  String get scanPickGallery => 'Galeri';

  @override
  String get scanRegionsTitle => 'Bitki bölgeleri';

  @override
  String get scanRegionsHint =>
      'Birden fazla bitki varsa görüntüye dokunarak numaralı bölgeler ekleyin; analiz etmek istediğiniz bölgeyi seçin.';

  @override
  String get scanRegionsAdd => 'Bölge ekle';

  @override
  String get scanRegionsClear => 'Temizle';

  @override
  String get scanRegionsNext => 'Tür analizine geç';

  @override
  String get scanRegionsSelectPrompt =>
      'Lütfen en az bir bölge ekleyin veya seçin.';

  @override
  String get scanSpeciesLoading => 'Bitki türü tahmin ediliyor…';

  @override
  String get scanSpeciesTitle => 'Tür sonucu';

  @override
  String get scanSpeciesConfidence => 'Güven';

  @override
  String get scanDiseaseLoading => 'Hastalık / sağlık durumu analiz ediliyor…';

  @override
  String get scanDiseaseTitle => 'Hastalık / genel durum';

  @override
  String get scanDiseaseNote =>
      'Model türden bağımsız genel sınıflandırma yapar; sonuç öneri niteliğindedir.';

  @override
  String get scanSummaryTitle => 'Özet rapor';

  @override
  String get scanSaveHistory => 'Geçmişe kaydet';

  @override
  String get scanDone => 'Tamam';

  @override
  String get scanRetry => 'Yeniden dene';

  @override
  String get historyTitle => 'Geçmiş taramalar';

  @override
  String get historyEmpty => 'Henüz kayıtlı tarama yok.';

  @override
  String get historyOpen => 'Detay';

  @override
  String get guideTitle => 'Rehber';

  @override
  String get guideSectionPhoto => 'İyi fotoğraf';

  @override
  String get guidePhotoTips =>
      'Yaprakları net gösterin, gölgeden kaçının, mümkünse tek bitkiyi kadraja alın.';

  @override
  String get guideSectionMulti => 'Çoklu bitki';

  @override
  String get guideMultiTips =>
      'Birden fazla tür varsa her bitki için ayrı bölge işaretleyin; yanlış eşleşmeyi azaltır.';

  @override
  String get guideSectionDisease => 'Hastalık taraması';

  @override
  String get guideDiseaseTips =>
      'Belirtiler yaprak üst yüzeyinde görünür olmalı; bulanık görüntüler güveni düşürür.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get profileTitle => 'Profil';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get aboutBody =>
      'Bu uygulama bitirme tezi kapsamında geliştirilmiştir. Tahminler tıbbi teşhis değildir; ciddi zarar gören bitkiler için uzman görüşü önerilir.';

  @override
  String get aboutThesis =>
      'Tez ve TÜBİTAK raporu için proje dokümantasyonuna bakınız.';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get languageLabel => 'Dil';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get healthProgressTitle => 'Sağlık ilerlemesi';

  @override
  String get healthProgressSubtitle => 'Bitki seçin ve trendi izleyin';

  @override
  String get healthProgressHint =>
      'Bu ekran UI demo amaçlıdır; veri kaydı eklendiğinde geçmiş taramalarınızdan otomatik çizilecektir.';

  @override
  String get healthProgressSelectPlant => 'Bir bitki seçin';

  @override
  String get healthProgressChartTitle => 'Son 14 gün';

  @override
  String get healthProgressLegendHealth => 'Sağlık';

  @override
  String get healthProgressLegendDisease => 'Hastalık';

  @override
  String get healthProgressPlant1 => 'Monstera';

  @override
  String get healthProgressPlant2 => 'Aloe vera';

  @override
  String get healthProgressPlant3 => 'Kauçuk';

  @override
  String get notificationsLabel => 'Bildirimler';

  @override
  String get dataLabel => 'Veri ve gizlilik';

  @override
  String get apiHint => 'Sunucu adresi .env içinden yapılandırılır.';

  @override
  String get inferenceDiseaseBacterial => 'Bakteriyel';

  @override
  String get inferenceDiseaseBlight => 'Yanıklık';

  @override
  String get inferenceDiseaseHealthy => 'Sağlıklı';

  @override
  String get inferenceDiseaseLeafSpot => 'Yaprak lekesi';

  @override
  String get inferenceDiseaseMold => 'Küf';

  @override
  String get inferenceDiseasePestDamage => 'Zararlı / fiziksel hasar';

  @override
  String get inferenceDiseasePowderyMildew => 'Külleme';

  @override
  String get inferenceDiseaseRot => 'Çürük';

  @override
  String get inferenceDiseaseRust => 'Pas';

  @override
  String get inferenceDiseaseViral => 'Viral';

  @override
  String get validationRequired => 'Bu alan zorunludur.';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get continueCta => 'Devam et';

  @override
  String get back => 'Geri';

  @override
  String get close => 'Kapat';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'Tamam';

  @override
  String get errorTitle => 'Hata';

  @override
  String get successTitle => 'Başarılı';

  @override
  String get loading => 'Yükleniyor…';

  @override
  String get emptyState => 'Gösterilecek kayıt yok.';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get placeholderDash => '—';

  @override
  String get errorGeneric =>
      'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get errorNetwork =>
      'Ağ bağlantısı kurulamadı. İnternetinizi kontrol edin.';

  @override
  String get errorImagePick => 'Görüntü seçilirken bir sorun oluştu.';

  @override
  String get errorImageDecode => 'Görüntü işlenemedi.';

  @override
  String get errorCrop => 'Seçilen bölge kırpılamadı.';

  @override
  String get errorInference => 'Tahmin servisi yanıt vermedi.';

  @override
  String get errorAuth => 'Oturum bilgisi doğrulanamadı.';

  @override
  String get errorGoogleSignIn =>
      'Google ile giriş tamamlanamadı. İnternet ve yapılandırmayı kontrol edin.';

  @override
  String get errorStorage => 'Yerel kayıt okunamadı veya yazılamadı.';

  @override
  String get errorAuthEmailInUse => 'Bu e-posta adresi zaten kayıtlı.';

  @override
  String get errorAuthWeakPassword =>
      'Şifre çok zayıf. Daha güçlü bir şifre seçin.';

  @override
  String get errorAuthInvalidEmail => 'Geçersiz e-posta adresi.';

  @override
  String get errorAuthUserNotFound =>
      'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';

  @override
  String get errorAuthWrongPassword => 'Şifre hatalı.';

  @override
  String get errorAuthInvalidCredential => 'E-posta veya şifre hatalı.';

  @override
  String get errorAuthUserDisabled => 'Bu hesap devre dışı bırakılmış.';

  @override
  String get errorAuthTooManyRequests =>
      'Çok fazla deneme yapıldı. Lütfen bir süre sonra tekrar deneyin.';

  @override
  String get errorAuthOperationNotAllowed =>
      'Bu giriş yöntemi şu an kullanılamıyor. Firebase konsolunda etkinleştirin.';
}
