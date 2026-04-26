import 'package:flutter/material.dart';

/// 用户活动服务：管理点赞、收藏、评论、订阅（本地内存状态）
class UserActivityService extends ChangeNotifier {
  // 点赞的文章 ID 列表
  final Set<String> _likedArticles = {};
  // 收藏的文章 ID 列表
  final Set<String> _savedArticles = {};
  // 订阅的期刊名称列表
  final Set<String> _subscribedJournals = {};
  // 评论：文章 ID → 评论列表
  final Map<String, List<String>> _comments = {};

  Set<String> get likedArticles => Set.from(_likedArticles);
  Set<String> get savedArticles => Set.from(_savedArticles);
  Set<String> get subscribedJournals => Set.from(_subscribedJournals);
  Map<String, List<String>> get comments => Map.from(_comments);

  bool isLiked(String articleId) => _likedArticles.contains(articleId);
  bool isSaved(String articleId) => _savedArticles.contains(articleId);
  bool isSubscribed(String journal) => _subscribedJournals.contains(journal);
  List<String> getCommentsForArticle(String articleId) =>
      _comments[articleId] ?? [];

  int get totalLikes => _likedArticles.length;
  int get totalSaves => _savedArticles.length;
  int get totalComments => _comments.values.fold(0, (sum, list) => sum + list.length);

  void toggleLike(String articleId) {
    if (_likedArticles.contains(articleId)) {
      _likedArticles.remove(articleId);
    } else {
      _likedArticles.add(articleId);
    }
    notifyListeners();
  }

  void toggleSave(String articleId) {
    if (_savedArticles.contains(articleId)) {
      _savedArticles.remove(articleId);
    } else {
      _savedArticles.add(articleId);
    }
    notifyListeners();
  }

  void toggleSubscribe(String journal) {
    if (_subscribedJournals.contains(journal)) {
      _subscribedJournals.remove(journal);
    } else {
      _subscribedJournals.add(journal);
    }
    notifyListeners();
  }

  void addComment(String articleId, String comment) {
    _comments.putIfAbsent(articleId, () => []);
    _comments[articleId]!.add(comment);
    notifyListeners();
  }
}
