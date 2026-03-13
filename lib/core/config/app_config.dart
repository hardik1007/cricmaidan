import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? 'PLACEHOLDER';
  static String get firebaseWebApiKey => dotenv.env['FIREBASE_WEB_API_KEY'] ?? 'PLACEHOLDER';
  static String? get googleClientSecret => dotenv.env['GOOGLE_CLIENT_SECRET'];
}