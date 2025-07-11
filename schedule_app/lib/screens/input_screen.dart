import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/calendar_service.dart';
import '../services/schedule_state.dart';
import '../models/task.dart';
import 'schedule_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _inputController = TextEditingController();
  final AIService _aiService = AIService();
  final CalendarService _calendarService = CalendarService();
  final ScheduleState _scheduleState = ScheduleState();
  bool _isLoading = false;

  Future<void> _generateSchedule() async {
    if (_inputController.text.isEmpty) {
      print('Input is empty');
      return;
    }

    print('Starting schedule generation...');
    setState(() {
      _isLoading = true;
    });

    try {
      print('Calling AI service...');
      final tasks = await _aiService.generateSchedule(_inputController.text);
      print('Received ${tasks.length} tasks from AI service');

      // Store the generated tasks in the global state
      _scheduleState.updateSchedule(List<Task>.from(tasks));
      print('InputScreen - Updated schedule state with ${tasks.length} tasks');

      // Request calendar permissions
      print('Requesting calendar permissions...');
      final hasPermission = await _calendarService.requestCalendarPermission();

      if (!hasPermission) {
        print('Calendar permission denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar permission is required to create events'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      print('Adding tasks to calendar...');
      // Add tasks to calendar
      for (final task in tasks) {
        print('Adding task: ${task.name}');
        await _calendarService.createEvent(
          title: task.name,
          startTime: task.startTime,
          endTime: task.endTime,
        );
      }

      if (mounted) {
        print('Showing success message and navigating to schedule screen');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Events have been added to your calendar'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleScreen(
              tasks: List<Task>.from(_scheduleState.currentTasks),
              startTime: _scheduleState.scheduleStartTime,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error in _generateSchedule: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToScheduleScreen() {
    print('InputScreen - Navigating to schedule screen');
    print('InputScreen - Current tasks: ${_scheduleState.currentTasks}');
    print(
        'InputScreen - Number of tasks: ${_scheduleState.currentTasks.length}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleScreen(
          tasks: List<Task>.from(_scheduleState.currentTasks),
          startTime: _scheduleState.scheduleStartTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.black, size: 28),
              onPressed: _navigateToScheduleScreen,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                          child: Text(
                            'Your Tasks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _inputController,
                          maxLines: null,
                          minLines: 8,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Example:\n\n'
                                'I need to:\n'
                                '- Study for math exam (3 hours)\n'
                                '- Complete project report (2 hours)\n'
                                '- Go to gym (1 hour)\n'
                                '- Meet with team (1.5 hours)\n\n'
                                'I prefer to study in the morning and exercise in the evening.',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Be specific about your preferences and time constraints for better results',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _generateSchedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome),
                                SizedBox(width: 8),
                                Text(
                                  'Generate Schedule',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
