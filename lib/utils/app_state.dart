import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  UserProfile? _currentUser;
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = false;

  UserProfile? get currentUser => _currentUser;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    await loadUser();
    _generateMockLeaderboard();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = UserProfile.fromMap(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> saveUser() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(_currentUser!.toMap()));
  }

  Future<void> createProfile({
    required String nickname,
    required String ageGroup,
    required String avatarId,
  }) async {
    _currentUser = UserProfile(
      id: const Uuid().v4(),
      nickname: nickname,
      ageGroup: ageGroup,
      avatarId: avatarId,
      tokens: 10, // Welcome bonus!
      lastActiveDate: DateTime.now(),
    );
    await saveUser();
    _generateMockLeaderboard();
    notifyListeners();
  }

  Future<void> addTokens(int amount) async {
    if (_currentUser == null) return;
    _currentUser!.tokens += amount;
    await saveUser();
    _generateMockLeaderboard();
    notifyListeners();
  }

  Future<void> spendTokens(int amount) async {
    if (_currentUser == null) return;
    if (_currentUser!.tokens >= amount) {
      _currentUser!.tokens -= amount;
      await saveUser();
      notifyListeners();
    }
  }

  Future<void> updateStreak() async {
    if (_currentUser == null) return;
    final now = DateTime.now();
    final last = _currentUser!.lastActiveDate;
    if (last != null) {
      final diff = now.difference(last).inDays;
      if (diff == 1) {
        _currentUser!.streak += 1;
      } else if (diff > 1) {
        _currentUser!.streak = 1;
      }
    } else {
      _currentUser!.streak = 1;
    }
    _currentUser!.lastActiveDate = now;
    await saveUser();
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    _currentUser = null;
    notifyListeners();
  }

  void _generateMockLeaderboard() {
    final mockData = [
      {'nickname': 'Arjun', 'avatar': 'lion', 'tokens': 520},
      {'nickname': 'Priya', 'avatar': 'peacock', 'tokens': 480},
      {'nickname': 'Ravi', 'avatar': 'tiger', 'tokens': 430},
      {'nickname': 'Ananya', 'avatar': 'owl', 'tokens': 390},
      {'nickname': 'Dev', 'avatar': 'monkey', 'tokens': 350},
      {'nickname': 'Kavya', 'avatar': 'parrot', 'tokens': 310},
      {'nickname': 'Rohan', 'avatar': 'fox', 'tokens': 280},
      {'nickname': 'Sita', 'avatar': 'rabbit', 'tokens': 240},
    ];

    List<LeaderboardEntry> entries = mockData.asMap().entries.map((e) {
      return LeaderboardEntry(
        nickname: e.value['nickname'] as String,
        avatarId: e.value['avatar'] as String,
        tokens: e.value['tokens'] as int,
        rank: e.key + 1,
      );
    }).toList();

    // Insert current user if logged in
    if (_currentUser != null) {
      entries.add(LeaderboardEntry(
        nickname: _currentUser!.nickname,
        avatarId: _currentUser!.avatarId,
        tokens: _currentUser!.tokens,
        rank: 0,
      ));
      entries.sort((a, b) => b.tokens.compareTo(a.tokens));
      entries = entries.asMap().entries.map((e) {
        return LeaderboardEntry(
          nickname: e.value.nickname,
          avatarId: e.value.avatarId,
          tokens: e.value.tokens,
          rank: e.key + 1,
        );
      }).toList();
    }

    _leaderboard = entries;
  }
}
