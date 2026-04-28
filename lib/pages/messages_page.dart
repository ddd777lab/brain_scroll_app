import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
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

  // 私信列表（mock）
  final List<Map<String, dynamic>> _privateMessages = [
    {
      'avatar': '🧑‍🔬',
      'name': '科研小白逆袭中',
      'lastMessage': '你好，想请教一下那个论文的方法论...',
      'time': '10:30',
      'unread': 2,
    },
    {
      'avatar': '👨‍🏫',
      'name': '导师视角',
      'lastMessage': '你的研究设计不错，可以进一步...',
      'time': '昨天',
      'unread': 0,
    },
    {
      'avatar': '🧠',
      'name': '影像老鸟',
      'lastMessage': 'SPM 和 FSL 我都用过，看你的需求...',
      'time': '3 天前',
      'unread': 1,
    },
  ];

  // 四类消息中心数据
  List<Map<String, dynamic>> get _followMessages {
    return MockData.notifications
        .where((n) => n['category'] == '关注消息' || (n['action'] as String).contains('关注'))
        .toList();
  }

  List<Map<String, dynamic>> get _likeMessages {
    return MockData.notifications
        .where((n) => n['category'] == '点赞消息' || (n['action'] as String).contains('点赞') || (n['action'] as String).contains('评论'))
        .toList();
  }

  List<Map<String, dynamic>> get _officialMessages {
    return MockData.notifications
        .where((n) => n['category'] == '官方消息' || (n['sender'] as String).contains('系统'))
        .toList();
  }

  List<Map<String, dynamic>> get _pushMessages {
    return MockData.notifications
        .where((n) => n['category'] == '推送消息')
        .toList();
  }

  int get _totalUnreadCount {
    return MockData.notifications.where((n) => n['unread'] == true).length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          // 信封图标 - 消息中心入口
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.markunread_mailbox, size: 28),
                if (_totalUnreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$_totalUnreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => _showMessageCenter(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16),
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
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
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
          // 私信列表标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  '私信',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_privateMessages.where((m) => m['unread'] > 0).length} 条未读',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // 私信列表
          Expanded(
            child: _privateMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          '暂无私信',
                          style: TextStyle(
                              color: AppColors.textTertiary, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _privateMessages.length,
                    itemBuilder: (context, index) {
                      final msg = _privateMessages[index];
                      return _buildPrivateMessageItem(msg);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateMessageItem(Map<String, dynamic> msg) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryBackground,
            child: Text(
              msg['avatar'] ?? '👤',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          if (msg['unread'] > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${msg['unread']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        msg['name'] ?? '',
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        msg['lastMessage'] ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: AppColors.textTertiary, fontSize: 13),
      ),
      trailing: Text(
        msg['time'] ?? '',
        style: TextStyle(
            color: AppColors.textTertiary, fontSize: 12),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('正在与 ${msg['name']} 聊天（开发中）'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  void _showMessageCenter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 顶部标题
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      '消息中心',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // 四类消息
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      isScrollable: true,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textTertiary,
                      indicatorColor: AppColors.primary,
                      tabs: [
                        Tab(text: '关注消息'),
                        Tab(text: '点赞消息'),
                        Tab(text: '官方消息'),
                        Tab(text: '推送消息'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildCategoryTab(_followMessages, '关注消息'),
                          _buildCategoryTab(_likeMessages, '点赞消息'),
                          _buildCategoryTab(_officialMessages, '官方消息'),
                          _buildCategoryTab(_pushMessages, '推送消息'),
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
    );
  }

  Widget _buildCategoryTab(List<dynamic> messages, String category) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              '暂无$category',
              style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: _getCategoryColor(category),
            child: Text(
              msg['avatar'] ?? msg['sender']?.substring(0, 1) ?? '📩',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          title: Text(
            msg['sender'] ?? '',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            msg['content'] ?? msg['action'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
          ),
          trailing: Text(
            msg['time'] ?? '',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '关注消息':
        return AppColors.primary;
      case '点赞消息':
        return Colors.orange;
      case '官方消息':
        return Colors.purple;
      case '推送消息':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
