import 'dart:convert';

/// Local-only credential hash for Phase 2A MVP.
/// Replace with server-backed auth when backend provider is chosen.
String hashPassword(String email, String password) {
  final normalized = email.trim().toLowerCase();
  return base64Url.encode(utf8.encode('$normalized::$password'));
}

bool verifyPassword(String email, String password, String storedHash) {
  return hashPassword(email, password) == storedHash;
}
