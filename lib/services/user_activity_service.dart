import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 用户活动服务：管理点赞、收藏、评论、订阅（持久化存储）
class UserActivityService extends ChangeNotifier {
  static const String _keyLikes = 'liked_articles';
  static const String _keySaves = 'saved_articles';
  static const String _keySubscriptions = 'subscribed_journals';
  static const String _keyComments = 'article_comments';
  static const String _keyFollowedCreators = 'followed_creators';
  static const String _keyBio = 'user_bio';

  // 点赞的文章 ID 列表
  final Set<String> _likedArticles = {};
  // 收藏的文章 ID 列表
  final Set<String> _savedArticles = {};
  // 订阅的期刊名称列表
  final Set<String> _subscribedJournals = {};
  // 评论：文章 ID → 评论列表
  final Map<String, List<String>> _comments = {};
  // 关注的创作者
  final Set<String> _followedCreators = {};
  // 个人简介
  String _bio = '';

  bool _isInitialized = false;

  Set<String> get likedArticles => Set.from(_likedArticles);
  Set<String> get savedArticles => Set.from(_savedArticles);
  Set<String> get subscribedJournals => Set.from(_subscribedJournals);
  Map<String, List<String>> get comments => Map.from(_comments);
  Set<String> get followedCreators => Set.from(_followedCreators);
  String get bio => _bio;
  bool get isInitialized => _isInitialized;

  int get totalFollowedCreators => _followedCreators.length;
  int get totalFans => _followedCreators.length; // mock: 暂时等于关注数，后续替换

  bool isLiked(String articleId) => _likedArticles.contains(articleId);
  bool isSaved(String articleId) => _savedArticles.contains(articleId);
  bool isSubscribed(String journal) => _subscribedJournals.contains(journal);
  List<String> getCommentsForArticle(String articleId) =>
      _comments[articleId] ?? [];

  int get totalLikes => _likedArticles.length;
  int get totalSaves => _savedArticles.length;
  int get totalComments => _comments.values.fold(0, (sum, list) => sum + list.length);

  /// 初始化：从磁盘加载
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();

      final likesList = prefs.getStringList(_keyLikes) ?? [];
      _likedArticles.addAll(likesList);

      final savesList = prefs.getStringList(_keySaves) ?? [];
      _savedArticles.addAll(savesList);

      final subsList = prefs.getStringList(_keySubscriptions) ?? [];
      _subscribedJournals.addAll(subsList);

      final commentsStr = prefs.getString(_keyComments);
      if (commentsStr != null) {
        final commentsMap = jsonDecode(commentsStr) as Map<String, dynamic>;
        commentsMap.forEach((key, value) {
          _comments[key] = List<String>.from(value);
        });
      }

      final creatorsList = prefs.getStringList(_keyFollowedCreators) ?? [];
      _followedCreators.addAll(creatorsList);

      _bio = prefs.getString(_keyBio) ?? '';

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('⚠️ UserActivityService init error: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyLikes, _likedArticles.toList());
      await prefs.setStringList(_keySaves, _savedArticles.toList());
      await prefs.setStringList(_keySubscriptions, _subscribedJournals.toList());
      await prefs.setString(_keyComments, jsonEncode(_comments));
      await prefs.setStringList(_keyFollowedCreators, _followedCreators.toList());
      await prefs.setString(_keyBio, _bio);
    } catch (e) {
      print('⚠️ UserActivityService save error: $e');
    }
  }

  void toggleLike(String articleId) {
    if (_likedArticles.contains(articleId)) {
      _likedArticles.remove(articleId);
    } else {
      _likedArticles.add(articleId);
    }
    _save();
    notifyListeners();
  }

  void toggleSave(String articleId) {
    if (_savedArticles.contains(articleId)) {
      _savedArticles.remove(articleId);
    } else {
      _savedArticles.add(articleId);
    }
    _save();
    notifyListeners();
  }

  void toggleSubscribe(String journal) {
    if (_subscribedJournals.contains(journal)) {
      _subscribedJournals.remove(journal);
    } else {
      _subscribedJournals.add(journal);
    }
    _save();
    notifyListeners();
  }

  void addComment(String articleId, String comment) {
    _comments.putIfAbsent(articleId, () => []);
    _comments[articleId]!.add(comment);
    _save();
    notifyListeners();
  }

  void toggleFollowCreator(String creator) {
    if (_followedCreators.contains(creator)) {
      _followedCreators.remove(creator);
    } else {
      _followedCreators.add(creator);
    }
    _save();
    notifyListeners();
  }

  void setBio(String newBio) {
    _bio = newBio;
    _save();
    notifyListeners();
  }
}
