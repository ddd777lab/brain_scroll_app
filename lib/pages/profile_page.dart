import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_onboarding_service.dart';
import '../services/user_activity_service.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import 'onboarding/login_page.dart';
import 'article_detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingService>();
    final activity = context.watch<UserActivityService>();
    final displayName = onboarding.getDisplayName();
    final userDetails = onboarding.getUserDetails();
    final isCompleted = onboarding.hasCompletedOnboarding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 用户头部信息
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
              color: AppColors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCompleted
                                ? [
                                    const Color(0xFF4ADE80),
                                    const Color(0xFF36D6A1)
                                  ]
                                : [Colors.grey[300]!, Colors.grey[400]!],
                          ),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Icon(
                          isCompleted ? Icons.person : Icons.person_outline,
                          size: 36,
                          color:
                              isCompleted ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userDetails,
                              style: TextStyle(
                                color: isCompleted
                                    ? AppColors.textSecondary
                                    : AppColors.textTertiary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 设置按钮
                      IconButton(
                        icon: const Icon(Icons.settings_outlined,
                            color: AppColors.textSecondary),
                        onPressed: () => _showSettingsDialog(context),
                      ),
                    ],
                  ),
                  // 编辑资料按钮
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (!isCompleted) {
                          context.read<OnboardingService>().reset();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(isCompleted ? '编辑资料' : '去完善资料'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 统计 + 订阅 + 分栏 Tab
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.cardBackground,
              child: Column(
                children: [
                  // 统计数据
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                            '关注期刊', '${activity.subscribedJournals.length}'),
                        _buildStatItem('评论', '${activity.totalComments}'),
                        _buildStatItem('收藏', '${activity.totalSaves}'),
                        _buildStatItem('点赞', '${activity.totalLikes}'),
                      ],
                    ),
                  ),
                  // 我的订阅
                  if (activity.subscribedJournals.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: activity.subscribedJournals
                            .map((journal) => InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '已进入「$journal」相关内容，筛选功能开发中'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Chip(
                                    label: Text(
                                      journal,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    backgroundColor: AppColors.surfaceBackground,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: AppColors.border),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  // 分栏 Tab
                  const Divider(height: 1),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textTertiary,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(text: '评论'),
                      Tab(text: '收藏'),
                      Tab(text: '点赞'),
                    ],
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
          ),
          // 分栏内容
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCommentsTab(activity),
                  _buildSavedTab(activity),
                  _buildLikedTab(activity),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 统计项
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ========== 三个分栏 ==========

  // 评论分栏
  Widget _buildCommentsTab(UserActivityService activity) {
    final allComments = activity.comments;
    if (allComments.isEmpty) {
      return const Center(
        child: Text(
          '还没有评论\n浏览文章时写下你的想法吧',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: allComments.entries.expand((entry) {
        final articleId = entry.key;
        final comments = entry.value;
        final article = MockData.getArticleById(articleId);
        final articleTitle = article != null
            ? (article['title'] ?? '未知文章')
            : '文章 ID: $articleId';

        return comments.map((comment) {
          return GestureDetector(
            onTap: () {
              if (article != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ArticleDetailPage(),
                    settings: RouteSettings(arguments: article),
                  ),
                );
              }
            },
            child: Container(
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
                      const Icon(Icons.article_outlined,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          articleTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          size: 16, color: AppColors.textTertiary),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  // 收藏分栏
  Widget _buildSavedTab(UserActivityService activity) {
    final savedIds = activity.savedArticles.toList();
    if (savedIds.isEmpty) {
      return const Center(
        child: Text(
          '还没有收藏\n看到感兴趣的文章就收藏起来吧',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: savedIds.map((id) {
        final article = MockData.getArticleById(id);
        final articleTitle = article != null
            ? (article['title'] ?? '未知文章')
            : '未知文章 (ID: $id)';

        return GestureDetector(
          onTap: () {
            if (article != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ArticleDetailPage(),
                  settings: RouteSettings(arguments: article),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.bookmark,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    articleTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 点赞分栏
  Widget _buildLikedTab(UserActivityService activity) {
    final likedIds = activity.likedArticles.toList();
    if (likedIds.isEmpty) {
      return const Center(
        child: Text(
          '还没有点赞\n遇到好文章就点个赞吧',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: likedIds.map((id) {
        final article = MockData.getArticleById(id);
        final articleTitle = article != null
            ? (article['title'] ?? '未知文章')
            : '未知文章 (ID: $id)';

        return GestureDetector(
          onTap: () {
            if (article != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ArticleDetailPage(),
                  settings: RouteSettings(arguments: article),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite,
                    size: 18, color: Colors.redAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    articleTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ========== 设置弹窗 ==========
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('帮助与反馈'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('帮助与反馈功能开发中')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('关于我们'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('关于 Brain Scroll'),
                      content: const Text(
                        'Brain Scroll 是一款面向学术爱好者的论文发现应用，帮助你轻松浏览和理解前沿研究。',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('隐私政策'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('隐私政策页面开发中')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }
}
