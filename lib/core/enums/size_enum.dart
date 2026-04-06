/// Görsel boyutları (enhanced enum).
enum ImageSizesEnum {
  thumb(56),
  preview(120),
  hero(200),
  fullWidthBanner(320);

  const ImageSizesEnum(this.pixels);
  final double pixels;

  double get value => pixels;
}

/// Metin boyutları (enhanced enum).
enum TextSizesEnum {
  caption(12),
  body(14),
  subtitle(16),
  title(20),
  headline(24),
  display(28);

  const TextSizesEnum(this.size);
  final double size;

  double get value => size;
}

/// İkon boyutları (enhanced enum).
enum IconSizesEnum {
  small(18),
  medium(22),
  large(28),
  xlarge(36);

  const IconSizesEnum(this.size);
  final double size;

  double get value => size;
}

/// Genel widget boyutları (enhanced enum).
enum WidgetSizesEnum {
  buttonHeight(52),
  inputHeight(52),
  cardRadius(24),
  chipRadius(20),
  inputFieldRadius(22),
  divider(1),
  bottomNavHeight(88),
  bottomNavHorizontalPadding(16),
  bottomNavBottomPadding(12),
  bottomNavFabCutoutWidth(88),
  fabSize(56),
  maxContentWidth(520),
  regionMinSide(0.12),
  fabBlurRadius(18),
  fabYOffset(6),
  cardShadowBlur(20),
  cardShadowOffsetY(8),
  cardShadowSpread(0),
  homeHeaderHeight(200),
  homeHeaderExtend(48),
  quickActionTileWidth(88),
  recentCardHeight(132),
  decorativeBlob(160),
  authLoginHeroFlexTop(44),
  authLoginHeroFlexBottom(56),
  authRegisterHeroFlexTop(40),
  authRegisterHeroFlexBottom(60),
  pdfPagePadding(24),
  pdfSectionSpacing(14),
  pdfTitleFont(18),
  pdfBodyFont(12);

  const WidgetSizesEnum(this.value);
  final double value;
}

/// AppBar ile ilgili boyutlar (enhanced enum).
enum AppBarSizesEnum {
  toolbarHeight(56),
  elevation(0),
  iconPadding(8);

  const AppBarSizesEnum(this.value);
  final double value;
}
