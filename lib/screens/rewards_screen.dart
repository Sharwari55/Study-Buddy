import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'puzzle_game_screen.dart';
import 'number_chase_screen.dart';
import 'art_studio_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  List<RewardModel> _rewards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final state = AppController.to;
    final rewards = await state.dbService.getRewards();
    if (mounted) {
      setState(() {
        _rewards = rewards;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (state) {
      final user = state.currentUser;
      if (user == null) return const SizedBox();

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
                                  blurRadius: 8),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '🎁 Reward Zone',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: AppTheme.bgDark,
                          ),
                        ),
                      ),
                      TokenBadge(tokens: user.tokens, large: true),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading 
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.watermelonRed))
                      : _rewards.isEmpty
                          ? Center(
                              child: Text(
                                'No rewards found.\nMaybe the database needs to be seeded?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: const Color(0xFF636E72),
                                ),
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                _buildCategorySection(context, state, '🎮 Mini Games', '🎮 Mini Games'),
                                const SizedBox(height: 20),
                                _buildCategorySection(context, state, '🎬 Fun Cartoons', '🎬 Fun Cartoons'),
                                const SizedBox(height: 20),
                                _buildCategorySection(context, state, '🏆 Special Badges', '🏆 Special Badges'),
                                const SizedBox(height: 20),
                              ],
                            ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCategorySection(BuildContext context, AppController state, String title, String category) {
    final categoryRewards = _rewards.where((r) => r.category == category).toList();
    if (categoryRewards.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppTheme.bgDark,
          ),
        ),
        const SizedBox(height: 12),
        ...categoryRewards.map((reward) {
          final isUnlocked = state.currentUser!.unlockedRewards.contains(reward.id);
          return _RewardItem(
            emoji: reward.emoji,
            name: reward.name,
            description: reward.description,
            cost: reward.cost,
            unlocked: isUnlocked,
            onUnlock: () => _unlockReward(context, state, reward),
            isSpecial: reward.isSpecial,
          );
        }),
      ],
    );
  }

  void _unlockReward(BuildContext context, AppController state, RewardModel reward) async {
    if (state.currentUser!.unlockedRewards.contains(reward.id)) {
      // Already unlocked, just use it
      if (reward.id == 'r1') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PuzzleGameScreen()),
        );
        return;
      } else if (reward.id == 'r2') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NumberChaseScreen()),
        );
        return;
      } else if (reward.id == 'r3') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ArtStudioScreen()),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Using ${reward.name}!', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
          backgroundColor: AppTheme.mintGreen,
        ),
      );
      return;
    }

    if (state.currentUser!.tokens < reward.cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Not enough tokens! Need ${reward.cost} tokens.',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.watermelonRed,
        ),
      );
      return;
    }

    await state.unlockReward(reward.id, reward.cost);
    
    if (mounted) {
      showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                'Unlocked!',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppTheme.bgDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${reward.name} is now unlocked!\nEnjoy your reward! 🌟',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: const Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Yay! 🎊',
                onTap: () => Navigator.pop(context),
                colors: [AppTheme.mintGreen, AppTheme.turquoise],
              ),
            ],
          ),
        ),
      ),
    );
    }
  }
}

class _RewardItem extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;
  final int cost;
  final bool unlocked;
  final VoidCallback onUnlock;
  final bool isSpecial;

  const _RewardItem({
    required this.emoji,
    required this.name,
    required this.description,
    required this.cost,
    required this.unlocked,
    required this.onUnlock,
    this.isSpecial = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isSpecial
            ? Border.all(
                color: AppTheme.bananaYellow,
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? const LinearGradient(
                      colors: [AppTheme.mintGreen, AppTheme.turquoise],
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade200, Colors.grey.shade300],
                    ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                unlocked ? emoji : '🔒',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.bgDark,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onUnlock,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: unlocked
                    ? const LinearGradient(
                        colors: [AppTheme.mintGreen, AppTheme.turquoise],
                      )
                    : LinearGradient(
                        colors: [
                          AppTheme.bananaYellow,
                          AppTheme.peachOrange,
                        ],
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (unlocked ? AppTheme.mintGreen : AppTheme.bananaYellow)
                        .withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '🪙 $cost',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    unlocked ? 'Use' : 'Unlock',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
