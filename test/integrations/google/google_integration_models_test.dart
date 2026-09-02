import 'package:flutter_test/flutter_test.dart';

import 'package:ether_os/integrations/google/google_integration_models.dart';

void main() {
  group('Google integration models', () {
    test('GoogleAccount reports connected services', () {
      const account = GoogleAccount(
        id: 'account-1',
        email: 'test@example.com',
        displayName: 'Test User',
        services: {GoogleService.gmail, GoogleService.calendar},
      );

      expect(account.hasService(GoogleService.gmail), isTrue);

      expect(account.hasService(GoogleService.calendar), isTrue);
    });

    test('GmailDraft preserves email data', () {
      const draft = GmailDraft(
        to: 'person@example.com',
        subject: 'Hello',
        body: 'Test message',
      );

      expect(draft.to, 'person@example.com');
      expect(draft.subject, 'Hello');
      expect(draft.body, 'Test message');
    });

    test('CalendarEventDraft preserves event data', () {
      final start = DateTime(2026, 9, 10, 10);
      final end = DateTime(2026, 9, 10, 11);

      final draft = CalendarEventDraft(
        calendarId: 'primary',
        title: 'ETHER Meeting',
        start: start,
        end: end,
      );

      expect(draft.calendarId, 'primary');
      expect(draft.title, 'ETHER Meeting');
      expect(draft.start, start);
      expect(draft.end, end);
      expect(draft.duration, const Duration(hours: 1));
    });

    test('CalendarEvent preserves event data', () {
      final start = DateTime(2026, 9, 10, 10);
      final end = DateTime(2026, 9, 10, 11);

      final event = CalendarEvent(
        id: 'event-1',
        calendarId: 'primary',
        title: 'ETHER Meeting',
        start: DateTime(2026, 9, 10, 10),
        end: DateTime(2026, 9, 10, 11),
      );

      expect(event.id, 'event-1');
      expect(event.calendarId, 'primary');
      expect(event.title, 'ETHER Meeting');
      expect(event.start, start);
      expect(event.end, end);
      expect(event.duration, const Duration(hours: 1));
    });

    test('GmailMessage preserves message data', () {
      const message = GmailMessage(
        id: 'message-1',
        threadId: 'thread-1',
        from: 'sender@example.com',
        to: 'test@example.com',
        subject: 'Hello',
        body: 'Test body',
        isRead: true,
      );

      expect(message.id, 'message-1');
      expect(message.threadId, 'thread-1');
      expect(message.from, 'sender@example.com');
      expect(message.to, 'test@example.com');
      expect(message.subject, 'Hello');
      expect(message.body, 'Test body');
      expect(message.isRead, isTrue);
    });
  });
}
