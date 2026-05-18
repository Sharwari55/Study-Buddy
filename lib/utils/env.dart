import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiUrl => dotenv.get('API_URL', fallback: 'https://api.example.com');
  static String get apiKey => dotenv.get('API_KEY', fallback: '');
  static String get youtubeApiKey => dotenv.get('YOUTUBE_API_KEY', fallback: '');
  static String get firebaseId => dotenv.get('FIREBASE_ID', fallback: '');
  
  // Method to check if all critical variables are loaded
  static bool get isLoaded => dotenv.isInitialized;
}
