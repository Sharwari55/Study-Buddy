import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../widgets/widgets.dart';
import 'quiz_screen.dart';
import 'leaderboard_screen.dart';
import 'video_screen.dart';
import 'rewards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppController.to.updateStreak();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _DashboardTab(),
      const VideoScreen(),
      const QuizScreen(),
      const LeaderboardScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ===== BOTTOM NAV =====
class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('🏠', 'Home'),
      ('📺', 'Watch'),
      ('🧠', 'Quiz'),
      ('🏆', 'Ranks'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final isSelected = e.key == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.value.$1,
                            style: TextStyle(fontSize: isSelected ? 22 : 18)),
                        const SizedBox(height: 2),
                        FittedBox(
                          child: Text(
                            e.value.$2,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ===== DASHBOARD TAB =====
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (state) {
        final user = state.currentUser;
        if (user == null) return const SizedBox();

        return Container(
          decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      AvatarWidget(
                          avatarId: user.avatarId, size: 52, showBorder: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'नमस्ते, ${user.nickname}! 👋',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: AppTheme.bgDark,
                              ),
                            ),
                            Text(
                              'Ready to learn today?',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: const Color(0xFF636E72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TokenBadge(tokens: user.tokens),
                      const SizedBox(width: 8),
                      StreakBadge(streak: user.streak),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => state.logout(),
                        icon: const Icon(Icons.logout, color: AppTheme.watermelonRed, size: 24),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Hero Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C5CE7).withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Goal 🎯',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Earn 20 tokens today!\nWatch videos + Quiz',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.85),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Progress bar
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      Container(
                                        height: 8,
                                        width: constraints.maxWidth * (user.tokens / 20).clamp(0.0, 1.0),
                                        decoration: BoxDecoration(
                                          color: AppTheme.bananaYellow,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${user.tokens.clamp(0, 20)}/20 tokens',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text('🎯', style: TextStyle(fontSize: 60)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'What do you want to do? 🌟',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppTheme.bgDark,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Main sections
                  SectionCard(
                    title: 'Watch & Learn 📺',
                    subtitle: 'Educational videos • Earn tokens',
                    emoji: '🎬',
                    gradientColors: [Color(0xFF1E90FF), Color(0xFF00CEC9)],
                    badge: '+1 Token/5min',
                    onTap: () {
                      // Navigate to video tab
                    },
                  ),
                  SectionCard(
                    title: 'Quiz Challenge 🧠',
                    subtitle: 'Test your knowledge • Win bonus tokens',
                    emoji: '⚡',
                    gradientColors: [Color(0xFFFF4757), Color(0xFFFF6B35)],
                    badge: '+3 Tokens',
                    onTap: () {
                      Get.to(() => const QuizScreen());
                    },
                  ),
                  SectionCard(
                    title: 'Reward Zone 🎁',
                    subtitle: 'Unlock games & fun activities',
                    emoji: '🎮',
                    gradientColors: [Color(0xFF2ED573), Color(0xFF1ABC9C)],
                    badge: '${user.tokens} tokens',
                    onTap: () {
                      Get.to(() => const RewardsScreen());
                    },
                  ),
                  SectionCard(
                    title: 'Hall of Fame 🏆',
                    subtitle: 'See top learners across India',
                    emoji: '👑',
                    gradientColors: [Color(0xFFFFD32A), Color(0xFFFF9F43)],
                    onTap: () {
                      Get.to(() => const LeaderboardScreen());
                    },
                  ),

                  const SizedBox(height: 8),
                  // Stats Row
                  Row(
                    children: [
                      _StatCard(
                          emoji: '⭐',
                          value: '${user.tokens}',
                          label: 'Tokens',
                          color: AppTheme.bananaYellow),
                      const SizedBox(width: 12),
                      _StatCard(
                          emoji: '🔥',
                          value: '${user.streak}',
                          label: 'Day Streak',
                          color: AppTheme.watermelonRed),
                      const SizedBox(width: 12),
                      _StatCard(
                          emoji: '📺',
                          value: '${user.totalWatchMinutes}',
                          label: 'Minutes',
                          color: AppTheme.skyBlue),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: const Color(0xFF636E72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
