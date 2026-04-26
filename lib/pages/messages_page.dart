import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'article_detail_page.dart';
import 'market_post_detail_page.dart';
import 'profile_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// 获取过滤后的通知列表
  List<Map<String, dynamic>> get _filteredNotifications {
    if (_searchQuery.isEmpty) return MockData.notifications.cast<Map<String, dynamic>>();
    final q = _searchQuery.toLowerCase();
    return MockData.notifications.where((n) {
      final searchable = [
        n['sender']?.toString() ?? '',
        n['action']?.toString() ?? '',
        n['content']?.toString() ?? '',
      ].join(' ').toLowerCase();
      return searchable.contains(q);
    }).toList().cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '消息',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.all_inbox),
            onPressed: () {
              // 全部标记已读
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '搜索消息...',
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                isDense: true,
              ),
            ),
          ),
          // 消息列表
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotifications.length,
              itemBuilder: (BuildContext context, index) {
                final notification = _filteredNotifications[index];
                return _buildNotificationItem(context, notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    return GestureDetector(
      onTap: () => _handleNotificationTap(context, notification),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          _buildAvatar(notification),
          const SizedBox(width: 12),
          // 内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: notification['sender'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' ${notification['action']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                if (notification['content'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification['content']!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  notification['time'],
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          // 未读红点
          if (notification['unread'] == true) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    ),
    );
  }

  void _handleNotificationTap(BuildContext context, Map notification) {
    final action = notification['action'] as String? ?? '';
    final sender = notification['sender'] as String? ?? '';

    if (action.contains('评论了你的文章')) {
      final article = MockData.papers.isNotEmpty ? MockData.papers[0] : null;
      if (article != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ArticleDetailPage(),
            settings: RouteSettings(arguments: article),
          ),
        );
      }
    } else if (action.contains('发布了新内容')) {
      final post = MockData.marketplacePosts.isNotEmpty ? MockData.marketplacePosts[0] : null;
      if (post != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MarketPostDetailPage(post: post),
          ),
        );
      }
    } else if (action.contains('关注了你')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$sender 关注了你'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (action.contains('点赞了你的评论')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$sender 点赞了你的评论'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$sender $action'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildAvatar(dynamic notification) {
    if (notification['iconName'] != null) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[300],
        child: Icon(_getIcon(notification['iconName']), size: 24, color: Colors.white),
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundColor: _getColor(notification['colorName']),
      );
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      case 'orange': return Colors.orange;
      case 'purple': return Colors.purple;
      case 'red': return Colors.red;
      case 'teal': return Colors.teal;
      default: return Colors.grey;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'person': return Icons.person;
      case 'school': return Icons.school;
      case 'star': return Icons.star;
      default: return Icons.person;
    }
  }
}
