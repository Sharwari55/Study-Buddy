import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../widgets/widgets.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (_, state, __) {
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _rewardSection(
                        context: context,
                        title: '🎮 Mini Games',
                        items: [
                          _RewardItem(
                            emoji: '🧩',
                            name: 'Puzzle World',
                            description: 'Match shapes & colors',
                            cost: 10,
                            unlocked: user.tokens >= 10,
                            onUnlock: () => _unlockReward(context, state, 10, 'Puzzle World'),
                          ),
                          _RewardItem(
                            emoji: '🔢',
                            name: 'Number Chase',
                            description: 'Count & match numbers',
                            cost: 15,
                            unlocked: user.tokens >= 15,
                            onUnlock: () => _unlockReward(context, state, 15, 'Number Chase'),
                          ),
                          _RewardItem(
                            emoji: '🎨',
                            name: 'Art Studio',
                            description: 'Draw & color freely',
                            cost: 20,
                            unlocked: user.tokens >= 20,
                            onUnlock: () => _unlockReward(context, state, 20, 'Art Studio'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _rewardSection(
                        context: context,
                        title: '🎬 Fun Cartoons',
                        items: [
                          _RewardItem(
                            emoji: '🐘',
                            name: 'Gajapati Kulapati',
                            description: 'Classic Indian kids story',
                            cost: 25,
                            unlocked: user.tokens >= 25,
                            onUnlock: () => _unlockReward(context, state, 25, 'Gajapati Kulapati'),
                          ),
                          _RewardItem(
                            emoji: '🦁',
                            name: 'Jungle Tales',
                            description: 'Panchatantra stories',
                            cost: 30,
                            unlocked: user.tokens >= 30,
                            onUnlock: () => _unlockReward(context, state, 30, 'Jungle Tales'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _rewardSection(
                        context: context,
                        title: '🏆 Special Badges',
                        items: [
                          _RewardItem(
                            emoji: '🌟',
                            name: 'Star Scholar',
                            description: 'Show off your learning!',
                            cost: 50,
                            unlocked: user.tokens >= 50,
                            onUnlock: () => _unlockReward(context, state, 50, 'Star Scholar'),
                            isSpecial: true,
                          ),
                          _RewardItem(
                            emoji: '🇮🇳',
                            name: 'Bharat Champion',
                            description: 'India\'s top learner badge',
                            cost: 100,
                            unlocked: user.tokens >= 100,
                            onUnlock: () => _unlockReward(context, state, 100, 'Bharat Champion'),
                            isSpecial: true,
                          ),
                        ],
                      ),
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

  Widget _rewardSection({
    required BuildContext context,
    required String title,
    required List<_RewardItem> items,
  }) {
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
        ...items,
      ],
    );
  }

  void _unlockReward(
      BuildContext context, AppState state, int cost, String name) {
    if (state.currentUser!.tokens < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Not enough tokens! Need $cost tokens.',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.watermelonRed,
        ),
      );
      return;
    }
    state.spendTokens(cost);
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
                '$name is now unlocked!\nEnjoy your reward! 🌟',
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
