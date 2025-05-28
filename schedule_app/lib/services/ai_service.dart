import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';

class AIService {
  final String apiKey;
  final String baseUrl;
  final String model;

  AIService({String? apiKey, String? baseUrl, String? model})
      : apiKey = apiKey ?? ApiConfig.openAiApiKey,
        baseUrl = baseUrl ?? ApiConfig.baseUrl,
        model = model ?? ApiConfig.model;

  Future<List<Task>> generateSchedule(String input) async {
    try {
      print('Generating schedule with input: $input');
      print('Using API key: ${apiKey.substring(0, 5)}...');
      print('Using model: $model');

      final now = DateTime.now();
      final systemPrompt = '''
You are a helpful assistant that creates optimal schedules based on user input.
Parse the user input and return ONLY a JSON array of objects with the following fields:
"name" (string), "duration" (number in minutes), "startTime" (ISO 8601 datetime string), and "endTime" (ISO 8601 datetime string).

Important rules:
1. Use the current date (${now.toIso8601String()}) as the starting point
2. Schedule events for the next 7 days
3. Consider user preferences for time of day
4. Add appropriate breaks between tasks
5. Return ONLY the JSON array, no other text

Example format:
[
  {
    "name": "Task Name",
    "duration": 60,
    "startTime": "2024-03-20T09:00:00Z",
    "endTime": "2024-03-20T10:00:00Z"
  }
]
''';

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': systemPrompt,
            },
            {'role': 'user', 'content': input},
          ],
          'temperature': 0.7,
        }),
      );

      print('API Response status: ${response.statusCode}');
      print('API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'].trim();
        print('Parsed content: $content');

        // Extract JSON array from the response
        final jsonStart = content.indexOf('[');
        final jsonEnd = content.lastIndexOf(']') + 1;
        if (jsonStart == -1 || jsonEnd == 0) {
          throw Exception('No valid JSON array found in response');
        }

        final jsonStr = content.substring(jsonStart, jsonEnd);
        print('Extracted JSON: $jsonStr');

        final List<dynamic> tasksJson = jsonDecode(jsonStr);
        print('Parsed tasks: $tasksJson');

        return tasksJson.map((task) => Task.fromJson(task)).toList();
      } else {
        throw Exception('Failed to generate schedule: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error in generateSchedule: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error generating schedule: $e');
    }
  }
}
