import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'PhytoGuard'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü ve hastalık analizi'**
  String get appTagline;

  /// No description provided for @splashLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get splashLoading;

  /// No description provided for @onboardingTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı bitki analizi'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafınızdan önce bitki türünü, ardından hastalık riskini yapay zeka ile tahmin edin.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In tr, this message translates to:
  /// **'Çoklu bitki desteği'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In tr, this message translates to:
  /// **'Aynı karede birden fazla bitki varsa bölgeleri işaretleyin; hangisini analiz edeceğinizi seçin.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş ve rehber'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In tr, this message translates to:
  /// **'Taramalarınızı kaydedin, özet raporları görüntüleyin ve bakım ipuçlarına göz atın.'**
  String get onboardingBody3;

  /// No description provided for @onboardingNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get onboardingStart;

  /// Onboarding adım göstergesi
  ///
  /// In tr, this message translates to:
  /// **'{current} / {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza giriş yapın'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hesap oluşturun'**
  String get registerSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad'**
  String get nameLabel;

  /// No description provided for @loginCta.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get loginCta;

  /// No description provided for @registerCta.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ol'**
  String get registerCta;

  /// No description provided for @goRegister.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız yok mu? Kayıt olun'**
  String get goRegister;

  /// No description provided for @goLogin.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabınız var mı? Giriş yapın'**
  String get goLogin;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get logout;

  /// No description provided for @authOrDivider.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get authOrDivider;

  /// No description provided for @loginWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile devam et'**
  String get loginWithGoogle;

  /// No description provided for @homeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba'**
  String get homeGreeting;

  /// No description provided for @homeQuickScan.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı tarama'**
  String get homeQuickScan;

  /// No description provided for @homeQuickScanDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kamera veya galeriden fotoğraf yükleyin'**
  String get homeQuickScanDesc;

  /// No description provided for @homeRecent.
  ///
  /// In tr, this message translates to:
  /// **'Son taramalar'**
  String get homeRecent;

  /// No description provided for @homeSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get homeSeeAll;

  /// No description provided for @homeStatsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get homeStatsTitle;

  /// No description provided for @homeStatScans.
  ///
  /// In tr, this message translates to:
  /// **'Toplam tarama'**
  String get homeStatScans;

  /// No description provided for @homeStatSpecies.
  ///
  /// In tr, this message translates to:
  /// **'Tür tespiti'**
  String get homeStatSpecies;

  /// No description provided for @homeStatAlerts.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı'**
  String get homeStatAlerts;

  /// No description provided for @homeSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Bitki, hastalık veya rehber ara…'**
  String get homeSearchHint;

  /// No description provided for @homeQuickAccessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı erişim'**
  String get homeQuickAccessTitle;

  /// No description provided for @homeHeroBadge.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka'**
  String get homeHeroBadge;

  /// No description provided for @homeTipTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günün ipucu'**
  String get homeTipTitle;

  /// No description provided for @homeTipBody.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak damarları net görünsün diye yumuşak ışık kullanın; gölgede çekim güven skorunu düşürür.'**
  String get homeTipBody;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz taramanız yok'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk fotoğrafınızı ekleyerek bitkilerinizi izlemeye başlayın.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeStartScan.
  ///
  /// In tr, this message translates to:
  /// **'Tarama başlat'**
  String get homeStartScan;

  /// No description provided for @moreScreenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet ve yönet'**
  String get moreScreenTitle;

  /// No description provided for @moreScreenSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehber, profil ve ayarlar tek yerde.'**
  String get moreScreenSubtitle;

  /// No description provided for @moreTileGuideDesc.
  ///
  /// In tr, this message translates to:
  /// **'Çekim ve çoklu bitki önerileri'**
  String get moreTileGuideDesc;

  /// No description provided for @moreTileProfileDesc.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ve görünen ad'**
  String get moreTileProfileDesc;

  /// No description provided for @moreTileSettingsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Tema ve uygulama tercihleri'**
  String get moreTileSettingsDesc;

  /// No description provided for @moreTileHealthProgressDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bitkilerinizin sağlık ve hastalık trendlerini görün'**
  String get moreTileHealthProgressDesc;

  /// No description provided for @moreTileAboutDesc.
  ///
  /// In tr, this message translates to:
  /// **'Proje ve sorumluluk reddi'**
  String get moreTileAboutDesc;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana'**
  String get navHome;

  /// No description provided for @navScan.
  ///
  /// In tr, this message translates to:
  /// **'Tarama'**
  String get navScan;

  /// No description provided for @navHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get navHistory;

  /// No description provided for @navMore.
  ///
  /// In tr, this message translates to:
  /// **'Menü'**
  String get navMore;

  /// No description provided for @scanTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni tarama'**
  String get scanTitle;

  /// No description provided for @scanPickTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görüntü kaynağı'**
  String get scanPickTitle;

  /// No description provided for @scanPickCamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get scanPickCamera;

  /// No description provided for @scanPickGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeri'**
  String get scanPickGallery;

  /// No description provided for @scanRegionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki bölgeleri'**
  String get scanRegionsTitle;

  /// No description provided for @scanRegionsHint.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla bitki varsa görüntüye dokunarak numaralı bölgeler ekleyin; analiz etmek istediğiniz bölgeyi seçin.'**
  String get scanRegionsHint;

  /// No description provided for @scanRegionsAdd.
  ///
  /// In tr, this message translates to:
  /// **'Bölge ekle'**
  String get scanRegionsAdd;

  /// No description provided for @scanRegionsClear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get scanRegionsClear;

  /// No description provided for @scanRegionsNext.
  ///
  /// In tr, this message translates to:
  /// **'Tür analizine geç'**
  String get scanRegionsNext;

  /// No description provided for @scanRegionsSelectPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen en az bir bölge ekleyin veya seçin.'**
  String get scanRegionsSelectPrompt;

  /// No description provided for @scanSpeciesLoading.
  ///
  /// In tr, this message translates to:
  /// **'Bitki türü tahmin ediliyor…'**
  String get scanSpeciesLoading;

  /// No description provided for @scanSpeciesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tür sonucu'**
  String get scanSpeciesTitle;

  /// No description provided for @scanSpeciesConfidence.
  ///
  /// In tr, this message translates to:
  /// **'Güven'**
  String get scanSpeciesConfidence;

  /// No description provided for @scanDiseaseLoading.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık / sağlık durumu analiz ediliyor…'**
  String get scanDiseaseLoading;

  /// No description provided for @scanDiseaseTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık / genel durum'**
  String get scanDiseaseTitle;

  /// No description provided for @scanDiseaseNote.
  ///
  /// In tr, this message translates to:
  /// **'Model türden bağımsız genel sınıflandırma yapar; sonuç öneri niteliğindedir.'**
  String get scanDiseaseNote;

  /// No description provided for @scanSummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özet rapor'**
  String get scanSummaryTitle;

  /// No description provided for @scanSaveHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmişe kaydet'**
  String get scanSaveHistory;

  /// No description provided for @scanDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get scanDone;

  /// No description provided for @scanRetry.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden dene'**
  String get scanRetry;

  /// No description provided for @historyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş taramalar'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı tarama yok.'**
  String get historyEmpty;

  /// No description provided for @historyOpen.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get historyOpen;

  /// No description provided for @guideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehber'**
  String get guideTitle;

  /// No description provided for @guideSectionPhoto.
  ///
  /// In tr, this message translates to:
  /// **'İyi fotoğraf'**
  String get guideSectionPhoto;

  /// No description provided for @guidePhotoTips.
  ///
  /// In tr, this message translates to:
  /// **'Yaprakları net gösterin, gölgeden kaçının, mümkünse tek bitkiyi kadraja alın.'**
  String get guidePhotoTips;

  /// No description provided for @guideSectionMulti.
  ///
  /// In tr, this message translates to:
  /// **'Çoklu bitki'**
  String get guideSectionMulti;

  /// No description provided for @guideMultiTips.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla tür varsa her bitki için ayrı bölge işaretleyin; yanlış eşleşmeyi azaltır.'**
  String get guideMultiTips;

  /// No description provided for @guideSectionDisease.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık taraması'**
  String get guideSectionDisease;

  /// No description provided for @guideDiseaseTips.
  ///
  /// In tr, this message translates to:
  /// **'Belirtiler yaprak üst yüzeyinde görünür olmalı; bulanık görüntüler güveni düşürür.'**
  String get guideDiseaseTips;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get aboutTitle;

  /// No description provided for @aboutBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama bitirme tezi kapsamında geliştirilmiştir. Tahminler tıbbi teşhis değildir; ciddi zarar gören bitkiler için uzman görüşü önerilir.'**
  String get aboutBody;

  /// No description provided for @aboutThesis.
  ///
  /// In tr, this message translates to:
  /// **'Tez ve TÜBİTAK raporu için proje dokümantasyonuna bakınız.'**
  String get aboutThesis;

  /// No description provided for @themeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @languageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get languageSystem;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @healthProgressTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık ilerlemesi'**
  String get healthProgressTitle;

  /// No description provided for @healthProgressSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bitki seçin ve trendi izleyin'**
  String get healthProgressSubtitle;

  /// No description provided for @healthProgressHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran UI demo amaçlıdır; veri kaydı eklendiğinde geçmiş taramalarınızdan otomatik çizilecektir.'**
  String get healthProgressHint;

  /// No description provided for @healthProgressSelectPlant.
  ///
  /// In tr, this message translates to:
  /// **'Bir bitki seçin'**
  String get healthProgressSelectPlant;

  /// No description provided for @healthProgressChartTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son 14 gün'**
  String get healthProgressChartTitle;

  /// No description provided for @healthProgressLegendHealth.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık'**
  String get healthProgressLegendHealth;

  /// No description provided for @healthProgressLegendDisease.
  ///
  /// In tr, this message translates to:
  /// **'Hastalık'**
  String get healthProgressLegendDisease;

  /// No description provided for @healthProgressPlant1.
  ///
  /// In tr, this message translates to:
  /// **'Monstera'**
  String get healthProgressPlant1;

  /// No description provided for @healthProgressPlant2.
  ///
  /// In tr, this message translates to:
  /// **'Aloe vera'**
  String get healthProgressPlant2;

  /// No description provided for @healthProgressPlant3.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk'**
  String get healthProgressPlant3;

  /// No description provided for @notificationsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationsLabel;

  /// No description provided for @dataLabel.
  ///
  /// In tr, this message translates to:
  /// **'Veri ve gizlilik'**
  String get dataLabel;

  /// No description provided for @apiHint.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu adresi .env içinden yapılandırılır.'**
  String get apiHint;

  /// No description provided for @inferenceDiseaseBacterial.
  ///
  /// In tr, this message translates to:
  /// **'Bakteriyel'**
  String get inferenceDiseaseBacterial;

  /// No description provided for @inferenceDiseaseBlight.
  ///
  /// In tr, this message translates to:
  /// **'Yanıklık'**
  String get inferenceDiseaseBlight;

  /// No description provided for @inferenceDiseaseHealthy.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı'**
  String get inferenceDiseaseHealthy;

  /// No description provided for @inferenceDiseaseLeafSpot.
  ///
  /// In tr, this message translates to:
  /// **'Yaprak lekesi'**
  String get inferenceDiseaseLeafSpot;

  /// No description provided for @inferenceDiseaseMold.
  ///
  /// In tr, this message translates to:
  /// **'Küf'**
  String get inferenceDiseaseMold;

  /// No description provided for @inferenceDiseasePestDamage.
  ///
  /// In tr, this message translates to:
  /// **'Zararlı / fiziksel hasar'**
  String get inferenceDiseasePestDamage;

  /// No description provided for @inferenceDiseasePowderyMildew.
  ///
  /// In tr, this message translates to:
  /// **'Külleme'**
  String get inferenceDiseasePowderyMildew;

  /// No description provided for @inferenceDiseaseRot.
  ///
  /// In tr, this message translates to:
  /// **'Çürük'**
  String get inferenceDiseaseRot;

  /// No description provided for @inferenceDiseaseRust.
  ///
  /// In tr, this message translates to:
  /// **'Pas'**
  String get inferenceDiseaseRust;

  /// No description provided for @inferenceDiseaseViral.
  ///
  /// In tr, this message translates to:
  /// **'Viral'**
  String get inferenceDiseaseViral;

  /// No description provided for @validationRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunludur.'**
  String get validationRequired;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @continueCta.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get continueCta;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get ok;

  /// No description provided for @errorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get errorTitle;

  /// No description provided for @successTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get successTitle;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get loading;

  /// No description provided for @emptyState.
  ///
  /// In tr, this message translates to:
  /// **'Gösterilecek kayıt yok.'**
  String get emptyState;

  /// No description provided for @unknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get unknown;

  /// No description provided for @placeholderDash.
  ///
  /// In tr, this message translates to:
  /// **'—'**
  String get placeholderDash;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Ağ bağlantısı kurulamadı. İnternetinizi kontrol edin.'**
  String get errorNetwork;

  /// No description provided for @errorImagePick.
  ///
  /// In tr, this message translates to:
  /// **'Görüntü seçilirken bir sorun oluştu.'**
  String get errorImagePick;

  /// No description provided for @errorImageDecode.
  ///
  /// In tr, this message translates to:
  /// **'Görüntü işlenemedi.'**
  String get errorImageDecode;

  /// No description provided for @errorCrop.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen bölge kırpılamadı.'**
  String get errorCrop;

  /// No description provided for @errorInference.
  ///
  /// In tr, this message translates to:
  /// **'Tahmin servisi yanıt vermedi.'**
  String get errorInference;

  /// No description provided for @errorAuth.
  ///
  /// In tr, this message translates to:
  /// **'Oturum bilgisi doğrulanamadı.'**
  String get errorAuth;

  /// No description provided for @errorGoogleSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş tamamlanamadı. İnternet ve yapılandırmayı kontrol edin.'**
  String get errorGoogleSignIn;

  /// No description provided for @errorStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yerel kayıt okunamadı veya yazılamadı.'**
  String get errorStorage;

  /// No description provided for @errorAuthEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresi zaten kayıtlı.'**
  String get errorAuthEmailInUse;

  /// No description provided for @errorAuthWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre çok zayıf. Daha güçlü bir şifre seçin.'**
  String get errorAuthWeakPassword;

  /// No description provided for @errorAuthInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz e-posta adresi.'**
  String get errorAuthInvalidEmail;

  /// No description provided for @errorAuthUserNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı kullanıcı bulunamadı.'**
  String get errorAuthUserNotFound;

  /// No description provided for @errorAuthWrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre hatalı.'**
  String get errorAuthWrongPassword;

  /// No description provided for @errorAuthInvalidCredential.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get errorAuthInvalidCredential;

  /// No description provided for @errorAuthUserDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap devre dışı bırakılmış.'**
  String get errorAuthUserDisabled;

  /// No description provided for @errorAuthTooManyRequests.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yapıldı. Lütfen bir süre sonra tekrar deneyin.'**
  String get errorAuthTooManyRequests;

  /// No description provided for @errorAuthOperationNotAllowed.
  ///
  /// In tr, this message translates to:
  /// **'Bu giriş yöntemi şu an kullanılamıyor. Firebase konsolunda etkinleştirin.'**
  String get errorAuthOperationNotAllowed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
