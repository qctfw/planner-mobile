class Plan {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deadlineAt;
  final DateTime? doneAt;

  const Plan({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deadlineAt,
    required this.doneAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deadlineAt: DateTime.parse(json['deadline_at']),
        doneAt: (json['done_at'] != null) ? DateTime.parse(json['done_at']) : null
    );
  }
}

class ApiPreferences {
  static const String baseUrl = 'http://06d6-2001-448a-2020-ea08-5021-76e2-330-5308.ap.ngrok.io';
}