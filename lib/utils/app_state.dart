import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();
  UserProfile? _currentUser;
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = false;

  UserProfile? get currentUser => _currentUser;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  final DatabaseService dbService = DatabaseService();

  AppController() {
    _init();
    // Listen to Firebase Auth state changes to load user profile from Firestore
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserFromFirestore(user.uid);
      } else {
        _currentUser = null;
        _leaderboard = [];
        update();
      }
    });
  }

  Future<void> _init() async {
    _isLoading = true;
    update();
    await loadUser();
    await fetchLeaderboard();
    _isLoading = false;
    update();
  }

  Future<void> _fetchUserFromFirestore(String uid) async {
    _isLoading = true;
    update();
    final profile = await dbService.getUserProfile(uid);
    if (profile != null) {
      _currentUser = profile;
      await saveUserLocal(); // Cache locally
    }
    await fetchLeaderboard();
    _isLoading = false;
    update();
  }

  Future<void> fetchLeaderboard() async {
    _leaderboard = await dbService.getLeaderboard();
    update();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = UserProfile.fromMap(jsonDecode(userJson));
      update();
    }
  }

  Future<void> saveUserLocal() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(_currentUser!.toMap()));
  }

  Future<void> saveUser() async {
    if (_currentUser == null) return;
    await saveUserLocal();
    await dbService.saveUserProfile(_currentUser!);
  }

  Future<void> createProfile({
    required String nickname,
    required String ageGroup,
    required String avatarId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _currentUser = UserProfile(
      id: user.uid,
      nickname: nickname,
      ageGroup: ageGroup,
      avatarId: avatarId,
      tokens: 10, // Welcome bonus!
      lastActiveDate: DateTime.now(),
    );
    await saveUser();
    await fetchLeaderboard();
    update();
  }

  Future<void> addTokens(int amount) async {
    if (_currentUser == null) return;
    _currentUser!.tokens += amount;
    await saveUser();
    await fetchLeaderboard();
    update();
  }

  Future<void> addWatchMinutes(int minutes) async {
    if (_currentUser == null) return;
    _currentUser!.totalWatchMinutes += minutes;
    await saveUser();
    update();
  }

  Future<void> spendTokens(int amount) async {
    if (_currentUser == null) return;
    if (_currentUser!.tokens >= amount) {
      _currentUser!.tokens -= amount;
      await saveUser();
      await fetchLeaderboard();
      update();
    }
  }

  Future<void> unlockReward(String rewardId, int cost) async {
    if (_currentUser == null) return;
    if (_currentUser!.tokens >= cost && !_currentUser!.unlockedRewards.contains(rewardId)) {
      await dbService.unlockReward(_currentUser!.id, rewardId, _currentUser!.tokens, cost);
      _currentUser!.tokens -= cost;
      _currentUser!.unlockedRewards.add(rewardId);
      await saveUserLocal();
      await fetchLeaderboard();
      update();
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
    update();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await AuthService().signOut();
    _currentUser = null;
    update();
  }
}
