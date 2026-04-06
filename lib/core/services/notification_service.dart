import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Lokal bildirimler: sulama hatırlatması ve risk uyarıları (MVP).
class NotificationService {
  NotificationService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const int _dailyWateringId = 11001;
  static const int _riskAlertId = 11002;

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    } catch (e, st) {
      _logger.w('tz_init', e);
      _logger.e('tz_init', e, st);
    }

    try {
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
      const InitializationSettings settings = InitializationSettings(android: androidInit, iOS: iosInit);
      await _plugin.initialize(settings);
    } catch (e, st) {
      _logger.e('notifications_init', e, st);
    }
  }

  Future<bool> isEnabled() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(PreferenceKeys.notificationsEnabled) ?? false;
    } catch (e, st) {
      _logger.e('notifications_enabled_read', e, st);
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PreferenceKeys.notificationsEnabled, enabled);
    } catch (e, st) {
      _logger.e('notifications_enabled_write', e, st);
    }
  }

  Future<void> requestPermissions() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e, st) {
      _logger.e('notifications_permissions', e, st);
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e, st) {
      _logger.e('notifications_cancel_all', e, st);
    }
  }

  Future<void> scheduleDailyWatering({
    required String title,
    required String body,
    int hour = 20,
    int minute = 0,
  }) async {
    try {
      final bool enabled = await isEnabled();
      if (!enabled) {
        return;
      }

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime next = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (next.isBefore(now)) {
        next = next.add(const Duration(days: 1));
      }

      const AndroidNotificationDetails android = AndroidNotificationDetails(
        'watering_reminders',
        'Watering reminders',
        channelDescription: 'Daily plant care reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );
      const DarwinNotificationDetails ios = DarwinNotificationDetails();
      const NotificationDetails details = NotificationDetails(android: android, iOS: ios);

      await _plugin.zonedSchedule(
        _dailyWateringId,
        title,
        body,
        next,
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e, st) {
      _logger.e('notifications_schedule_daily', e, st);
    }
  }

  Future<void> showRiskAlert({
    required String title,
    required String body,
  }) async {
    try {
      final bool enabled = await isEnabled();
      if (!enabled) {
        return;
      }
      const AndroidNotificationDetails android = AndroidNotificationDetails(
        'risk_alerts',
        'Risk alerts',
        channelDescription: 'Health risk warnings',
        importance: Importance.high,
        priority: Priority.high,
      );
      const DarwinNotificationDetails ios = DarwinNotificationDetails();
      const NotificationDetails details = NotificationDetails(android: android, iOS: ios);

      await _plugin.show(_riskAlertId, title, body, details);
    } catch (e, st) {
      _logger.e('notifications_risk_alert', e, st);
    }
  }
}

