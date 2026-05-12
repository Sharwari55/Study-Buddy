import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _step = 0; // 0=welcome, 1=parental gate, 2=profile setup
  bool _parentalVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _step == 0
                ? _WelcomePage(onStart: () => setState(() => _step = 1))
                : _step == 1
                    ? _ParentalGatePage(
                        onVerified: () => setState(() {
                          _parentalVerified = true;
                          _step = 2;
                        }),
                      )
                    : const _ProfileSetupPage(),
          ),
        ),
      ),
    );
  }
}

// ===== STEP 0: WELCOME =====
class _WelcomePage extends StatelessWidget {
  final VoidCallback onStart;
  const _WelcomePage({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD32A), Color(0xFFFF6B35)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.bananaYellow.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                const Text('📚', style: TextStyle(fontSize: 72)),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'नमस्ते! 🙏',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w800,
                fontSize: 32,
                color: AppTheme.bgDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to Study Buddy',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: AppTheme.watermelonRed,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Learn amazing things, earn stars,\nand unlock fun rewards! 🌟',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: const Color(0xFF636E72),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            // Feature bubbles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _FeatureBubble(emoji: '📺', label: 'Watch\n& Learn'),
                _FeatureBubble(emoji: '🧠', label: 'Quiz\nChallenge'),
                _FeatureBubble(emoji: '🏆', label: 'Win\nRewards'),
              ],
            ),
            const SizedBox(height: 48),
            GradientButton(
              label: 'Let\'s Start! 🚀',
              onTap: onStart,
              width: double.infinity,
              colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
            ),
            const SizedBox(height: 16),
            Text(
              '🇮🇳 Made with ❤️ for Indian kids',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: const Color(0xFF636E72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureBubble extends StatelessWidget {
  final String emoji;
  final String label;
  const _FeatureBubble({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppTheme.bgDark,
          ),
        ),
      ],
    );
  }
}

// ===== STEP 1: PARENTAL GATE =====
class _ParentalGatePage extends StatefulWidget {
  final VoidCallback onVerified;
  const _ParentalGatePage({required this.onVerified});

  @override
  State<_ParentalGatePage> createState() => _ParentalGatePageState();
}

class _ParentalGatePageState extends State<_ParentalGatePage> {
  late int _num1, _num2;
  late int _answer;
  final _controller = TextEditingController();
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final rand = DateTime.now().millisecondsSinceEpoch;
    _num1 = (rand % 20) + 15;
    _num2 = (rand % 15) + 8;
    _answer = _num1 * _num2;
  }

  void _verify() {
    final entered = int.tryParse(_controller.text);
    if (entered == _answer) {
      widget.onVerified();
    } else {
      setState(() {
        _error = true;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👨‍👩‍👧', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 20),
          Text(
            'Parent Verification',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w800,
              fontSize: 26,
              color: AppTheme.bgDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To protect your child, please solve\nthis maths problem:',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: const Color(0xFF636E72),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E90FF), Color(0xFF00CEC9)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.skyBlue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              '$_num1 × $_num2 = ?',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w800,
                fontSize: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (_) => setState(() => _error = false),
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: AppTheme.bgDark,
            ),
            decoration: InputDecoration(
              hintText: 'Enter answer...',
              hintStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _error ? Colors.red : AppTheme.skyBlue,
                  width: 2,
                ),
              ),
              errorText: _error ? 'Wrong answer! Try again.' : null,
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            label: 'Verify & Continue ✅',
            onTap: _verify,
            width: double.infinity,
            colors: [AppTheme.mintGreen, AppTheme.turquoise],
          ),
        ],
      ),
    );
  }
}

// ===== STEP 2: PROFILE SETUP =====
class _ProfileSetupPage extends StatefulWidget {
  const _ProfileSetupPage();

  @override
  State<_ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<_ProfileSetupPage> {
  final _nicknameController = TextEditingController();
  String _selectedAgeGroup = '5-8';
  String _selectedAvatar = 'lion';
  bool _isCreating = false;

  Future<void> _createProfile() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a nickname!')),
      );
      return;
    }
    setState(() => _isCreating = true);
    await context.read<AppState>().createProfile(
          nickname: nickname,
          ageGroup: _selectedAgeGroup,
          avatarId: _selectedAvatar,
        );
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Create Your Profile! 🎉',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w800,
              fontSize: 26,
              color: AppTheme.bgDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Let\'s set up your learning adventure',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF636E72),
            ),
          ),
          const SizedBox(height: 28),

          // Nickname
          Text(
            '📝 Your Nickname',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              hintText: 'e.g. Arjun, Priya, Dev...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.skyBlue, width: 2),
              ),
              prefixIcon: const Icon(Icons.child_care, color: AppTheme.watermelonRed),
            ),
          ),
          const SizedBox(height: 22),

          // Age Group
          Text(
            '🎂 Age Group',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _AgeGroupChip(
                label: '2–5\nChhota',
                emoji: '👶',
                value: '2-5',
                selected: _selectedAgeGroup == '2-5',
                onTap: () => setState(() => _selectedAgeGroup = '2-5'),
              ),
              const SizedBox(width: 10),
              _AgeGroupChip(
                label: '5–8\nBachha',
                emoji: '🧒',
                value: '5-8',
                selected: _selectedAgeGroup == '5-8',
                onTap: () => setState(() => _selectedAgeGroup = '5-8'),
              ),
              const SizedBox(width: 10),
              _AgeGroupChip(
                label: '8–12\nBharat',
                emoji: '👦',
                value: '8-12',
                selected: _selectedAgeGroup == '8-12',
                onTap: () => setState(() => _selectedAgeGroup = '8-12'),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Avatar Selection
          Text(
            '🦁 Choose Your Avatar',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: AvatarOption.all.length,
            itemBuilder: (_, i) {
              final av = AvatarOption.all[i];
              final selected = _selectedAvatar == av.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = av.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? Color(int.parse(av.color.replaceAll('#', '0xFF')))
                            .withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: selected
                        ? Border.all(
                            color: Color(
                                int.parse(av.color.replaceAll('#', '0xFF'))),
                            width: 2.5,
                          )
                        : Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(av.emoji, style: const TextStyle(fontSize: 26)),
                      Text(
                        av.name,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          color: AppTheme.bgDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          GradientButton(
            label: _isCreating ? 'Creating...' : 'Start My Journey! 🚀',
            onTap: _isCreating ? () {} : _createProfile,
            width: double.infinity,
            colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AgeGroupChip extends StatelessWidget {
  final String label;
  final String emoji;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _AgeGroupChip({
    required this.label,
    required this.emoji,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                  )
                : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? AppTheme.watermelonRed.withOpacity(0.3)
                    : Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: selected ? Colors.white : AppTheme.bgDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
