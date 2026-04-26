import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class MarketPostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const MarketPostDetailPage({super.key, required this.post});

  @override
  State<MarketPostDetailPage> createState() => _MarketPostDetailPageState();
}

class _MarketPostDetailPageState extends State<MarketPostDetailPage> {
  late bool _isLiked;
  late bool _isSaved;
  late int _likeCount;
  late int _saveCount;
  late List<Map<String, String>> _comments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _isSaved = false;
    _likeCount = widget.post['likes'] ?? 0;
    _saveCount = widget.post['saves'] ?? 0;

    // 初始化已有评论
    _comments = [];
    if (widget.post['comments'] != null) {
      _comments = (widget.post['comments'] as List)
          .map((c) => Map<String, String>.from(c as Map))
          .toList();
    }
  }

  Color _getTagColor(String tag) {
    final hash = tag.hashCode;
    final colors = [
      AppColors.morandiBlue,
      AppColors.morandiPink,
      AppColors.morandiPurple,
      AppColors.morandiGreen,
      AppColors.morandiBrown,
      AppColors.morandiBeige,
    ];
    return colors[hash.abs() % colors.length];
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
      _saveCount += _isSaved ? 1 : -1;
    });
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add({
        'author': '我',
        'role': '',
        'avatar': '😊',
        'text': text,
        'time': '刚刚',
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.post['title'] ?? '';
    final content = widget.post['content'] ?? '';
    final authorName = widget.post['authorName'] ?? '';
    final authorRole = widget.post['authorRole'] ?? '';
    final authorAvatar = widget.post['authorAvatar'] ?? '👤';
    final createdAt = widget.post['createdAt'] ?? '';
    final tags = widget.post['tags'] as List? ?? [];
    final commentCount = _comments.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 顶部导航栏
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.cardBackground.withOpacity(0.95),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: _isSaved ? AppColors.primary : AppColors.textPrimary,
                ),
                onPressed: _toggleSave,
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined,
                    color: AppColors.textPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('分享功能开发中'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),

          // 帖子内容
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户信息
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(authorAvatar,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$authorRole · $createdAt',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 标题
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 标签
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: tags.map((tag) {
                        final color = _getTagColor(tag as String);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  if (tags.isNotEmpty) const SizedBox(height: 16),

                  // 正文
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 互动栏
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionItem(
                          icon: _isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          count: _likeCount.toString(),
                          color: _isLiked ? Colors.red : AppColors.textTertiary,
                          onTap: _toggleLike,
                        ),
                        _buildActionItem(
                          icon: _isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          count: _saveCount.toString(),
                          color: _isSaved
                              ? AppColors.primary
                              : AppColors.textTertiary,
                          onTap: _toggleSave,
                        ),
                        _buildActionItem(
                          icon: Icons.chat_bubble_outline,
                          count: commentCount.toString(),
                          color: AppColors.textTertiary,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 评论区标题
                  const Text(
                    '评论',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 评论列表
                  if (_comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          '暂无评论，来发表第一条评论吧~',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  ..._comments.map((comment) => _buildCommentItem(comment)),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      // 底部输入栏
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: '写下你的想法...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceBackground,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary, size: 24),
              onPressed: _addComment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, String> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    comment['avatar'] ?? '👤',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['author'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (comment['role'] != null &&
                        comment['role']!.isNotEmpty)
                      Text(
                        '${comment['role']} · ${comment['time'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment['text'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
