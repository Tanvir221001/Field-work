class Exam {
  final int? id;
  final String title;
  final String description;
  final int durationMinutes;
  final String createdAt;

  Exam({
    this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration_minutes': durationMinutes,
      'created_at': createdAt,
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      durationMinutes: map['duration_minutes'] as int,
      createdAt: map['created_at'] as String,
    );
  }

  Exam copyWith({
    int? id,
    String? title,
    String? description,
    int? durationMinutes,
    String? createdAt,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
