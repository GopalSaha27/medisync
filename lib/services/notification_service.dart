import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Create the notification plugin instance.
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service.
  static Future<void> initialize() async {
    // Initialize timezone database.
    tz.initializeTimeZones();

    // Android notification settings.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // General notification settings.
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // Initialize the notification plugin.
    await _notifications.initialize(
      settings: settings,
    );
  }

  // Request notification permission on Android.
  static Future<void> requestPermission() async {
    // Get Android-specific notification implementation.
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // Request notification permission.
    await androidPlugin?.requestNotificationsPermission();
  }

  // Schedule a medicine reminder.
  static Future<void> scheduleMedicineReminder({
    required int id,
    required String medicineName,
    required String dosage,
    required int hour,
    required int minute,
  }) async {
    // Get the current date and time.
    final now = tz.TZDateTime.now(tz.local);

    // Create today's reminder time.
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If today's time has already passed,
    // schedule the reminder for tomorrow.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }

    // Schedule the notification.
    await _notifications.zonedSchedule(
      id: id,
      title: 'Medicine Reminder',
      body: 'Time to take $medicineName ($dosage)',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_reminders',
          'Medicine Reminders',
          channelDescription:
              'Notifications for medicine reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
  }

  // Cancel a previously scheduled reminder.
  static Future<void> cancelReminder(int id) async {
    await _notifications.cancel(
      id: id,
    );
  }
}