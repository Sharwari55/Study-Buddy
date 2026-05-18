import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (state) {
      final board = state.leaderboard;
      final currentUser = state.currentUser;

      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2D3436), Color(0xFF1A1A2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          if (Navigator.canPop(context))
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          if (Navigator.canPop(context))
                            const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '🏆 Hall of Fame',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text('🇮🇳', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),

                    // Podium (Top 3)
                    if (board.length >= 3)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _PodiumWidget(
                          first: board[0],
                          second: board[1],
                          third: board[2],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Rest of leaderboard
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF9F0),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'All Champions 🌟',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppTheme.bgDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                itemCount: board.length,
                                itemBuilder: (_, i) {
                                  final entry = board[i];
                                  final isCurrentUser =
                                      currentUser?.nickname == entry.nickname;
                                  return _LeaderboardRow(
                                    entry: entry,
                                    isCurrentUser: isCurrentUser,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Confetti
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.06,
                numberOfParticles: 20,
                gravity: 0.3,
                colors: const [
                  AppTheme.watermelonRed,
                  AppTheme.bananaYellow,
                  AppTheme.mintGreen,
                  AppTheme.lavender,
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ===== PODIUM =====
class _PodiumWidget extends StatelessWidget {
  final LeaderboardEntry first;
  final LeaderboardEntry second;
  final LeaderboardEntry third;

  const _PodiumWidget({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd place
        _PodiumColumn(
          entry: second,
          height: 90,
          color: const Color(0xFFC0C0C0),
          medal: '🥈',
          rank: '2nd',
        ),
        const SizedBox(width: 8),
        // 1st place
        _PodiumColumn(
          entry: first,
          height: 120,
          color: const Color(0xFFFFD700),
          medal: '👑',
          rank: '1st',
          isFirst: true,
        ),
        const SizedBox(width: 8),
        // 3rd place
        _PodiumColumn(
          entry: third,
          height: 70,
          color: const Color(0xFFCD7F32),
          medal: '🥉',
          rank: '3rd',
        ),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final Color color;
  final String medal;
  final String rank;
  final bool isFirst;

  const _PodiumColumn({
    required this.entry,
    required this.height,
    required this.color,
    required this.medal,
    required this.rank,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isFirst) ...[
            Text('👑', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
          ],
          AvatarWidget(
            avatarId: entry.avatarId,
            size: isFirst ? 56 : 44,
            showBorder: true,
          ),
          const SizedBox(height: 6),
          Text(
            entry.nickname,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              fontSize: isFirst ? 13 : 11,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '⭐ ${entry.tokens}',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: AppTheme.bananaYellow,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                rank,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== LEADERBOARD ROW =====
class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const _LeaderboardRow({
    required this.entry,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final rankEmoji = entry.rank == 1
        ? '🥇'
        : entry.rank == 2
            ? '🥈'
            : entry.rank == 3
                ? '🥉'
                : '#${entry.rank}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? const LinearGradient(
                colors: [Color(0xFFFFF0E6), Color(0xFFFFE0CC)],
              )
            : null,
        color: isCurrentUser ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser
            ? Border.all(color: AppTheme.peachOrange, width: 2)
            : null,
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
          SizedBox(
            width: 40,
            child: Text(
              rankEmoji,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w800,
                fontSize: entry.rank <= 3 ? 22 : 15,
                color: AppTheme.bgDark,
              ),
            ),
          ),
          AvatarWidget(avatarId: entry.avatarId, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.nickname,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.bgDark,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.watermelonRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'YOU',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          TokenBadge(tokens: entry.tokens),
        ],
      ),
    );
  }
}
