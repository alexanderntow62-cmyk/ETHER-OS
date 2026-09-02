/// Google OAuth permission and scope definitions used by ETHER-OS.

enum GooglePermission { gmailRead, gmailSend, calendarWrite, calendarFreeBusy }

class GoogleScopes {
  GoogleScopes._();

  static const String gmailReadonly =
      'https://www.googleapis.com/auth/gmail.readonly';

  static const String gmailSend = 'https://www.googleapis.com/auth/gmail.send';

  static const String calendarEvents =
      'https://www.googleapis.com/auth/calendar.events';

  static const String calendarFreeBusy =
      'https://www.googleapis.com/auth/calendar.freebusy';

  static Set<String> forPermissions(Set<GooglePermission> permissions) {
    final scopes = <String>{};

    if (permissions.contains(GooglePermission.gmailRead)) {
      scopes.add(gmailReadonly);
    }

    if (permissions.contains(GooglePermission.gmailSend)) {
      scopes.add(gmailSend);
    }

    if (permissions.contains(GooglePermission.calendarWrite)) {
      scopes.add(calendarEvents);
    }

    if (permissions.contains(GooglePermission.calendarFreeBusy)) {
      scopes.add(calendarFreeBusy);
    }

    return scopes;
  }
}
