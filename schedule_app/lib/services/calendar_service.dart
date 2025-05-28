import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (!_isInitialized) {
      print('Initializing timezone database...');
      tz.initializeTimeZones();
      _isInitialized = true;
      print('Timezone database initialized');
    }
  }

  Future<bool> requestCalendarPermission() async {
    await _initialize();
    print('Checking calendar permissions...');
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    print(
        'Current permissions status: ${permissionsGranted.isSuccess}, ${permissionsGranted.data}');

    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      print('Requesting calendar permissions...');
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      print(
          'Permission request result: ${permissionsGranted.isSuccess}, ${permissionsGranted.data}');
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        print('Calendar permission denied');
        return false;
      }
    }
    print('Calendar permission granted');
    return true;
  }

  Future<List<Calendar>> getCalendars() async {
    print('Retrieving calendars...');
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarsResult.isSuccess && calendarsResult.data != null) {
      print('Found ${calendarsResult.data!.length} calendars');
      for (var calendar in calendarsResult.data!) {
        print('Calendar: ${calendar.name} (${calendar.id})');
      }
      return calendarsResult.data!;
    }
    print('No calendars found or error occurred');
    return [];
  }

  Future<void> createEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    await _initialize();
    print('Creating event: $title');
    print('Start time: $startTime');
    print('End time: $endTime');

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (!calendarsResult.isSuccess ||
        calendarsResult.data == null ||
        calendarsResult.data!.isEmpty) {
      print('No calendars found');
      throw Exception('No calendars found');
    }

    // Use the first available calendar
    final calendar = calendarsResult.data!.first;
    print('Using calendar: ${calendar.name} (${calendar.id})');

    final event = Event(
      calendar.id,
      title: title,
      start: tz.TZDateTime.from(startTime, tz.local),
      end: tz.TZDateTime.from(endTime, tz.local),
    );

    print('Sending event to calendar...');
    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result == null || !result.isSuccess) {
      print('Failed to create event: ${result?.data ?? "Unknown error"}');
      throw Exception(
          'Failed to create event: ${result?.data ?? "Unknown error"}');
    }
    print('Event created successfully');
  }

  Future<bool> deleteEvent(String eventId, String calendarId) async {
    print('Deleting event: $eventId from calendar: $calendarId');
    final deleteEventResult = await _deviceCalendarPlugin.deleteEvent(
      calendarId,
      eventId,
    );
    final success = deleteEventResult?.isSuccess == true;
    print('Event deletion ${success ? "successful" : "failed"}');
    return success;
  }
}
