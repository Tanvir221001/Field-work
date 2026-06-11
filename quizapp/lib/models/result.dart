class Result {
  final int? id;
  final int examId;
  final String studentName;
  final int score;
  final int total;
  final String completedAt;
  final String? examTitle; // joined field, not stored in DB

  Result({
    this.id,
    required this.examId,
    required this.studentName,
    required this.score,
    required this.total,
    required this.completedAt,
    this.examTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exam_id': examId,
      'student_name': studentName,
      'score': score,
      'total': total,
      'completed_at': completedAt,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      id: map['id'] as int?,
      examId: map['exam_id'] as int,
      studentName: map['student_name'] as String,
      score: map['score'] as int,
      total: map['total'] as int,
      completedAt: map['completed_at'] as String,
      examTitle: map['exam_title'] as String?,
    );
  }

  double get percentage => total > 0 ? (score / total) * 100 : 0;

  bool get passed => percentage >= 50;
}
