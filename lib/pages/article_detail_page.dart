import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../services/paper_summary_service.dart';
import '../services/user_activity_service.dart';
import '../theme/app_colors.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  // 7 模块数据
  Map<String, dynamic> _paperData = {};
  bool _isLoading = true;

  // 图片轮播状态
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  // 模拟 3 张轮播图（使用封面图 + 占位图）
  List<String> _coverImages = [];

  // 当前文章 ID（用于关联用户活动）
  String _articleId = '';

  // ====== Mock 评论数据（按文章类型分组） ======
  static const List<Map<String, String>> _mockCommentsPool = [
    {
      'avatar': '🧑‍🔬',
      'nickname': '科研探索者',
      'content': '这个研究设计挺适合做课堂讨论的，特别是实验范式的设计逻辑很清晰。',
      'time': '2 小时前',
    },
    {
      'avatar': '👨‍🎓',
      'nickname': '读研中的小明',
      'content': '方法部分值得细看，尤其是样本选择和被试分组的设计，很有参考价值。',
      'time': '5 小时前',
    },
    {
      'avatar': '🧠',
      'nickname': '脑科学爱好者',
      'content': '如果能补充纵向数据会更有说服力，现在的横断设计还是有一定局限。',
      'time': '1 天前',
    },
    {
      'avatar': '📚',
      'nickname': '文献搬运工',
      'content': '这篇的 effect size 看起来不错，但样本量可以再大一点就更好了。',
      'time': '2 天前',
    },
    {
      'avatar': '🎓',
      'nickname': '博士在路上了',
      'content': '跟之前那篇 Nature 的结果基本一致，算是很好的 replication + extension。',
      'time': '3 天前',
    },
    {
      'avatar': '💡',
      'nickname': '方法论控',
      'content': '统计分析方法用得很规范，报告了 effect size 和 CI，值得学习。',
      'time': '4 天前',
    },
    {
      'avatar': '🌟',
      'nickname': '认知科学观察',
      'content': 'Discussion 部分写得好，把理论贡献和实际应用都说清楚了。',
      'time': '5 天前',
    },
    {
      'avatar': '🔬',
      'nickname': '实验小白',
      'content': '请问一下实验程序大概多久？我们实验室也在做类似的方向，想参考一下。',
      'time': '1 周前',
    },
    {
      'avatar': '🧪',
      'nickname': '统计达人',
      'content': '中介效应分析的那部分没太看懂，作者能补充一下 bootstrap 的参数设置吗？',
      'time': '1 周前',
    },
    {
      'avatar': '🎯',
      'nickname': '心理学前沿',
      'content': '预注册 + 开放数据，这个研究团队的透明度做得很好，推荐大家看看原始论文。',
      'time': '2 周前',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchArticleAndGenerateContent();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ========== Markdown 清理函数 ==========
  /// 清理文本中的 Markdown 强调符号，返回纯文本
  String _cleanDisplayText(String text) {
    return text
        .replaceAll('**', '')
        .replaceAll('*', '')
        .replaceAll('※', '')
        .trim();
  }

  /// 确保 tags 字段为 List 类型（渲染兼容性）
  Map<String, dynamic> _ensureTagsList(Map<String, dynamic> data) {
    final rawTags = data['tags'];
    if (rawTags == null) return data;
    if (rawTags is List) return data; // 已是 List，无需处理
    if (rawTags is String) {
      data['tags'] = rawTags
          .split(RegExp(r'[,\s、]+'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } else {
      data['tags'] = [];
    }
    return data;
  }

  // ========== 数据加载 ==========
  Future<void> _fetchArticleAndGenerateContent() async {
    try {
      final rawArticle =
          ModalRoute.of(context)?.settings.arguments as Map?;
      final article =
          rawArticle == null ? null : Map<String, dynamic>.from(rawArticle);

      if (article != null) {
        final paperId = article['id']?.toString() ?? '';
        _articleId = paperId;

        // 首先尝试从 MockData 获取详细内容
        Map<String, String>? details;
        if (paperId.isNotEmpty &&
            MockData.paperDetails.containsKey(paperId)) {
          details = MockData.paperDetails[paperId];
          print('✅ 使用预定义的论文详情：$paperId');
        }

        if (details != null) {
          setState(() {
            _paperData = {...article, ...details!};
            _isLoading = false;
            _initCoverImages(article);
          });
        } else {
          // 尝试 LLM 总结（内置缓存 + mock fallback）
          final summary =
              await PaperSummaryService().getSummary(article);
          setState(() {
            _paperData = _ensureTagsList({...article, ...summary});
            _isLoading = false;
            _initCoverImages(article);
          });
        }
      } else {
        setState(() {
          _paperData = _getDefaultPaperData();
          _isLoading = false;
          _articleId = 'default';
          _initCoverImages(_getDefaultPaperData());
        });
      }
    } catch (e) {
      print('加载论文数据失败：$e');
      setState(() {
        _paperData = _getDefaultPaperData();
        _isLoading = false;
        _articleId = 'default';
        _initCoverImages(_getDefaultPaperData());
      });
    }
  }

  void _initCoverImages(Map<String, dynamic> article) {
    final imagePath = article['coverImagePath'] as String?;
    if (imagePath != null && imagePath.isNotEmpty) {
      _coverImages = [imagePath, imagePath, imagePath];
    } else {
      _coverImages = [];
    }
  }

  /// 为每篇文章生成 2-4 条 mock 评论（基于文章 ID 的哈希值保持一致）
  List<Map<String, String>> _getMockComments() {
    final hash = _articleId.hashCode.abs();
    final count = 2 + (hash % 3); // 2-4 条评论
    final result = <Map<String, String>>[];
    for (int i = 0; i < count; i++) {
      result.add(Map<String, String>.from(_mockCommentsPool[(hash + i) % _mockCommentsPool.length]));
    }
    return result;
  }

  Map<String, dynamic> _getDefaultPaperData() {
    return {
      'title': 'PNAS | 4 岁孩子已经会判断"谁本来就该知道我的事"了',
      'author': 'PsyBrain Daily',
      'publishDate': '2026-03-20',
      'journal': 'PNAS',
      'abstract': '儿童什么时候开始理解社会关系会影响信息如何在人际网络中流动？',
      'background':
          '''日常社交里，有一条很少被明说、却几乎人人都在默认使用的规则：越亲近的人，越可能知道你的"圈内信息（insider knowledge）"。比如，妈妈知道你最喜欢吃什么，通常不奇怪；但如果一个几乎不认识的人准确说出你最爱的电影，这种感觉就会立刻变得不对劲，甚至让人有些不安。

这类判断看似琐碎，其实是很多社会行为的底层机制。我们如何沟通、如何判断亲疏、如何管理声誉、如何理解八卦为什么会传播，背后都离不开对"谁知道谁的什么事"的快速推断。问题在于，儿童什么时候开始具备这种能力？他们是否已经不只是理解"某个人知道什么"，而是开始理解"人与人之间的关系，会影响信息如何在人际网络中流动"？

这篇发表于 PNAS 的研究，正是围绕这个问题展开。作者结合家长报告，以及看似随意、实则严格控制的在线视频对话任务，考察儿童会不会自发地对不合常理的知识分布感到惊讶，并进一步解释这些信息可能是怎么传过去的。''',
      'objective': '''本研究旨在探索以下核心问题：

1. 儿童何时开始理解社会关系会影响信息传播？
2. 儿童能否察觉"不应该知道的人却知道了"这种异常情况？
3. 儿童能否解释异常知识的来源路径？

研究假设：4-5 岁儿童已经能够基于社会关系推断谁知道什么信息，并对违反这一规律的情况表现出惊讶。''',
      'design': '''整篇论文由三个相互衔接的研究组成：

Study 1：家长报告研究
- 参与者：128 名家长，报告 177 名 3-8 岁儿童情况
- 方法：家长报告孩子是否曾对他人知道自己的信息感到惊讶
- 测量：估计反应最早出现的年龄，描述具体事件

Study 2：实时视频对话实验
- 参与者：4-5 岁儿童
- 程序：约 3 分钟 Zoom 对话，实验者自然提起孩子偏好
- 条件：信息来源为"孩子的妈妈"vs"实验者的妈妈"
- 测量：儿童的惊讶反应

Study 3：知识来源推断
- 框架：沿用 Study 2 对话框架
- 问题："你觉得她是怎么知道的"
- 编码：第一手解释、第二手解释、不确定''',
      'results': '''发现一：家长报告显示，儿童对"不太该知道的人却知道自己信息"的惊讶，在约 4 岁前后已能观察到。

发现二：在实时视频对话中，4-5 岁儿童会依据关系判断谁更可能知道自己的偏好，并在不匹配时表现出惊讶。

发现三：儿童并不是简单地认为"自己的妈妈最懂自己"，因为当知识对象换成他人时，他们会把预期整体反转。

发现四：儿童不仅能察觉异常知识分布，还能生成与关系相匹配的知识获取路径解释。''',
      'conclusion': '''理论贡献：
这篇研究最有价值的地方，在于它把儿童社会认知的问题从经典的"个体是否知道某件事"，推进到了"社会关系如何塑造谁知道谁的什么事"。这不是简单增加一个任务难度，而是把儿童心智理论放回了真实的人际网络中去理解。

方法创新：
采用在线视频聊天这一半自然化范式，既保留了儿童熟悉的交流形式，又利用视频聊天天然的物理与关系距离，降低了混淆可能性。

研究局限：
- 研究考察的是偏好类"圈内信息"，而非更敏感的私人信息
- 考察的人际结构相对简单
- 最稳妥的结论是"幼儿已表现出早期出现的、以社会关系为基础的知识分布直觉"''',
    };
  }

  // ========== Build ==========
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              // 分享按钮
              IconButton(
                icon:
                    const Icon(Icons.share_outlined, color: AppColors.textPrimary),
                onPressed: () {
                  _showShareBottomSheet(context);
                },
              ),
              // 收藏按钮（有状态）
              Consumer<UserActivityService>(
                builder: (context, activity, _) {
                  final isSaved = activity.isSaved(_articleId);
                  return IconButton(
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: isSaved
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    onPressed: () {
                      activity.toggleSave(_articleId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSaved ? '已取消收藏' : '已收藏',
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),

          // 文章内容
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片轮播
                if (_coverImages.isNotEmpty) ...[
                  _buildImageCarousel(),
                  const SizedBox(height: 16),
                ],
                // 标题
                _buildTitleModule(),
                const SizedBox(height: 12),
                // 标签
                if (_paperData['tags'] != null &&
                    (_paperData['tags'] as List).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_paperData['tags'] as List<String>)
                          .map((tag) {
                        final color = _getMorandiColorForTag(tag);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: color.withOpacity(0.5)),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                // 作者信息栏
                _buildAuthorBar(),
                const SizedBox(height: 16),
                // 基本信息卡片（左右边距 22）
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                  child: _buildInfoCard(),
                ),
                const SizedBox(height: 20),
                // 7 个内容模块（左右边距 22）
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModule('摘要', _paperData['abstractText'] ?? _paperData['abstract'] ?? ''),
                      const SizedBox(height: 20),
                      _buildModule('研究背景', _paperData['background'] ?? _paperData['abstract'] ?? ''),
                      const SizedBox(height: 20),
                      _buildModule('研究目的', _paperData['objective'] ?? ''),
                      const SizedBox(height: 20),
                      _buildModule('研究设计', _paperData['design'] ?? ''),
                      const SizedBox(height: 20),
                      _buildModule('研究结果', _paperData['results'] ?? ''),
                      const SizedBox(height: 20),
                      _buildModule(
                          '结论与讨论', _paperData['conclusion'] ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // 互动区（左右边距 22）
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: _buildInteractionBar(),
                ),
                const SizedBox(height: 16),
                // 评论区入口（左右边距 22）
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: _buildCommentsEntry(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ========== 组件 ==========

  // 图片轮播
  Widget _buildImageCarousel() {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _coverImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _coverImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                ),
              );
            },
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_coverImages.length, (index) {
                return Container(
                  width: _currentImageIndex == index ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceBackground,
      child: const Icon(Icons.image, size: 48, color: AppColors.textTertiary),
    );
  }

  // 小红书风格作者信息栏
  Widget _buildAuthorBar() {
    final journalName = _paperData['journal'] ?? '';
    final journalLogo = _paperData['journalLogo'] ?? '📖';
    final author = _paperData['author'] ?? '';
    final publishDate = _paperData['publishDate'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Consumer<UserActivityService>(
        builder: (context, activity, _) {
          final isSubscribed = activity.isSubscribed(journalName);
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getGradientForJournal(
                                              journalName)
                                          .colors
                                          .first,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(journalLogo,
                                          style: const TextStyle(
                                              fontSize: 24)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      journalName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '$author · $publishDate',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '点击「订阅」可关注该期刊的最新内容',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getGradientForJournal(journalName)
                          .colors
                          .first,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(journalLogo,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  journalName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$author · $publishDate',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '点击「订阅」可关注该期刊的最新内容',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          journalName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$author · $publishDate',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    activity.toggleSubscribe(journalName);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSubscribed
                              ? '已取消订阅 $journalName'
                              : '已订阅 $journalName',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSubscribed
                        ? AppColors.surfaceBackground
                        : AppColors.primary,
                    foregroundColor:
                        isSubscribed ? AppColors.textSecondary : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isSubscribed ? '已订阅' : '订阅',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Gradient _getGradientForJournal(String journal) {
    final journalLower = journal.toLowerCase();
    if (journalLower.contains('nature')) {
      return const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]);
    }
    if (journalLower.contains('science')) {
      return const LinearGradient(
          colors: [Color(0xFF4A90D9), Color(0xFF365490)]);
    }
    if (journalLower.contains('cell')) {
      return const LinearGradient(
          colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)]);
    }
    if (journalLower.contains('pnas')) {
      return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)]);
    }
    return const LinearGradient(
        colors: [Color(0xFFA8B8C8), Color(0xFFB5A8C4)]);
  }

  Color _getMorandiColorForTag(String tag) {
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

  // 标题模块
  Widget _buildTitleModule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Text(
        _paperData['title'] ?? '',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
    );
  }

  // 基本信息卡片（左右边距 22）
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Title', _paperData['title'] ?? ''),
          const Divider(height: 24),
          _buildInfoRow('发表日期', _paperData['publishDate'] ?? ''),
          const Divider(height: 24),
          _buildInfoRow('期刊', _paperData['journal'] ?? ''),
          const Divider(height: 24),
          Row(
            children: [
              const Text(
                '获取原文',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const Spacer(),
              const Text(
                '添加小助手：PSY-Brain-Frontier',
                style: TextStyle(
                    color: AppColors.textTertiary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            _cleanDisplayText(value),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // 通用模块构建器（公众号风格：居中胶囊标题 + 内容卡片）
  Widget _buildModule(String title, String content) {
    final cleanContent = _cleanDisplayText(content);
    if (cleanContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 居中胶囊/徽章样式标题
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 内容卡片
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Text(
            cleanContent,
            style: const TextStyle(
              fontSize: 15,
              height: 1.8,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // 互动区（有状态）
  Widget _buildInteractionBar() {
    return Consumer<UserActivityService>(
      builder: (context, activity, _) {
        final isLiked = activity.isLiked(_articleId);
        final isSaved = activity.isSaved(_articleId);
        final totalComments = _getTotalCommentCount();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInteractionItem(
              icon: isLiked ? Icons.favorite : Icons.favorite_border,
              count: '${( _paperData['likes'] ?? 256) + (isLiked ? 1 : 0)}',
              color: isLiked ? Colors.red : AppColors.textPrimary,
              onTap: () {
                activity.toggleLike(_articleId);
              },
            ),
            _buildInteractionItem(
              icon: isSaved ? Icons.star : Icons.star_border,
              count: '${_paperData['saves'] ?? 89 + (isSaved ? 1 : 0)}',
              color: isSaved ? Colors.amber : AppColors.textPrimary,
              onTap: () {
                activity.toggleSave(_articleId);
              },
            ),
            _buildInteractionItem(
              icon: Icons.comment_outlined,
              count: '$totalComments',
              color: AppColors.textPrimary,
              onTap: () {
                _showCommentSheet(context);
              },
            ),
            _buildInteractionItem(
              icon: Icons.share_outlined,
              count: '分享',
              color: AppColors.textPrimary,
              onTap: () {
                _showShareBottomSheet(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 获取评论总条数（mock 评论 + 用户评论）
  int _getTotalCommentCount() {
    final userComments = context.read<UserActivityService>().getCommentsForArticle(_articleId).length;
    return _getMockComments().length + userComments;
  }

  Widget _buildInteractionItem({
    required IconData icon,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 评论区入口
  Widget _buildCommentsEntry() {
    return GestureDetector(
      onTap: () => _showCommentSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '查看全部 ${_getTotalCommentCount()} 条评论',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  // ========== 评论弹窗 ==========
  void _showCommentSheet(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (stateContext, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标题栏
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          '评论 ${_getTotalCommentCount()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text(
                            '关闭',
                            style: TextStyle(color: AppColors.textTertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // 评论列表
                  Flexible(
                    child: Consumer<UserActivityService>(
                      builder: (context, activity, _) {
                        final userComments = activity.getCommentsForArticle(_articleId);
                        final allComments = [..._getMockComments()];

                        // 添加用户评论（带时间信息）
                        for (final uc in userComments) {
                          allComments.insert(0, {
                            'avatar': '😊',
                            'nickname': '我',
                            'content': uc,
                            'time': '刚刚',
                          });
                        }

                        if (allComments.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                '暂无评论，来发表第一条评论吧~',
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: allComments.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, index) {
                            final comment = allComments[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.surfaceBackground,
                                    child: Text(
                                      comment['avatar'] ?? '👤',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment['nickname'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              comment['time'] ?? '',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textTertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment['content'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // 输入框
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: '写下你的想法...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.surfaceBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send,
                              color: AppColors.primary, size: 24),
                          onPressed: () {
                            final text = controller.text.trim();
                            if (text.isNotEmpty) {
                              context
                                  .read<UserActivityService>()
                                  .addComment(_articleId, text);
                              controller.clear();
                              setModalState(() {});
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ========== 分享底栏 ==========
  void _showShareBottomSheet(BuildContext context) {
    final title = _paperData['title'] ?? '';
    final journal = _paperData['journal'] ?? '';
    final oneSentence = _paperData['oneSentenceSummary'] ?? _paperData['abstract'] ?? '';
    final url = _paperData['url'] ?? _paperData['pdfUrl'] ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: const [
                    Text(
                      '分享',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_outward, color: AppColors.textTertiary),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 分享选项
              _buildShareOption(
                icon: Icons.link,
                label: '复制链接',
                subtitle: '复制文章链接到剪贴板',
                onTap: () {
                  Navigator.pop(ctx);
                  _copyShareLink(title, url);
                },
              ),
              _buildShareOption(
                icon: Icons.wechat,
                label: '分享到微信',
                subtitle: '分享给微信好友',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('分享接口开发中'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _buildShareOption(
                icon: Icons.campaign_outlined,
                label: '分享到朋友圈',
                subtitle: '分享给所有微信好友',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('分享接口开发中'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _buildShareOption(
                icon: Icons.picture_as_pdf,
                label: '生成分享卡片',
                subtitle: '生成精美的分享图片',
                onTap: () {
                  Navigator.pop(ctx);
                  _showShareCardPreview(context, title, journal, oneSentence);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
      ),
      onTap: onTap,
    );
  }

  /// 复制链接到剪贴板
  void _copyShareLink(String title, String url) {
    final shareText = '$title\n${url.isNotEmpty ? url : 'https://brainscroll.app/article/$_articleId'}';
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制分享链接'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// 显示分享卡片预览
  void _showShareCardPreview(
    BuildContext context,
    String title,
    String journal,
    String summary,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 340),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.morandiBlue.withOpacity(0.3),
                  AppColors.morandiPurple.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    journal.isNotEmpty ? journal : 'BrainScroll',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  summary.length > 100 ? '${summary.substring(0, 100)}...' : summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.smartphone, size: 16, color: AppColors.textTertiary),
                    SizedBox(width: 6),
                    Text(
                      'BrainScroll · 随时发现值得关注的科研进展',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('关闭预览'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 底部评论输入栏
  Widget _buildBottomBar() {
    final TextEditingController controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showCommentSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '写下你的想法...',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.send,
                color: AppColors.primary, size: 24),
            onPressed: () {
              _showCommentSheet(context);
            },
          ),
        ],
      ),
    );
  }
}
