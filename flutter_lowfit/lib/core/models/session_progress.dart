class SessionProgress {
  final int completed;
  final int total;

  SessionProgress({
    required this.completed,
    required this.total,
  });

  factory SessionProgress.fromJson(Map<String, dynamic> json) {
    return SessionProgress(
      completed: json['completed'] as int,
      total: json['total'] as int,
    );
  }
}