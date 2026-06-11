import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../database/database_helper.dart';
import '../../models/exam.dart';
import '../../models/question.dart';
import '../../models/result.dart';
import 'result_screen.dart';

class TakeExamScreen extends StatefulWidget {
  final Exam exam;
  final String studentName;

  const TakeExamScreen({
    super.key,
    required this.exam,
    required this.studentName,
  });

  @override
  State<TakeExamScreen> createState() => _TakeExamScreenState();
}

class _TakeExamScreenState extends State<TakeExamScreen>
    with TickerProviderStateMixin {
  List<Question> _questions = [];
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};

  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;

  late AnimationController _optionAnimController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.exam.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _pageController = PageController();
    _optionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _optionAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions =
          await DatabaseHelper().getQuestionsByExamId(widget.exam.id!);
      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _submitExam(autoSubmit: true);
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Color _getTimerColor() {
    final fraction = _remainingSeconds / _totalSeconds;
    if (fraction > 0.5) return Colors.tealAccent;
    if (fraction > 0.2) return Colors.amber;
    return Colors.redAccent;
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _selectOption(int questionIndex, String option) {
    setState(() {
      _selectedAnswers[questionIndex] = option;
    });
  }

  void _goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      setState(() {
        _currentQuestionIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _goToQuestion(_currentQuestionIndex - 1);
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _goToQuestion(_currentQuestionIndex + 1);
    }
  }

  Future<void> _showSubmitDialog() async {
    final answeredCount = _selectedAnswers.length;
    final totalCount = _questions.length;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_rounded,
                  color: Colors.amber,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Submit Exam?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildDialogStat(
                      'Answered',
                      '$answeredCount / $totalCount',
                      Colors.tealAccent,
                    ),
                    if (answeredCount < totalCount) ...[
                      const SizedBox(height: 8),
                      _buildDialogStat(
                        'Unanswered',
                        '${totalCount - answeredCount}',
                        Colors.redAccent,
                      ),
                    ],
                  ],
                ),
              ),
              if (answeredCount < totalCount) ...[
                const SizedBox(height: 12),
                Text(
                  'You have unanswered questions.\nAre you sure you want to submit?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.amber.shade200,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Review',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade500,
                            Colors.indigo.shade600,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      _submitExam();
    }
  }

  Widget _buildDialogStat(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.white54,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _submitExam({bool autoSubmit = false}) async {
    _timer?.cancel();

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final selectedAnswer = _selectedAnswers[i];
      if (selectedAnswer != null &&
          selectedAnswer == question.correctOption) {
        score++;
      }
    }

    final result = Result(
      examId: widget.exam.id!,
      examTitle: widget.exam.title,
      studentName: widget.studentName,
      score: score,
      total: _questions.length,
      completedAt: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper().insertResult(result);

    if (mounted) {
      if (autoSubmit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '⏰ Time\'s up! Exam auto-submitted.',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.deepPurple.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: score,
            total: _questions.length,
            examTitle: widget.exam.title,
            questions: _questions,
            studentAnswers: _selectedAnswers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0a0a1a),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.deepPurple),
              const SizedBox(height: 20),
              Text(
                'Loading questions...',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0a0a1a),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.white24),
              const SizedBox(height: 16),
              Text(
                'No questions found for this exam.',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildTimerSection(),
            _buildQuestionDots(),
            Expanded(child: _buildQuestionPageView()),
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF1a1a2e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Leave Exam?',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Text(
                      'Your progress will be lost if you leave now.',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Stay',
                          style: GoogleFonts.poppins(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _timer?.cancel();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Leave',
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exam.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.studentName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${_selectedAnswers.length}/${_questions.length}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    final fraction = _totalSeconds > 0
        ? _remainingSeconds / _totalSeconds
        : 0.0;
    final timerColor = _getTimerColor();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 6,
                  color: Colors.white.withOpacity(0.06),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Animated progress circle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: fraction, end: fraction),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: fraction,
                      strokeWidth: 6,
                      color: timerColor,
                      backgroundColor: Colors.transparent,
                      strokeCap: StrokeCap.round,
                    ),
                  );
                },
              ),
              // Glow effect
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      timerColor.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Time text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: timerColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: timerColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'remaining',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: Colors.white30,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionDots() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final isActive = index == _currentQuestionIndex;
          final isAnswered = _selectedAnswers.containsKey(index);

          return GestureDetector(
            onTap: () => _goToQuestion(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isActive ? 38 : 30,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.indigo.shade500,
                        ],
                      )
                    : null,
                color: isActive
                    ? null
                    : isAnswered
                        ? Colors.tealAccent.withOpacity(0.2)
                        : Colors.white.withOpacity(0.06),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : isAnswered
                          ? Colors.tealAccent.withOpacity(0.4)
                          : Colors.white12,
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? Colors.white
                        : isAnswered
                            ? Colors.tealAccent
                            : Colors.white38,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentQuestionIndex = index;
        });
      },
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        return _buildQuestionView(index);
      },
    );
  }

  Widget _buildQuestionView(int questionIndex) {
    final question = _questions[questionIndex];
    final selectedOption = _selectedAnswers[questionIndex];
    final options = [
      {'letter': 'A', 'text': question.optionA},
      {'letter': 'B', 'text': question.optionB},
      {'letter': 'C', 'text': question.optionC},
      {'letter': 'D', 'text': question.optionD},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question counter
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Question ${questionIndex + 1} of ${_questions.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                ],
              ),
              border: Border.all(
                color: Colors.deepPurple.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              question.questionText,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.92),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Options
          ...options.map((option) {
            final letter = option['letter']!;
            final text = option['text']!;
            final isSelected = selectedOption == letter;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _selectOption(questionIndex, letter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.deepPurple.shade600,
                              Colors.indigo.shade700,
                            ],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : const Color(0xFF1a1a2e).withOpacity(0.6),
                    border: Border.all(
                      color: isSelected
                          ? Colors.deepPurple.shade300
                          : Colors.white.withOpacity(0.08),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  Colors.deepPurple.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    Colors.tealAccent.shade400,
                                    Colors.cyanAccent.shade400,
                                  ],
                                )
                              : null,
                          color: isSelected
                              ? null
                              : Colors.white.withOpacity(0.06),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.white12,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: Colors.white,
                                )
                              : Text(
                                  letter,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white54,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          text,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0f0f22),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: AnimatedOpacity(
              opacity: _currentQuestionIndex > 0 ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 200),
              child: OutlinedButton.icon(
                onPressed:
                    _currentQuestionIndex > 0 ? _previousQuestion : null,
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                label: Text(
                  'Previous',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: BorderSide(color: Colors.white.withOpacity(0.15)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Submit Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade500,
                  Colors.indigo.shade600,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _showSubmitDialog,
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                'Submit',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Next Button
          Expanded(
            child: AnimatedOpacity(
              opacity: _currentQuestionIndex < _questions.length - 1
                  ? 1.0
                  : 0.4,
              duration: const Duration(milliseconds: 200),
              child: OutlinedButton.icon(
                onPressed: _currentQuestionIndex < _questions.length - 1
                    ? _nextQuestion
                    : null,
                icon: Text(
                  'Next',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: _currentQuestionIndex < _questions.length - 1
                        ? Colors.white70
                        : Colors.white30,
                  ),
                ),
                label: const Icon(Icons.chevron_right_rounded, size: 22),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: BorderSide(color: Colors.white.withOpacity(0.15)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
