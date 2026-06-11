import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../database/database_helper.dart';
import '../../models/exam.dart';
import '../../models/result.dart';
import 'take_exam_screen.dart';
import 'result_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Exam> _exams = [];
  List<Result> _results = [];
  bool _isLoadingExams = true;
  bool _isLoadingResults = true;
  final Map<int, int> _questionCounts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 1) {
        _loadResults();
      }
    });
    _loadExams();
    _loadResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadExams() async {
    setState(() => _isLoadingExams = true);
    try {
      final exams = await DatabaseHelper().getExams();
      _questionCounts.clear();
      for (final exam in exams) {
        if (exam.id != null) {
          final count = await DatabaseHelper().getQuestionCount(exam.id!);
          _questionCounts[exam.id!] = count;
        }
      }
      if (mounted) {
        setState(() {
          _exams = exams;
          _isLoadingExams = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingExams = false);
      }
    }
  }

  Future<void> _loadResults() async {
    setState(() => _isLoadingResults = true);
    try {
      final results = await DatabaseHelper().getAllResults();
      if (mounted) {
        setState(() {
          _results = results;
          _isLoadingResults = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingResults = false);
      }
    }
  }

  void _showStartExamDialog(Exam exam) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.indigo.shade400,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter Your Name',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide your name to start\n"${exam.title}"',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Your full name',
                    hintStyle: GoogleFonts.poppins(color: Colors.white30),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: Colors.deepPurple.shade300,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF16213e),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.deepPurple.shade300,
                        width: 1.5,
                      ),
                    ),
                    errorStyle: GoogleFonts.poppins(fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Cancel',
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
                              Colors.indigo.shade500,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(ctx);
                              _navigateToExam(exam, nameController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Start',
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
      ),
    );
  }

  Future<void> _navigateToExam(Exam exam, String studentName) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TakeExamScreen(exam: exam, studentName: studentName),
      ),
    );
    _loadExams();
    _loadResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade900,
                const Color(0xFF16213e),
                Colors.indigo.shade900,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Portal',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Take exams & view your results',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _loadExams();
                          _loadResults();
                        },
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.cyanAccent,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.cyanAccent,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.assignment_outlined, size: 20),
                      text: 'Available Exams',
                    ),
                    Tab(
                      icon: Icon(Icons.analytics_outlined, size: 20),
                      text: 'My Results',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExamsTab(),
          _buildResultsTab(),
        ],
      ),
    );
  }

  Widget _buildExamsTab() {
    if (_isLoadingExams) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      );
    }

    if (_exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 80,
              color: Colors.deepPurple.shade800,
            ),
            const SizedBox(height: 20),
            Text(
              'No Exams Available',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new exams',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white30,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadExams,
      color: Colors.deepPurple,
      backgroundColor: const Color(0xFF1a1a2e),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          final exam = _exams[index];
          final questionCount = _questionCounts[exam.id] ?? 0;
          return _buildExamCard(exam, questionCount, index);
        },
      ),
    );
  }

  Widget _buildExamCard(Exam exam, int questionCount, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e).withOpacity(0.8),
            ],
          ),
          border: Border.all(
            color: Colors.deepPurple.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade600,
                          Colors.indigo.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.quiz_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.title,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (exam.description.isNotEmpty)
                          Text(
                            exam.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white54,
                              height: 1.4,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoChip(
                      Icons.timer_outlined,
                      '${exam.durationMinutes} min',
                      Colors.cyanAccent,
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.white12,
                    ),
                    _buildInfoChip(
                      Icons.help_outline_rounded,
                      '$questionCount Questions',
                      Colors.amber,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Container(
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
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _showStartExamDialog(exam),
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: Text(
                      'Start Exam',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsTab() {
    if (_isLoadingResults) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Colors.deepPurple.shade800,
            ),
            const SizedBox(height: 20),
            Text(
              'No Results Yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete an exam to see your results',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white30,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResults,
      color: Colors.deepPurple,
      backgroundColor: const Color(0xFF1a1a2e),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          return _buildResultCard(result, index);
        },
      ),
    );
  }

  Widget _buildResultCard(Result result, int index) {
    final percentage = result.total > 0
        ? (result.score / result.total * 100)
        : 0.0;
    final passed = percentage >= 50;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e).withOpacity(0.8),
            ],
          ),
          border: Border.all(
            color: (passed ? Colors.tealAccent : Colors.redAccent)
                .withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: passed
                        ? [Colors.teal.shade600, Colors.cyan.shade700]
                        : [Colors.red.shade700, Colors.redAccent.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (passed ? Colors.tealAccent : Colors.redAccent)
                          .withOpacity(0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${percentage.round()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.examTitle ?? 'Unknown Exam',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.studentName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${result.score} / ${result.total}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (passed
                                    ? Colors.tealAccent
                                    : Colors.redAccent)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                passed
                                    ? Icons.check_circle_outline
                                    : Icons.cancel_outlined,
                                size: 14,
                                color: passed
                                    ? Colors.tealAccent
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                passed ? 'PASS' : 'FAIL',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: passed
                                      ? Colors.tealAccent
                                      : Colors.redAccent,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                passed
                    ? Icons.emoji_events_rounded
                    : Icons.sentiment_dissatisfied_rounded,
                color: passed
                    ? Colors.amber.withOpacity(0.7)
                    : Colors.white24,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
