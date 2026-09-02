import '../google_integration_models.dart';

abstract class CalendarService {
  Future<List<CalendarEvent>> events({
    required String calendarId,
    DateTime? from,
    DateTime? to,
  });

  Future<bool> isAvailable({
    required String calendarId,
    required DateTime start,
    required DateTime end,
  });

  /// Creating a calendar event is an external side effect.
  /// Implementations must respect ETHER's approval boundary.
  Future<CalendarEvent> create(CalendarEventDraft draft);

  Future<CalendarEvent> update(CalendarEvent event);

  Future<void> delete(String calendarId, String eventId);
}
