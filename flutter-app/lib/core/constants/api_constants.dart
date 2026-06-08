/// API configuration constants for LingoBreeze.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the Node.js backend API.
  /// Change this to your deployed API URL in production.
  static const String baseUrl = 'https://backend-dhruv123.vercel.app'; // Production (Vercel)
  // static const String baseUrl = 'http://localhost:3000'; // Local development
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator

  /// Endpoints
  static const String wordsEndpoint = '/words';

  /// Full URL for the words API.
  static String get wordsUrl => '$baseUrl$wordsEndpoint';

  /// Request timeout duration.
  static const Duration timeout = Duration(seconds: 15);
}
