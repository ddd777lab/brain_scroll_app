import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import 'market_post_detail_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedCategory = '全部';

  // 搜索状态
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 点赞/收藏状态（集市页内部）
  final Map<String, bool> _likedPosts = {};
  final Map<String, bool> _savedPosts = {};

  // 帖子互动数据（点赞数、收藏数、评论数副本）
  final Map<String, int> _likeCounts = {};
  final Map<String, int> _saveCounts = {};
  final Map<String, int> _commentCounts = {};

  // 评论数据（帖子 ID → 评论列表）
  final Map<String, List<Map<String, String>>> _postComments = {};

  @override
  void initState() {
    super.initState();
    _initCounts();
  }

  void _initCounts() {
    for (final post in MockData.marketplacePosts) {
      final id = post['id'] as String;
      _likeCounts[id] = post['likes'] as int;
      _saveCounts[id] = post['saves'] as int;
      _commentCounts[id] = post['commentsCount'] as int;
      // 初始化已有评论
      if (post['comments'] != null) {
        _postComments[id] = (post['comments'] as List)
            .map((c) => Map<String, String>.from(c as Map))
            .toList();
      } else {
        _postComments[id] = [];
      }
    }
  }

  // 根据分类筛选帖子
  List<Map<String, dynamic>> get _filteredPosts {
    var posts = MockData.marketplacePosts;

    // 分类筛选
    if (_selectedCategory != '全部') {
      posts = posts.where((post) {
        final tags = post['tags'] as List? ?? [];
        return tags.any((tag) => tag == _selectedCategory);
      }).toList();
    }

    // 搜索过滤
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      posts = posts.where((post) {
        final searchable = [
          post['title']?.toString() ?? '',
          post['content']?.toString() ?? '',
          post['summary']?.toString() ?? '',
          post['authorName']?.toString() ?? '',
          ...(post['tags'] as List? ?? []).map((e) => e.toString()),
        ].join(' ').toLowerCase();
        return searchable.contains(q);
      }).toList();
    }

    return posts;
  }

  // 热搜榜点击
  void _onHotTopicTap(Map<String, dynamic> topic) {
    final relatedId = topic['relatedPostId'] as String?;
    if (relatedId != null) {
      final post = MockData.marketplacePosts.firstWhere(
        (p) => p['id'] == relatedId,
        orElse: () => {},
      );
      if (post.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MarketPostDetailPage(post: post),
          ),
        ).then((_) => setState(() {}));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已筛选「${topic['title']}」，功能开发中'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // 点赞
  void _toggleLike(String postId) {
    setState(() {
      _likedPosts[postId] = !(_likedPosts[postId] ?? false);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) +
          (_likedPosts[postId]! ? 1 : -1);
    });
  }

  // 收藏
  void _toggleSave(String postId) {
    setState(() {
      _savedPosts[postId] = !(_savedPosts[postId] ?? false);
      _saveCounts[postId] = (_saveCounts[postId] ?? 0) +
          (_savedPosts[postId]! ? 1 : -1);
    });
  }

  // 添加评论
  void _addComment(String postId, String text) {
    setState(() {
      _postComments.putIfAbsent(postId, () => []);
      _postComments[postId]!.add({
        'author': '我',
        'role': '',
        'avatar': '😊',
        'text': text,
        'time': '刚刚',
      });
      _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;
    });
  }

  // 莫兰迪色
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

  Color _getHeatTagColor(String? tagColor) {
    switch (tagColor) {
      case 'red':
        return const Color(0xFFEB5757);
      case 'blue':
        return AppColors.morandiBlue;
      case 'purple':
        return AppColors.morandiPurple;
      case 'orange':
        return const Color(0xFFF2994A);
      default:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 顶部标题 + 搜索
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.cardBackground,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '集市',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 搜索栏
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '搜索帖子、话题...',
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: AppColors.textTertiary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceBackground,
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 分类标签 + 热搜榜 + 帖子列表
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 分类标签
                _buildCategoryChips(),
                const SizedBox(height: 12),
                // 热搜榜
                _buildHotTopics(),
                const SizedBox(height: 16),
                // 帖子列表
                _buildPostList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== 分类标签 ==========
  Widget _buildCategoryChips() {
    const categories = [
      '全部',
      '论文求助',
      '选题灵感',
      '经验分享',
      '资料推荐',
      'AI工具',
      '保研/申博',
    ];

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final cat = categories[index];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ========== 热搜榜 ==========
  Widget _buildHotTopics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            children: const [
              Icon(Icons.local_fire_department,
                  size: 18, color: Color(0xFFFF6B6B)),
              SizedBox(width: 6),
              Text(
                '热搜榜',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...MockData.hotTopics.asMap().entries.map((entry) {
            final index = entry.key;
            final topic = entry.value;
            return GestureDetector(
              onTap: () => _onHotTopicTap(topic),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // 排名
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: index < 3
                            ? const Color(0xFFFF6B6B)
                            : AppColors.surfaceBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: index < 3
                                ? Colors.white
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 话题标题
                    Expanded(
                      child: Text(
                        topic['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 标签
                    if (topic['tag'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getHeatTagColor(topic['tagColor'] as String?)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          topic['tag'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: _getHeatTagColor(
                                topic['tagColor'] as String?),
                          ),
                        ),
                      ),
                    if (topic['tag'] != null) const SizedBox(width: 8),
                    // 热度
                    Text(
                      topic['heat'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ========== 帖子列表 ==========
  Widget _buildPostList() {
    final posts = _filteredPosts;
    if (posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text(
            '该分类下暂无帖子',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: posts.map((post) => _buildPostCard(post)).toList(),
      ),
    );
  }

  // ========== 帖子卡片 ==========
  Widget _buildPostCard(Map<String, dynamic> post) {
    final id = post['id'] as String;
    final isLiked = _likedPosts[id] ?? false;
    final isSaved = _savedPosts[id] ?? false;
    final likeCount = _likeCounts[id] ?? (post['likes'] as int);
    final saveCount = _saveCounts[id] ?? (post['saves'] as int);
    final commentCount =
        _commentCounts[id] ?? (post['commentsCount'] as int);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MarketPostDetailPage(post: post),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      post['authorAvatar'] ?? '👤',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['authorName'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${post['authorRole'] ?? ''} · ${post['createdAt'] ?? ''}',
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
            const SizedBox(height: 12),
            // 标题
            Text(
              post['title'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            // 摘要
            Text(
              post['summary'] ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // 标签
            if (post['tags'] != null && (post['tags'] as List).isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    (post['tags'] as List).map((tag) {
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
            if (post['tags'] == null || (post['tags'] as List).isEmpty)
              const SizedBox(height: 4),
            const SizedBox(height: 8),
            // 互动栏
            Divider(height: 1, color: AppColors.border.withOpacity(0.5)),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionItem(
                    icon: isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: '点赞',
                    count: '$likeCount',
                    color: isLiked ? Colors.red : AppColors.textTertiary,
                    onTap: () => _toggleLike(id),
                  ),
                  _buildActionItem(
                    icon: isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    label: '收藏',
                    count: '$saveCount',
                    color: isSaved
                        ? AppColors.primary
                        : AppColors.textTertiary,
                    onTap: () => _toggleSave(id),
                  ),
                  _buildActionItem(
                    icon: Icons.chat_bubble_outline,
                    label: '评论',
                    count: '$commentCount',
                    color: AppColors.textTertiary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MarketPostDetailPage(post: post),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
