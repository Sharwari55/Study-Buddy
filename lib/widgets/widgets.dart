import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

// ===== TOKEN BADGE =====
class TokenBadge extends StatelessWidget {
  final int tokens;
  final bool large;

  const TokenBadge({super.key, required this.tokens, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 12,
        vertical: large ? 10 : 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD32A), Color(0xFFFF9F43)],
        ),
        borderRadius: BorderRadius.circular(large ? 20 : 14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bananaYellow.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(large ? '🪙' : '⭐', style: TextStyle(fontSize: large ? 20 : 14)),
          const SizedBox(width: 6),
          Text(
            '$tokens',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w800,
              fontSize: large ? 20 : 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== AVATAR WIDGET =====
class AvatarWidget extends StatelessWidget {
  final String avatarId;
  final double size;
  final bool showBorder;

  const AvatarWidget({
    super.key,
    required this.avatarId,
    this.size = 50,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = AvatarOption.all.firstWhere(
      (a) => a.id == avatarId,
      orElse: () => AvatarOption.all[0],
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(
          int.parse(avatar.color.replaceAll('#', '0xFF')),
        ).withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
        border: showBorder
            ? Border.all(
                color: Color(int.parse(avatar.color.replaceAll('#', '0xFF'))),
                width: 3,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          avatar.emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}

// ===== GRADIENT BUTTON =====
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final List<Color> colors;
  final double? width;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.colors = const [Color(0xFFFF4757), Color(0xFFFF6B35)],
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== STREAK BADGE =====
class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4757), Color(0xFFFF6348)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== SECTION CARD =====
class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final String? badge;

  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 30)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== DECORATIVE BLOB =====
class BlobDecoration extends StatelessWidget {
  final Color color;
  final double size;
  final double top;
  final double? left;
  final double? right;

  const BlobDecoration({
    super.key,
    required this.color,
    required this.size,
    required this.top,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
