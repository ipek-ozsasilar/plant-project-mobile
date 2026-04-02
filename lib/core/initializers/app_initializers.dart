import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/widgets.dart';

/// Uygulama başlamadan önce çalıştırılması gereken kurulumlar.
final class AppInitializers {
  AppInitializers._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupServiceLocator();
  }
}
