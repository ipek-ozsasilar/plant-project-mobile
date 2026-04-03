/// Tüm kullanıcı arayüzü metinleri (enhanced enum).
enum StringsEnum {
  appName('PhytoGuard'),
  appTagline('Bitki türü ve hastalık analizi'),

  // Splash
  splashLoading('Yükleniyor…'),

  // Onboarding
  onboardingTitle1('Akıllı bitki analizi'),
  onboardingBody1(
    'Fotoğrafınızdan önce bitki türünü, ardından hastalık riskini yapay zeka ile tahmin edin.',
  ),
  onboardingTitle2('Çoklu bitki desteği'),
  onboardingBody2(
    'Aynı karede birden fazla bitki varsa bölgeleri işaretleyin; hangisini analiz edeceğinizi seçin.',
  ),
  onboardingTitle3('Geçmiş ve rehber'),
  onboardingBody3(
    'Taramalarınızı kaydedin, özet raporları görüntüleyin ve bakım ipuçlarına göz atın.',
  ),
  onboardingNext('İleri'),
  onboardingSkip('Atla'),
  onboardingStart('Başla'),

  // Auth
  loginTitle('Hoş geldiniz'),
  loginSubtitle('Hesabınıza giriş yapın'),
  registerTitle('Kayıt ol'),
  registerSubtitle('Yeni hesap oluşturun'),
  emailLabel('E-posta'),
  passwordLabel('Şifre'),
  nameLabel('Ad soyad'),
  loginCta('Giriş yap'),
  registerCta('Kayıt ol'),
  goRegister('Hesabınız yok mu? Kayıt olun'),
  goLogin('Zaten hesabınız var mı? Giriş yapın'),
  logout('Çıkış yap'),
  authOrDivider('veya'),
  loginWithGoogle('Google ile devam et'),

  // Home
  homeTitle('Ana sayfa'),
  homeGreeting('Merhaba'),
  homeQuickScan('Hızlı tarama'),
  homeQuickScanDesc('Kamera veya galeriden fotoğraf yükleyin'),
  homeRecent('Son taramalar'),
  homeSeeAll('Tümü'),
  homeStatsTitle('Özet'),
  homeStatScans('Toplam tarama'),
  homeStatSpecies('Tür tespiti'),
  homeStatAlerts('Uyarı'),

  // Shell
  navHome('Ana'),
  navScan('Tarama'),
  navHistory('Geçmiş'),
  navMore('Menü'),

  // Scan flow
  scanTitle('Yeni tarama'),
  scanPickTitle('Görüntü kaynağı'),
  scanPickCamera('Kamera'),
  scanPickGallery('Galeri'),
  scanRegionsTitle('Bitki bölgeleri'),
  scanRegionsHint(
    'Birden fazla bitki varsa görüntüye dokunarak numaralı bölgeler ekleyin; analiz etmek istediğiniz bölgeyi seçin.',
  ),
  scanRegionsAdd('Bölge ekle'),
  scanRegionsClear('Temizle'),
  scanRegionsNext('Tür analizine geç'),
  scanRegionsSelectPrompt('Lütfen en az bir bölge ekleyin veya seçin.'),
  scanSpeciesLoading('Bitki türü tahmin ediliyor…'),
  scanSpeciesTitle('Tür sonucu'),
  scanSpeciesConfidence('Güven'),
  scanDiseaseLoading('Hastalık / sağlık durumu analiz ediliyor…'),
  scanDiseaseTitle('Hastalık / genel durum'),
  scanDiseaseNote(
    'Model türden bağımsız genel sınıflandırma yapar; sonuç öneri niteliğindedir.',
  ),
  scanSummaryTitle('Özet rapor'),
  scanSaveHistory('Geçmişe kaydet'),
  scanDone('Tamam'),
  scanRetry('Yeniden dene'),

  // History
  historyTitle('Geçmiş taramalar'),
  historyEmpty('Henüz kayıtlı tarama yok.'),
  historyOpen('Detay'),

  // Guide
  guideTitle('Rehber'),
  guideSectionPhoto('İyi fotoğraf'),
  guidePhotoTips(
    'Yaprakları net gösterin, gölgeden kaçının, mümkünse tek bitkiyi kadraja alın.',
  ),
  guideSectionMulti('Çoklu bitki'),
  guideMultiTips(
    'Birden fazla tür varsa her bitki için ayrı bölge işaretleyin; yanlış eşleşmeyi azaltır.',
  ),
  guideSectionDisease('Hastalık taraması'),
  guideDiseaseTips(
    'Belirtiler yaprak üst yüzeyinde görünür olmalı; bulanık görüntüler güveni düşürür.',
  ),

  // Settings & profile
  settingsTitle('Ayarlar'),
  profileTitle('Profil'),
  aboutTitle('Hakkında'),
  aboutBody(
    'Bu uygulama bitirme tezi kapsamında geliştirilmiştir. Tahminler tıbbi teşhis değildir; '
    'ciddi zarar gören bitkiler için uzman görüşü önerilir.',
  ),
  aboutThesis('Tez ve TÜBİTAK raporu için proje dokümantasyonuna bakınız.'),
  themeLabel('Tema'),
  themeSystem('Sistem'),
  themeLight('Açık'),
  themeDark('Koyu'),
  notificationsLabel('Bildirimler'),
  dataLabel('Veri ve gizlilik'),
  apiHint('Sunucu adresi .env içinden yapılandırılır.'),

  // Common
  validationRequired('Bu alan zorunludur.'),
  save('Kaydet'),
  cancel('İptal'),
  delete('Sil'),
  continueCta('Devam et'),
  back('Geri'),
  close('Kapat'),
  yes('Evet'),
  no('Hayır'),
  ok('Tamam'),
  errorTitle('Hata'),
  successTitle('Başarılı'),
  loading('Yükleniyor…'),
  emptyState('Gösterilecek kayıt yok.'),
  unknown('Bilinmiyor'),
  placeholderDash('—');

  const StringsEnum(this.value);
  final String value;
}
