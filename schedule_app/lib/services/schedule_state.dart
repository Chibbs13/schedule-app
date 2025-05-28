import '../models/task.dart';

class ScheduleState {
  static final ScheduleState _instance = ScheduleState._internal();
  factory ScheduleState() => _instance;
  ScheduleState._internal();

  List<Task> _currentTasks = [];
  DateTime _scheduleStartTime = DateTime.now();

  List<Task> get currentTasks => _currentTasks;
  DateTime get scheduleStartTime => _scheduleStartTime;

  void updateSchedule(List<Task> tasks) {
    _currentTasks = tasks;
    _scheduleStartTime = DateTime.now();
  }

  void clearSchedule() {
    _currentTasks = [];
    _scheduleStartTime = DateTime.now();
  }
}
