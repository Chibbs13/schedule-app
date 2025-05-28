import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Get API key from .env file
  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  // API endpoint configuration
  static const String baseUrl = 'https://api.openai.com/v1';

  // Model configuration
  static const String model = 'gpt-4-turbo-preview';
}
