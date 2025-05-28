import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class AIService {
  static const String _baseUrl = 'http://localhost:5000';

  Future<List<Task>> generateSchedule(String input) async {
    try {
      print('Making request to backend...');
      final response = await http.post(
        Uri.parse('$_baseUrl/api/generate-schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tasks': input}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // The response body is a JSON string that contains another JSON string
        // First, decode the outer JSON string
        final String outerJson = response.body;
        // Then decode the inner JSON string
        final Map<String, dynamic> data = jsonDecode(outerJson);
        final List<dynamic> tasksJson = data['tasks'];

        final tasks =
            tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
        print('Parsed ${tasks.length} tasks');
        return tasks;
      } else {
        throw Exception('Failed to generate schedule: ${response.body}');
      }
    } catch (e) {
      print('Error in generateSchedule: $e');
      rethrow;
    }
  }
}
