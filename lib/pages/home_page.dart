import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/xiaohongshu_card.dart';
import '../data/mock_data.dart';
import '../services/arxiv_service.dart';
import '../services/user_activity_service.dart';
import '../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tab 状态：'subscribe' 或 'recommend'
  String currentTab = 'recommend';

  // 分类筛选状态
  String selectedCategory = '全部';

  // 新分类列表
  final List<String> _categories = [
    '全部',
    '认知与决策',
    '情绪与心理健康',
    '脑科学与神经',
    '发展与教育',
    '社会与行为',
    'AI与人类',
    '方法与工具',
  ];

  // 推荐的论文列表
  List<Map<String, dynamic>> papers = [];

  // 加载状态
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;

  // ScrollController 用于监听滚动
  final ScrollController _scrollController = ScrollController();

  // arXiv 服务
  final ArxivService _arxivService = ArxivService();

  // 已加载的论文 ID（用于去重）
  final Set<String> _loadedPaperIds = {};

  // 分类 → arXiv 查询词映射
  static const Map<String, String> _categoryQueryMap = {
    '认知与决策': 'cognitive science decision making',
    '情绪与心理健康': 'emotion mental health psychology',
    '脑科学与神经': 'neuroscience brain cognition',
    '发展与教育': 'developmental psychology education',
    '社会与行为': 'social psychology behavior',
    'AI与人类': 'artificial intelligence human interaction',
    '方法与工具': 'statistics methodology machine learning',
  };

  // 分类 arXiv 缓存：每个分类的请求结果缓存
  final Map<String, List<Map<String, dynamic>>> _categoryArxivCache = {};

  // 分类加载状态
  bool _loadingCategory = false;

  @override
  void initState() {
    super.initState();
    // 初始只加载 Mock 数据，不请求 arXiv
    _loadInitialPapers();
    _scrollController.addListener(_onScroll);
  }

  // 加载初始论文（Mock 数据）
  void _loadInitialPapers() {
    setState(() {
      papers = MockData.papers.map((paper) {
        final newPaper = Map<String, dynamic>.from(paper);
        newPaper['id'] = 'mock_${paper['id']}';
        return newPaper;
      }).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 监听滚动，实现无限下拉加载
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && hasMore) {
        _loadMorePapers();
      }
    }
  }

  // 加载更多论文（划到底部时触发）
  Future<void> _loadMorePapers() async {
    if (isLoading || _loadingCategory) return;

    setState(() {
      isLoading = true;
    });

    try {
      final query = _categoryQueryMap[selectedCategory] ??
          _categoryQueryMap['脑科学与神经']!;
      final newPapers = await _fetchArxivPapersWithQuery(query);

      if (newPapers.isNotEmpty) {
        setState(() {
          papers.addAll(newPapers);
          isLoading = false;
        });
        print('📊 底部加载 ${newPapers.length} 篇论文，当前总数：${papers.length}');
      } else {
        setState(() {
          hasMore = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('加载更多论文失败：$e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 按指定查询词从 arXiv 获取论文（不去重，直接返回）
  Future<List<Map<String, dynamic>>> _fetchArxivPapersWithQuery(
    String query,
  ) async {
    final results = await _arxivService.search(
      query: query,
      maxResults: 10,
    );

    return results.map((paper) {
      final map = paper.toJson(category: selectedCategory);
      final id = map['id']?.toString() ?? '';
      if (!id.startsWith('arxiv_')) {
        map['id'] = 'arxiv_${id.replaceAll('/', '_')}';
      }
      return map;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: false,
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              title: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        currentTab = 'subscribe';
                      });
                    },
                    child: Text(
                      '订阅',
                      style: TextStyle(
                        color: currentTab == 'subscribe'
                            ? Colors.black
                            : Colors.grey,
                        fontSize: 16,
                        fontWeight: currentTab == 'subscribe'
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        currentTab = 'recommend';
                      });
                    },
                    child: Text(
                      '推荐',
                      style: TextStyle(
                        color: currentTab == 'recommend'
                            ? Colors.black
                            : Colors.grey,
                        fontSize: 16,
                        fontWeight: currentTab == 'recommend'
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, color: AppColors.textTertiary, size: 24),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            // 分类标签
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: _categories
                        .map((cat) => _buildChip(cat))
                        .toList(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (currentTab == 'subscribe') {
      return _buildSubscribePage();
    } else {
      return _buildRecommendPage();
    }
  }

  // 订阅页
  Widget _buildSubscribePage() {
    final activity = context.watch<UserActivityService>();
    if (activity.subscribedJournals.isEmpty) {
      // 空状态提示
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '┗|｀O′|┛ 啊哦~这里空空如也',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '快去大世界浏览文章并订阅你喜欢的期刊吧~',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    // 按订阅期刊筛选论文
    final subscribed = activity.subscribedJournals;
    final filtered = papers.where((p) {
      final journal = p['journal']?.toString() ?? '';
      return subscribed.any((s) => journal.contains(s.toString()));
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '已订阅的期刊暂无新文章',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return _buildPaperListWithPapers(filtered);
  }

  // 推荐页
  Widget _buildRecommendPage() {
    // 合并 Mock + 已缓存的 arXiv 论文
    final displayPapers = _getDisplayPapers();

    return RefreshIndicator(
      onRefresh: () async {
        // 重置为初始状态
        currentPage = 0;
        hasMore = true;
        _loadedPaperIds.clear();
        _categoryArxivCache.clear();
        setState(() {
          papers = MockData.papers.map((paper) {
            final newPaper = Map<String, dynamic>.from(paper);
            newPaper['id'] = 'mock_${paper['id']}';
            return newPaper;
          }).toList();
        });
      },
      child: _buildPaperListWithPapers(displayPapers),
    );
  }

  /// 合并 Mock 数据 + 当前分类的 arXiv 缓存
  List<Map<String, dynamic>> _getDisplayPapers() {
    final result = <Map<String, dynamic>>[];
    final existingIds = <String>{};

    // 1. 先加入所有 Mock 论文
    for (final p in papers) {
      final pid = p['id']?.toString() ?? '';
      if (pid.isNotEmpty) existingIds.add(pid);
      result.add(p);
    }

    // 2. 加入当前分类的 arXiv 论文
    final arxivList = _categoryArxivCache[selectedCategory] ?? [];
    for (final p in arxivList) {
      final pid = p['id']?.toString() ?? '';
      if (!existingIds.contains(pid)) {
        result.add(p);
        existingIds.add(pid);
      }
    }

    // 3. 按分类筛选
    if (selectedCategory != '全部') {
      return result.where((p) => p['category'] == selectedCategory).toList();
    }
    return result;
  }

  // 论文列表（双列瀑布流）
  Widget _buildPaperList() {
    return _buildPaperListWithPapers(papers);
  }

  Widget _buildPaperListWithPapers(List<Map<String, dynamic>> displayPapers) {
    // 分类 arXiv 加载中，且暂无本地内容时显示 loading
    if (_loadingCategory && displayPapers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              '正在获取 arXiv 论文...',
              style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (displayPapers.isEmpty && isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (displayPapers.isEmpty) {
      return Center(
        child: const Text(
          '该分类下暂无内容',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    // 将数据分成左右两列
    final leftPapers = <Map<String, dynamic>>[];
    final rightPapers = <Map<String, dynamic>>[];

    for (int i = 0; i < displayPapers.length; i++) {
      if (i % 2 == 0) {
        leftPapers.add(displayPapers[i]);
      } else {
        rightPapers.add(displayPapers[i]);
      }
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧列
          Expanded(
            flex: 10,
            child: Column(
              children: leftPapers
                  .map((paper) => XiaohongshuCard(
                        paper: paper,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(width: 6),
          // 右侧列
          Expanded(
            flex: 9,
            child: Column(
              children: rightPapers
                  .map((paper) => XiaohongshuCard(
                        paper: paper,
                      ))
                  .toList(),
            ),
          ),
          // 底部加载指示器
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          // 没有更多数据提示
          if (!hasMore && papers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '已经到底啦~',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 按分类从 arXiv 获取新论文
  Future<void> _loadArxivForCategory(String category) async {
    if (category == '全部') return;
    if (_loadingCategory) return;
    if (_categoryArxivCache.containsKey(category)) {
      print('💾 使用缓存的 arXiv 论文：$category');
      return;
    }

    setState(() {
      _loadingCategory = true;
    });

    try {
      final query = _categoryQueryMap[category];
      if (query == null) {
        setState(() => _loadingCategory = false);
        return;
      }
      final newPapers = await _fetchArxivPapersWithQuery(query);
      setState(() {
        _categoryArxivCache[category] = newPapers;
        _loadingCategory = false;
      });
      print('✅ arXiv 获取 ${newPapers.length} 篇论文：$category');
    } catch (e) {
      print('❌ arXiv 请求失败 ($category)：$e');
      setState(() {
        _loadingCategory = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('加载 arXiv 论文失败：$category，将显示本地内容'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildChip(String label) {
    final isSelected = label == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
        _loadArxivForCategory(label);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
