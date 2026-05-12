import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../utils/data.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _answered = false;
  bool _quizDone = false;
  late AnimationController _progressController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _loadQuestions();
  }

  void _loadQuestions() {
    final user = context.read<AppState>().currentUser;
    final ageGroup = user?.ageGroup ?? '5-8';
    _questions = QuizData.getForAge(ageGroup).take(10).toList();
    _progressController.forward(from: 0);
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
      }
    });
    _progressController.stop();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _answered = false;
        });
        _progressController.forward(from: 0);
      } else {
        _finishQuiz();
      }
    });
  }

  Future<void> _finishQuiz() async {
    setState(() => _quizDone = true);
    _confettiController.play();

    // Award tokens: 3 base + bonus for 5+ correct
    int tokens = 3;
    if (_score >= 5) tokens += 5;
    if (_score >= 8) tokens += 5;
    await context.read<AppState>().addTokens(tokens);
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _answered = false;
      _quizDone = false;
    });
    _loadQuestions();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_quizDone) return _ResultScreen(
      score: _score,
      total: _questions.length,
      onRestart: _restart,
      confettiController: _confettiController,
    );

    if (_questions.isEmpty) return const Center(child: Text('No questions found!'));

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quiz Time! 🧠',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppTheme.bgDark,
                            ),
                          ),
                          Text(
                            '${question.subject} • ${question.ageGroup} years',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.mintGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '⭐ $_score',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1}/${_questions.length}',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _progressController,
                          builder: (_, __) => Text(
                            '⏱ ${((1 - _progressController.value) * 20).toInt()}s',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: _progressController.value > 0.7
                                  ? Colors.red
                                  : const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          AppTheme.watermelonRed,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Question Card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Question
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF6C5CE7).withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          question.question,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),

                      if (question.hint != null && _answered) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.bananaYellow.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text('💡', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                question.hint!,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: const Color(0xFF636E72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Options
                      ...question.options.asMap().entries.map((e) {
                        return _OptionTile(
                          label: e.value,
                          index: e.key,
                          selectedIndex: _selectedOption,
                          correctIndex: question.correctIndex,
                          answered: _answered,
                          onTap: () => _selectOption(e.key),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final int index;
  final int? selectedIndex;
  final int correctIndex;
  final bool answered;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.correctIndex,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.transparent;
    Widget? trailingIcon;
    final letters = ['A', 'B', 'C', 'D'];

    if (answered) {
      if (index == correctIndex) {
        bgColor = AppTheme.mintGreen.withOpacity(0.15);
        borderColor = AppTheme.mintGreen;
        trailingIcon = const Icon(Icons.check_circle, color: AppTheme.mintGreen);
      } else if (index == selectedIndex) {
        bgColor = AppTheme.watermelonRed.withOpacity(0.15);
        borderColor = AppTheme.watermelonRed;
        trailingIcon =
            const Icon(Icons.cancel, color: AppTheme.watermelonRed);
      }
    } else if (selectedIndex == index) {
      bgColor = AppTheme.lavender.withOpacity(0.2);
      borderColor = AppTheme.lavender;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  letters[index],
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppTheme.bgDark,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }
}

// ===== RESULT SCREEN =====
class _ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;
  final ConfettiController confettiController;

  const _ResultScreen({
    required this.score,
    required this.total,
    required this.onRestart,
    required this.confettiController,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).toInt();
    final isGood = score >= 5;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isGood ? '🎉 शाबाश!' : '💪 Keep Trying!',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        color: AppTheme.bgDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isGood
                          ? 'Excellent performance!'
                          : 'Practice makes perfect!',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isGood
                              ? [AppTheme.mintGreen, AppTheme.turquoise]
                              : [AppTheme.peachOrange, AppTheme.watermelonRed],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isGood ? AppTheme.mintGreen : AppTheme.watermelonRed)
                                .withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$score/$total',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w800,
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$percentage%',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Tokens earned
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.bananaYellow.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Text(
                            'Earned: ${score >= 8 ? 13 : score >= 5 ? 8 : 3} tokens!',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color(0xFFE67E22),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    GradientButton(
                      label: 'Play Again! 🔄',
                      onTap: onRestart,
                      width: double.infinity,
                      colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                    ),
                    const SizedBox(height: 14),
                    GradientButton(
                      label: 'Back to Home 🏠',
                      onTap: () => Navigator.pop(context),
                      width: double.infinity,
                      colors: [AppTheme.skyBlue, AppTheme.turquoise],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.1,
              numberOfParticles: 30,
              gravity: 0.2,
              colors: const [
                AppTheme.watermelonRed,
                AppTheme.bananaYellow,
                AppTheme.mintGreen,
                AppTheme.skyBlue,
                AppTheme.lavender,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
