import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/question.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String examTitle;
  final List<Question> questions;
  final Map<int, String> studentAnswers;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.examTitle,
    required this.questions,
    required this.studentAnswers,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimController;
  late AnimationController _fadeController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _fadeTimer;

  double get _percentage =>
      widget.total > 0 ? widget.score / widget.total * 100 : 0;

  bool get _passed => _percentage >= 50;

  @override
  void initState() {
    super.initState();

    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: _percentage / 100,
    ).animate(CurvedAnimation(
      parent: _scoreAnimController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scoreAnimController.forward();
    _fadeTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    _scoreAnimController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  String _getOptionText(Question q, String letter) {
    switch (letter) {
      case 'A':
        return q.optionA;
      case 'B':
        return q.optionB;
      case 'C':
        return q.optionC;
      case 'D':
        return q.optionD;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        _passed ? Colors.tealAccent : Colors.redAccent;
    final secondaryGradient = _passed
        ? [Colors.teal.shade700, Colors.cyan.shade800]
        : [Colors.red.shade800, Colors.redAccent.shade700];

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      'Exam Results',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Exam title
                    Text(
                      widget.examTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white38,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Animated circular score
                    AnimatedBuilder(
                      animation: _scoreAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          width: 190,
                          height: 190,
                          child: CustomPaint(
                            painter: _ScoreCirclePainter(
                              progress: _scoreAnimation.value,
                              primaryColor: primaryColor,
                              backgroundColor:
                                  Colors.white.withOpacity(0.06),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(_scoreAnimation.value * 100).round()}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.score} / ${widget.total}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Pass / Fail badge
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.scale(
                            scale: 0.8 + (_fadeAnimation.value * 0.2),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: secondaryGradient,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _passed
                                  ? Icons.emoji_events_rounded
                                  : Icons.sentiment_dissatisfied_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _passed
                                  ? 'Congratulations! You Passed!'
                                  : 'Better Luck Next Time',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats row
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a2e),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              'Correct',
                              '${widget.score}',
                              Colors.tealAccent,
                              Icons.check_circle_outline,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white10,
                            ),
                            _buildStatItem(
                              'Wrong',
                              '${widget.total - widget.score}',
                              Colors.redAccent,
                              Icons.cancel_outlined,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white10,
                            ),
                            _buildStatItem(
                              'Total',
                              '${widget.total}',
                              Colors.cyanAccent,
                              Icons.quiz_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Question Review Header
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.fact_check_outlined,
                              color: Colors.deepPurple.shade200,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Question Review',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Questions list
                    ...List.generate(widget.questions.length, (index) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildQuestionReviewCard(index),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Back button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade500,
                              Colors.indigo.shade600,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(
                              Icons.dashboard_rounded, size: 22),
                          label: Text(
                            'Back to Dashboard',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionReviewCard(int index) {
    final question = widget.questions[index];
    final studentAnswer = widget.studentAnswers[index];
    final isCorrect = studentAnswer == question.correctOption;
    final isUnanswered = studentAnswer == null;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isUnanswered) {
      statusColor = Colors.grey;
      statusIcon = Icons.remove_circle_outline;
      statusText = 'Not Answered';
    } else if (isCorrect) {
      statusColor = Colors.tealAccent;
      statusIcon = Icons.check_circle_rounded;
      statusText = 'Correct';
    } else {
      statusColor = Colors.redAccent;
      statusIcon = Icons.cancel_rounded;
      statusText = 'Incorrect';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF1a1a2e),
        border: Border.all(
          color: statusColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple.shade200,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(statusIcon, size: 18, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question text
            Text(
              question.questionText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.85),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),

            // Answers section
            if (!isUnanswered) ...[
              _buildAnswerRow(
                'Your Answer',
                '${studentAnswer!}. ${_getOptionText(question, studentAnswer)}',
                isCorrect ? Colors.tealAccent : Colors.redAccent,
                isCorrect
                    ? Icons.check_rounded
                    : Icons.close_rounded,
              ),
              const SizedBox(height: 8),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Not Answered',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            if (!isCorrect)
              _buildAnswerRow(
                'Correct Answer',
                '${question.correctOption}. ${_getOptionText(question, question.correctOption)}',
                Colors.tealAccent,
                Icons.check_rounded,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(
      String label, String answer, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white38,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  answer,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCirclePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color backgroundColor;

  _ScoreCirclePainter({
    required this.progress,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 10.0;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: [
          primaryColor.withOpacity(0.6),
          primaryColor,
        ],
        transform: const GradientRotation(-pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glow dot at the end
    if (progress > 0.01) {
      final endAngle = -pi / 2 + sweepAngle;
      final dotX = center.dx + radius * cos(endAngle);
      final dotY = center.dy + radius * sin(endAngle);

      final glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(dotX, dotY), 8, glowPaint);

      final dotPaint = Paint()..color = primaryColor;
      canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
