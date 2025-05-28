import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/schedule_state.dart';

class ScheduleScreen extends StatelessWidget {
  final List<Task> tasks;
  final DateTime startTime;

  const ScheduleScreen({
    super.key,
    required this.tasks,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    print('ScheduleScreen - Number of tasks: ${tasks.length}');
    print('ScheduleScreen - Tasks: $tasks');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Schedule'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No schedule generated yet.\nGo to the input screen to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Duration: ${task.duration} minutes',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12;
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
