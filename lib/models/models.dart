// User Profile Model
class UserProfile {
  final String id;
  final String nickname;
  final String ageGroup; // '2-5', '5-8', '8-12'
  final String avatarId;
  int tokens;
  int streak;
  int totalWatchMinutes;
  DateTime? lastActiveDate;
  List<String> blockedChannels;

  UserProfile({
    required this.id,
    required this.nickname,
    required this.ageGroup,
    required this.avatarId,
    this.tokens = 0,
    this.streak = 0,
    this.totalWatchMinutes = 0,
    this.lastActiveDate,
    this.blockedChannels = const [],
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nickname': nickname,
        'ageGroup': ageGroup,
        'avatarId': avatarId,
        'tokens': tokens,
        'streak': streak,
        'totalWatchMinutes': totalWatchMinutes,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'blockedChannels': blockedChannels,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'],
        nickname: map['nickname'],
        ageGroup: map['ageGroup'],
        avatarId: map['avatarId'],
        tokens: map['tokens'] ?? 0,
        streak: map['streak'] ?? 0,
        totalWatchMinutes: map['totalWatchMinutes'] ?? 0,
        lastActiveDate: map['lastActiveDate'] != null
            ? DateTime.parse(map['lastActiveDate'])
            : null,
        blockedChannels: List<String>.from(map['blockedChannels'] ?? []),
      );
}

// Avatar Model
class AvatarOption {
  final String id;
  final String emoji;
  final String name;
  final String color;

  const AvatarOption({
    required this.id,
    required this.emoji,
    required this.name,
    required this.color,
  });

  static const List<AvatarOption> all = [
    AvatarOption(id: 'lion', emoji: '🦁', name: 'Leo', color: '#FFD32A'),
    AvatarOption(id: 'tiger', emoji: '🐯', name: 'Tiger', color: '#FF6B35'),
    AvatarOption(id: 'elephant', emoji: '🐘', name: 'Ellie', color: '#A29BFE'),
    AvatarOption(id: 'peacock', emoji: '🦚', name: 'Peacock', color: '#2ED573'),
    AvatarOption(id: 'parrot', emoji: '🦜', name: 'Polly', color: '#FF4757'),
    AvatarOption(id: 'monkey', emoji: '🐵', name: 'Monu', color: '#FF7675'),
    AvatarOption(id: 'owl', emoji: '🦉', name: 'Ullu', color: '#00CEC9'),
    AvatarOption(id: 'rabbit', emoji: '🐰', name: 'Bunny', color: '#FD79A8'),
    AvatarOption(id: 'fox', emoji: '🦊', name: 'Foxy', color: '#E17055'),
    AvatarOption(id: 'bear', emoji: '🐻', name: 'Bhalu', color: '#6C5CE7'),
    AvatarOption(id: 'dolphin', emoji: '🐬', name: 'Dolly', color: '#1E90FF'),
    AvatarOption(id: 'cow', emoji: '🐄', name: 'Gauri', color: '#55EFC4'),
  ];
}

// Quiz Question Model
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String subject;
  final String ageGroup;
  final String? hint;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.subject,
    required this.ageGroup,
    this.hint,
  });
}

// Leaderboard Entry
class LeaderboardEntry {
  final String nickname;
  final String avatarId;
  final int tokens;
  final int rank;

  const LeaderboardEntry({
    required this.nickname,
    required this.avatarId,
    required this.tokens,
    required this.rank,
  });
}

// Video Item
class VideoItem {
  final String videoId;
  final String title;
  final String channelName;
  final String thumbnail;
  final String ageGroup;
  final String subject;

  const VideoItem({
    required this.videoId,
    required this.title,
    required this.channelName,
    required this.thumbnail,
    required this.ageGroup,
    required this.subject,
  });
}
