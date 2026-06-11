
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../models/result.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await openDatabase(
        'quiz_app.db',
        version: 1,
        onCreate: _onCreate,
      );
    }

    if (!kIsWeb && 
        (defaultTargetPlatform == TargetPlatform.windows || 
         defaultTargetPlatform == TargetPlatform.linux || 
         defaultTargetPlatform == TargetPlatform.macOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quiz_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_option TEXT NOT NULL,
        FOREIGN KEY (exam_id) REFERENCES exams (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER NOT NULL,
        student_name TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        completed_at TEXT NOT NULL,
        FOREIGN KEY (exam_id) REFERENCES exams (id) ON DELETE CASCADE
      )
    ''');
  }

  // ── Exam CRUD ──────────────────────────────────────────────

  Future<int> insertExam(Exam exam) async {
    final db = await database;
    return await db.insert('exams', exam.toMap());
  }

  Future<List<Exam>> getExams() async {
    final db = await database;
    final maps = await db.query('exams', orderBy: 'created_at DESC');
    return maps.map((map) => Exam.fromMap(map)).toList();
  }

  Future<Exam?> getExamById(int id) async {
    final db = await database;
    final maps = await db.query('exams', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Exam.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteExam(int id) async {
    final db = await database;
    // Delete associated questions and results first
    await db.delete('questions', where: 'exam_id = ?', whereArgs: [id]);
    await db.delete('results', where: 'exam_id = ?', whereArgs: [id]);
    return await db.delete('exams', where: 'id = ?', whereArgs: [id]);
  }

  // ── Question CRUD ──────────────────────────────────────────

  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('questions', question.toMap());
  }

  Future<void> insertQuestions(List<Question> questions) async {
    final db = await database;
    final batch = db.batch();
    for (final q in questions) {
      batch.insert('questions', q.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Question>> getQuestionsByExamId(int examId) async {
    final db = await database;
    final maps = await db.query(
      'questions',
      where: 'exam_id = ?',
      whereArgs: [examId],
    );
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  Future<int> getQuestionCount(int examId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM questions WHERE exam_id = ?',
      [examId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ── Result CRUD ────────────────────────────────────────────

  Future<int> insertResult(Result result) async {
    final db = await database;
    return await db.insert('results', result.toMap());
  }

  Future<List<Result>> getAllResults() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT results.*, exams.title as exam_title
      FROM results
      LEFT JOIN exams ON results.exam_id = exams.id
      ORDER BY results.completed_at DESC
    ''');
    return maps.map((map) => Result.fromMap(map)).toList();
  }

  Future<List<Result>> getResultsByExamId(int examId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT results.*, exams.title as exam_title
      FROM results
      LEFT JOIN exams ON results.exam_id = exams.id
      WHERE results.exam_id = ?
      ORDER BY results.completed_at DESC
    ''', [examId]);
    return maps.map((map) => Result.fromMap(map)).toList();
  }
}
