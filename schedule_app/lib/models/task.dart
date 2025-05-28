class Task {
  final String name;
  final int duration;
  final DateTime startTime;
  final DateTime endTime;

  Task({
    required this.name,
    required this.duration,
    required this.startTime,
    required this.endTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'] as String,
      duration: json['duration'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}
