import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../utils/data.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List<VideoItem>? _videos;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  void _loadVideos() async {
    final state = AppController.to;
    final user = state.currentUser;
    if (user != null) {
      final videos = await state.dbService.getVideos(user.ageGroup);
      if (mounted) {
        setState(() {
          _videos = videos;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (state) {
        final user = state.currentUser;
        if (user == null) return const SizedBox();

        return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📺 Watch & Learn',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: AppTheme.bgDark,
                            ),
                          ),
                          Text(
                            'For age ${user.ageGroup} • Earn 1 token / 5 min',
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
                  ],
                ),
              ),

              // Video Grid
              Expanded(
                child: _videos == null 
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.watermelonRed))
                    : _videos!.isEmpty 
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  const Text('📺', style: TextStyle(fontSize: 50)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Videos coming soon!\nSeed the database.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: const Color(0xFF636E72),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _videos!.length,
                            itemBuilder: (_, i) {
                              return _VideoCard(video: _videos![i]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
    });
  }
}

class _VideoCard extends StatelessWidget {
  final VideoItem video;

  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => _VideoPlayerScreen(video: video));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    video.thumbnail,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        gradient: AppTheme.blueGradient,
                      ),
                      child: const Center(
                        child: Text('🎬', style: TextStyle(fontSize: 50)),
                      ),
                    ),
                  ),
                ),
                // Play button overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.watermelonRed, AppTheme.peachOrange],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.watermelonRed.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                ),
                // Token badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.bananaYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '+1 Token/5min',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.bgDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.skyBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          video.subject,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: AppTheme.skyBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        video.channelName,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== VIDEO PLAYER SCREEN =====
class _VideoPlayerScreen extends StatefulWidget {
  final VideoItem video;

  const _VideoPlayerScreen({required this.video});

  @override
  State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  int _watchSeconds = 0;
  int _tokensEarned = 0;
  bool _showEyeBreak = false;
  int _continuousMinutes = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        enableCaption: true,
      ),
    );

    // Watch time tracker - every 5 min = 1 token
    Stream.periodic(const Duration(seconds: 30)).listen((_) {
      if (!mounted) return;
      setState(() {
        _watchSeconds += 30;
        _continuousMinutes++;
        final newTokens = (_watchSeconds / 300).floor();
        if (newTokens > _tokensEarned) {
          _tokensEarned = newTokens;
          AppController.to.addTokens(1);
        }
        
        // Add 1 watch minute every 60 seconds
        if (_watchSeconds % 60 == 0) {
          AppController.to.addWatchMinutes(1);
        }

        // Eye break after 30 min
        if (_continuousMinutes >= 60) {
          _showEyeBreak = true;
          _continuousMinutes = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.video.title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.bananaYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '🪙 $_tokensEarned',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // YouTube Player
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppTheme.watermelonRed,
                ),
                // Info card
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.bgGradient,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppTheme.bgDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.skyBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.video.subject,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppTheme.skyBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.video.channelName,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: const Color(0xFF636E72),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.bananaYellow.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Text('⏱', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Watch for 5 minutes to earn 1 Token!\nKeep learning to earn more. 🌟',
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: const Color(0xFF636E72),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Eye break popup
          if (_showEyeBreak)
            GestureDetector(
              onTap: () => setState(() => _showEyeBreak = false),
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('👀', style: TextStyle(fontSize: 60)),
                        const SizedBox(height: 16),
                        Text(
                          'Eye Break Time!',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: AppTheme.bgDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'ve been watching for 30 minutes.\nTake a 2-minute eye break! 👁️',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          label: 'OK, I\'ll take a break! ✅',
                          onTap: () => setState(() => _showEyeBreak = false),
                          colors: [AppTheme.mintGreen, AppTheme.turquoise],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
