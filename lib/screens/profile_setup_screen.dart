import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
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
    await AppController.to.createProfile(
          nickname: nickname,
          ageGroup: _selectedAgeGroup,
          avatarId: _selectedAvatar,
        );
    if (mounted) {
      Get.off(() => const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Create Your Profile! 🎉',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    color: AppTheme.bgDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let\'s set up your learning adventure',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF636E72),
                  ),
                ),
                const SizedBox(height: 40),

                // Nickname
                Text(
                  '📝 Your Nickname',
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _nicknameController,
                  hint: 'e.g. Arjun, Priya, Dev...',
                  icon: Icons.child_care,
                ),
                const SizedBox(height: 32),

                // Age Group
                Text(
                  '🎂 Age Group',
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _AgeGroupChip(
                      label: '2–5\nChhota',
                      emoji: '👶',
                      value: '2-5',
                      selected: _selectedAgeGroup == '2-5',
                      onTap: () => setState(() => _selectedAgeGroup = '2-5'),
                    ),
                    const SizedBox(width: 12),
                    _AgeGroupChip(
                      label: '5–8\nBachha',
                      emoji: '🧒',
                      value: '5-8',
                      selected: _selectedAgeGroup == '5-8',
                      onTap: () => setState(() => _selectedAgeGroup = '5-8'),
                    ),
                    const SizedBox(width: 12),
                    _AgeGroupChip(
                      label: '8–12\nBharat',
                      emoji: '👦',
                      value: '8-12',
                      selected: _selectedAgeGroup == '8-12',
                      onTap: () => setState(() => _selectedAgeGroup = '8-12'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Avatar Selection
                Text(
                  '🦁 Choose Your Avatar',
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
                          borderRadius: BorderRadius.circular(16),
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
                            Text(av.emoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 4),
                            Text(
                              av.name,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppTheme.bgDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                GradientButton(
                  label: _isCreating ? 'Creating...' : 'Start My Journey! 🚀',
                  onTap: _isCreating ? () {} : _createProfile,
                  width: double.infinity,
                  colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.watermelonRed),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                  )
                : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
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
