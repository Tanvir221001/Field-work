import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../database/database_helper.dart';
import '../../models/exam.dart';
import '../../models/question.dart';

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _scrollController = ScrollController();

  bool _isSaving = false;

  // Each question is a map with:
  // 'questionController', 'optionControllers' (List<TextEditingController>), 'correctAnswer' (int 0-3)
  final List<Map<String, dynamic>> _questions = [];

  late AnimationController _saveButtonAnimController;
  late Animation<double> _saveButtonPulse;

  @override
  void initState() {
    super.initState();
    _saveButtonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _saveButtonPulse = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _saveButtonAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _scrollController.dispose();
    _saveButtonAnimController.dispose();
    for (final q in _questions) {
      (q['questionController'] as TextEditingController).dispose();
      for (final c in (q['optionControllers'] as List<TextEditingController>)) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add({
        'questionController': TextEditingController(),
        'optionControllers': List.generate(4, (_) => TextEditingController()),
        'correctAnswer': 0,
      });
    });
    // Scroll to bottom after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _removeQuestion(int index) {
    final q = _questions[index];
    (q['questionController'] as TextEditingController).dispose();
    for (final c in (q['optionControllers'] as List<TextEditingController>)) {
      c.dispose();
    }
    setState(() {
      _questions.removeAt(index);
    });
  }

  Future<void> _saveExam() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Check at least one question
    if (_questions.isEmpty) {
      _showSnackBar('Please add at least one question.', isError: true);
      return;
    }

    // Validate all question fields
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final questionText =
          (q['questionController'] as TextEditingController).text.trim();
      if (questionText.isEmpty) {
        _showSnackBar('Question ${i + 1} text is empty.', isError: true);
        return;
      }
      final opts = q['optionControllers'] as List<TextEditingController>;
      for (int j = 0; j < opts.length; j++) {
        if (opts[j].text.trim().isEmpty) {
          final labels = ['A', 'B', 'C', 'D'];
          _showSnackBar(
            'Option ${labels[j]} in Question ${i + 1} is empty.',
            isError: true,
          );
          return;
        }
      }
    }

    setState(() => _isSaving = true);

    try {
      // Create exam object
      final exam = Exam(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        durationMinutes: int.tryParse(_durationController.text.trim()) ?? 30,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Insert exam and get the ID
      final examId = await DatabaseHelper().insertExam(exam);

      // Build question objects
      final List<Question> questions = _questions.map((q) {
        final opts = q['optionControllers'] as List<TextEditingController>;
        final correctIdx = q['correctAnswer'] as int;
        return Question(
          examId: examId,
          questionText: (q['questionController'] as TextEditingController)
              .text
              .trim(),
          optionA: opts[0].text.trim(),
          optionB: opts[1].text.trim(),
          optionC: opts[2].text.trim(),
          optionD: opts[3].text.trim(),
          correctOption: ['A', 'B', 'C', 'D'][correctIdx],
        );
      }).toList();

      // Insert all questions
      await DatabaseHelper().insertQuestions(questions);

      if (mounted) {
        _showSnackBar('Exam created successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to save exam: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.tealAccent[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: Colors.white38,
        fontSize: 14,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: const Color(0xFF9575CD), size: 20)
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF6A1B9A),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      errorStyle: GoogleFonts.poppins(fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExamDetailsSection(),
              const SizedBox(height: 32),
              _buildQuestionsHeader(),
              const SizedBox(height: 16),
              ..._buildQuestionCards(),
              const SizedBox(height: 16),
              _buildAddQuestionButton(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Create Exam',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white70, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF283593)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildExamDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            color: const Color(0xFF6A1B9A).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF6A1B9A).withOpacity(0.2),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: Color(0xFFB39DDB), size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Exam Details',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration('Exam Title', icon: Icons.title),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Title is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            decoration:
                _inputDecoration('Description', icon: Icons.description),
            maxLines: 3,
            minLines: 2,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Description is required'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _durationController,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            decoration:
                _inputDecoration('Duration (minutes)', icon: Icons.timer),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Duration is required';
              final val = int.tryParse(v);
              if (val == null || val <= 0) return 'Enter a valid duration';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.tealAccent.withOpacity(0.15),
          ),
          child: const Icon(Icons.quiz_outlined,
              color: Colors.tealAccent, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          'Questions',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.tealAccent.withOpacity(0.12),
          ),
          child: Text(
            '${_questions.length}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.tealAccent,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildQuestionCards() {
    return List.generate(_questions.length, (index) {
      return TweenAnimationBuilder<double>(
        key: ValueKey('question_$index'),
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: _buildQuestionCard(index),
      );
    });
  }

  Widget _buildQuestionCard(int index) {
    final q = _questions[index];
    final questionController = q['questionController'] as TextEditingController;
    final optionControllers =
        q['optionControllers'] as List<TextEditingController>;
    final correctAnswer = q['correctAnswer'] as int;
    final labels = ['A', 'B', 'C', 'D'];
    final optionColors = [
      Colors.cyanAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFF283593)],
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Question ${index + 1}',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _removeQuestion(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent.withOpacity(0.12),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question text field
          TextFormField(
            controller: questionController,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration('Enter question text',
                icon: Icons.help_outline_rounded),
            maxLines: 2,
            minLines: 1,
          ),
          const SizedBox(height: 16),

          // Option fields
          ...List.generate(4, (optIdx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  // Option label badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: optionColors[optIdx].withOpacity(
                        correctAnswer == optIdx ? 0.25 : 0.1,
                      ),
                      border: correctAnswer == optIdx
                          ? Border.all(
                              color: optionColors[optIdx].withOpacity(0.6),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        labels[optIdx],
                        style: GoogleFonts.poppins(
                          color: optionColors[optIdx],
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: optionControllers[optIdx],
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Option ${labels[optIdx]}',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white24,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.04),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.06),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: optionColors[optIdx].withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),

          // Correct answer selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.tealAccent.withOpacity(0.06),
              border: Border.all(
                color: Colors.tealAccent.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.tealAccent, size: 18),
                const SizedBox(width: 10),
                Text(
                  'Correct:',
                  style: GoogleFonts.poppins(
                    color: Colors.tealAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                ...List.generate(4, (optIdx) {
                  final isSelected = correctAnswer == optIdx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _questions[index]['correctAnswer'] = optIdx;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: 38,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected
                              ? optionColors[optIdx].withOpacity(0.2)
                              : Colors.white.withOpacity(0.04),
                          border: Border.all(
                            color: isSelected
                                ? optionColors[optIdx].withOpacity(0.6)
                                : Colors.white.withOpacity(0.08),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            labels[optIdx],
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? optionColors[optIdx]
                                  : Colors.white38,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddQuestionButton() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _addQuestion,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.tealAccent.withOpacity(0.3),
                width: 1.5,
              ),
              color: Colors.tealAccent.withOpacity(0.06),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.tealAccent.withOpacity(0.15),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.tealAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add Question',
                  style: GoogleFonts.poppins(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return AnimatedBuilder(
      animation: _saveButtonPulse,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveExam,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xFF6A1B9A),
                        const Color(0xFF8E24AA),
                        _saveButtonPulse.value,
                      )!,
                      const Color(0xFF283593),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A1B9A).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save_rounded,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Save Exam',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
