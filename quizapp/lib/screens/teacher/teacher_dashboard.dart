import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../database/database_helper.dart';
import '../../models/exam.dart';
import 'create_exam_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with SingleTickerProviderStateMixin {
  List<Exam> _exams = [];
  Map<int, int> _questionCounts = {};
  bool _isLoading = true;
  late AnimationController _fabAnimController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScaleAnimation = CurvedAnimation(
      parent: _fabAnimController,
      curve: Curves.elasticOut,
    );
    _loadExams();
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadExams() async {
    setState(() => _isLoading = true);
    try {
      final exams = await DatabaseHelper().getExams();
      final Map<int, int> counts = {};
      for (final exam in exams) {
        if (exam.id != null) {
          counts[exam.id!] = await DatabaseHelper().getQuestionCount(exam.id!);
        }
      }
      if (mounted) {
        setState(() {
          _exams = exams;
          _questionCounts = counts;
          _isLoading = false;
        });
        _fabAnimController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Failed to load exams: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.tealAccent[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _deleteExam(Exam exam) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Exam',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${exam.title}"? This action cannot be undone.',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && exam.id != null) {
      await DatabaseHelper().deleteExam(exam.id!);
      _showSnackBar('Exam deleted successfully');
      _loadExams();
    }
  }

  Future<void> _navigateToCreateExam() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CreateExamScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
    _loadExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Teacher Dashboard',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF283593)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
          onPressed: _loadExams,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6A1B9A),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildBody() {
    if (_exams.isEmpty) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      onRefresh: _loadExams,
      color: const Color(0xFF6A1B9A),
      backgroundColor: const Color(0xFF1a1a2e),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          return _buildExamCard(_exams[index], index);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6A1B9A).withOpacity(0.2),
                  const Color(0xFF283593).withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF6A1B9A).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Color(0xFF9575CD),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'No Exams Yet',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Tap the button below to create your first exam and start testing your students.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white38,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 36),
          OutlinedButton.icon(
            onPressed: _navigateToCreateExam,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              'Create Exam',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.tealAccent,
              side: const BorderSide(color: Colors.tealAccent, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(Exam exam, int index) {
    final questionCount = _questionCounts[exam.id] ?? 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: ValueKey(exam.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
            size: 28,
          ),
        ),
        confirmDismiss: (_) async {
          await _deleteExam(exam);
          return false;
        },
        child: GestureDetector(
          onLongPress: () => _deleteExam(exam),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A1B9A).withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: const Color(0xFF6A1B9A).withOpacity(0.1),
                highlightColor: Colors.white.withOpacity(0.03),
                onTap: () {
                  // Navigate to exam detail/edit if needed
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF6A1B9A).withOpacity(0.25),
                                  const Color(0xFF283593).withOpacity(0.25),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.assignment_outlined,
                              color: Color(0xFFB39DDB),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              exam.title,
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: Colors.white38,
                              size: 20,
                            ),
                            color: const Color(0xFF1a1a2e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deleteExam(exam);
                              }
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete_outline,
                                        color: Colors.redAccent, size: 18),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Delete',
                                      style: GoogleFonts.poppins(
                                        color: Colors.redAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (exam.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          exam.description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white38,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildStatChip(
                              Icons.help_outline_rounded,
                              '$questionCount Questions',
                              Colors.tealAccent,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 1,
                              height: 20,
                              color: Colors.white.withOpacity(0.08),
                            ),
                            const SizedBox(width: 6),
                            _buildStatChip(
                              Icons.timer_outlined,
                              '${exam.durationMinutes} min',
                              const Color(0xFFB39DDB),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color.withOpacity(0.8)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.9),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _navigateToCreateExam,
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFF283593)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A1B9A).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'Create Exam',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
