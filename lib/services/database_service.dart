import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../utils/data.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get usersCollection => _db.collection('users');
  CollectionReference get quizzesCollection => _db.collection('quizzes');
  CollectionReference get videosCollection => _db.collection('videos');
  CollectionReference get rewardsCollection => _db.collection('rewards');

  // Create or Update User Profile
  Future<void> saveUserProfile(UserProfile user) async {
    try {
      await usersCollection.doc(user.id).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  // Get User Profile by ID
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Fetch Global Leaderboard (Top 50 users by tokens)
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      final querySnapshot = await usersCollection
          .orderBy('tokens', descending: true)
          .limit(50)
          .get();

      List<LeaderboardEntry> leaderboard = [];
      int rank = 1;

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        leaderboard.add(LeaderboardEntry(
          nickname: data['nickname'] ?? 'Unknown',
          avatarId: data['avatarId'] ?? 'lion',
          tokens: data['tokens'] ?? 0,
          rank: rank,
        ));
        rank++;
      }

      return leaderboard;
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  // Stream of Global Leaderboard for real-time updates
  Stream<List<LeaderboardEntry>> streamLeaderboard() {
    return usersCollection
        .orderBy('tokens', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      List<LeaderboardEntry> leaderboard = [];
      int rank = 1;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        leaderboard.add(LeaderboardEntry(
          nickname: data['nickname'] ?? 'Unknown',
          avatarId: data['avatarId'] ?? 'lion',
          tokens: data['tokens'] ?? 0,
          rank: rank,
        ));
        rank++;
      }
      return leaderboard;
    });
  }

  // Update specific field for user (e.g., tokens)
  Future<void> updateUserField(String uid, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(uid).update(data);
    } catch (e) {
      print('Error updating user field: $e');
      rethrow;
    }
  }

  // --- QUizzes ---
  Future<List<QuizQuestion>> getQuizzes(String ageGroup) async {
    try {
      final snapshot = await quizzesCollection.where('ageGroup', isEqualTo: ageGroup).get();
      return snapshot.docs.map((doc) => QuizQuestion.fromMap(doc.data() as Map<String, dynamic>)).toList()..shuffle();
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }

  // --- Videos ---
  Future<List<VideoItem>> getVideos(String ageGroup) async {
    try {
      final snapshot = await videosCollection.where('ageGroup', isEqualTo: ageGroup).get();
      return snapshot.docs.map((doc) => VideoItem.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }

  // --- Rewards ---
  Future<List<RewardModel>> getRewards() async {
    try {
      final snapshot = await rewardsCollection.get();
      return snapshot.docs.map((doc) => RewardModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching rewards: $e');
      return [];
    }
  }

  // Unlock Reward
  Future<void> unlockReward(String uid, String rewardId, int currentTokens, int cost) async {
    try {
      if (currentTokens < cost) throw Exception('Not enough tokens');
      await usersCollection.doc(uid).update({
        'tokens': currentTokens - cost,
        'unlockedRewards': FieldValue.arrayUnion([rewardId])
      });
    } catch (e) {
      print('Error unlocking reward: $e');
      rethrow;
    }
  }

  // --- Database Seeding ---
  // Call this once from main or a hidden admin button to populate Firestore
  Future<void> seedDatabase() async {
    try {
      print('Seeding quizzes...');
      for (var q in QuizData.allQuestions) {
        await quizzesCollection.doc(q.id).set({
          'id': q.id,
          'question': q.question,
          'options': q.options,
          'correctIndex': q.correctIndex,
          'subject': q.subject,
          'ageGroup': q.ageGroup,
          'hint': q.hint,
        });
      }

      print('Seeding videos...');
      for (var v in VideoData.videos) {
        await videosCollection.doc(v.videoId).set({
          'videoId': v.videoId,
          'title': v.title,
          'channelName': v.channelName,
          'thumbnail': v.thumbnail,
          'ageGroup': v.ageGroup,
          'subject': v.subject,
        });
      }

      print('Seeding rewards...');
      for (var r in RewardsData.rewards) {
        await rewardsCollection.doc(r.id).set({
          'id': r.id,
          'emoji': r.emoji,
          'name': r.name,
          'description': r.description,
          'cost': r.cost,
          'category': r.category,
          'isSpecial': r.isSpecial,
        });
      }
      
      print('Database seeded successfully!');
    } catch (e) {
      print('Error seeding database: $e');
    }
  }
}
