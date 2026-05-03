class ProjectModel {
  final String id;
  final String name;
  final String client;
  final double progress;
  final String manager;
  final String status;
  final int taskCount;
  final DateTime startDate;
  final DateTime? endDate;

  ProjectModel({
    required this.id,
    required this.name,
    required this.client,
    required this.progress,
    required this.manager,
    required this.status,
    required this.taskCount,
    required this.startDate,
    this.endDate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      client: json['client'] as String,
      progress: (json['progress'] as num).toDouble(),
      manager: json['manager'] as String,
      status: json['status'] as String,
      taskCount: json['task_count'] as int,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'client': client,
      'progress': progress,
      'manager': manager,
      'status': status,
      'task_count': taskCount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
