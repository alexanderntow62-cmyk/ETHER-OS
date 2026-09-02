// Core data models for ETHER-OS Google integrations.
//
// This foundation contains domain models only.
// Network and OAuth implementations live elsewhere.

enum GoogleService { gmail, calendar }

class GoogleAccount {
  final String id;
  final String email;
  final String? displayName;
  final Set<GoogleService> services;

  const GoogleAccount({
    required this.id,
    required this.email,
    this.displayName,
    this.services = const <GoogleService>{},
  });

  bool hasService(GoogleService service) {
    return services.contains(service);
  }

  GoogleAccount copyWith({
    String? id,
    String? email,
    String? displayName,
    Set<GoogleService>? services,
  }) {
    return GoogleAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      services: services ?? this.services,
    );
  }

  @override
  String toString() {
    return 'GoogleAccount('
        'id: $id, '
        'email: $email, '
        'displayName: $displayName, '
        'services: $services'
        ')';
  }
}

class GmailMessage {
  final String id;
  final String threadId;
  final String from;
  final String to;
  final String subject;
  final String body;
  final DateTime? receivedAt;
  final bool isRead;

  const GmailMessage({
    required this.id,
    this.threadId = '',
    this.from = '',
    this.to = '',
    this.subject = '',
    this.body = '',
    this.receivedAt,
    this.isRead = false,
  });

  GmailMessage copyWith({
    String? id,
    String? threadId,
    String? from,
    String? to,
    String? subject,
    String? body,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return GmailMessage(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      from: from ?? this.from,
      to: to ?? this.to,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() {
    return 'GmailMessage('
        'id: $id, '
        'threadId: $threadId, '
        'from: $from, '
        'to: $to, '
        'subject: $subject, '
        'isRead: $isRead'
        ')';
  }
}

class GmailDraft {
  final String to;
  final String subject;
  final String body;
  final List<String> cc;
  final List<String> bcc;

  const GmailDraft({
    required this.to,
    required this.subject,
    required this.body,
    this.cc = const <String>[],
    this.bcc = const <String>[],
  });

  @override
  String toString() {
    return 'GmailDraft('
        'to: $to, '
        'subject: $subject, '
        'body: $body, '
        'cc: $cc, '
        'bcc: $bcc'
        ')';
  }
}

class CalendarEvent {
  final String id;
  final String calendarId;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? description;
  final String? location;
  final List<String> attendees;

  const CalendarEvent({
    required this.id,
    required this.calendarId,
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.location,
    this.attendees = const <String>[],
  });

  Duration get duration => end.difference(start);

  CalendarEvent copyWith({
    String? id,
    String? calendarId,
    String? title,
    DateTime? start,
    DateTime? end,
    String? description,
    String? location,
    List<String>? attendees,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      calendarId: calendarId ?? this.calendarId,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      description: description ?? this.description,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
    );
  }

  @override
  String toString() {
    return 'CalendarEvent('
        'id: $id, '
        'calendarId: $calendarId, '
        'title: $title, '
        'start: $start, '
        'end: $end, '
        'description: $description, '
        'location: $location, '
        'attendees: $attendees'
        ')';
  }
}

class CalendarEventDraft {
  final String calendarId;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? description;
  final String? location;
  final List<String> attendees;

  const CalendarEventDraft({
    required this.calendarId,
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.location,
    this.attendees = const <String>[],
  });

  Duration get duration => end.difference(start);

  @override
  String toString() {
    return 'CalendarEventDraft('
        'calendarId: $calendarId, '
        'title: $title, '
        'start: $start, '
        'end: $end, '
        'description: $description, '
        'location: $location, '
        'attendees: $attendees'
        ')';
  }
}
