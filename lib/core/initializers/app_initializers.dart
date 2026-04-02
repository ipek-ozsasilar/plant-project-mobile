import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Uygulama başlamadan önce çalıştırılması gereken kurulumlar.
final class AppInitializers {
  AppInitializers._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // DateFormat(..., 'tr') için yerel tarih/sayı biçim verisi
    await initializeDateFormatting('tr', null);
    await setupServiceLocator();
  }
}
