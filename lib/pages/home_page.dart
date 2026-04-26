import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/xiaohongshu_card.dart';
import '../data/mock_data.dart';
import '../services/arxiv_service.dart';
import '../services/user_activity_service.dart';
import '../services/user_onboarding_service.dart';
import '../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tab 状态：'subscribe' 或 'recommend'
  String currentTab = 'recommend';

  // 分类筛选状态（优先使用用户兴趣标签）
  String selectedCategory = '全部';

  // 默认分类（当用户没有兴趣标签时使用）
  static const List<String> _defaultCategories = [
    '全部',
    '认知与决策',
    '情绪与心理健康',
    '脑科学与神经',
    '发展与教育',
    '社会与行为',
    'AI与人类',
    '方法与工具',
  ];

  // 搜索状态
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // 推荐的论文列表
  List<Map<String, dynamic>> papers = [];

  // 加载状态
  bool _isLoadingMore = false;

  // 各分类是否还有更多（per-category）
  final Map<String, bool> _categoryHasMore = <String, bool>{};

  /// 当前分类是否还有更多
  bool get _hasMore => _categoryHasMore[selectedCategory] ?? true;

  // ScrollController 用于监听滚动
  final ScrollController _scrollController = ScrollController();

  // arXiv 服务
  final ArxivService _arxivService = ArxivService();

  // 已加载的论文 ID（用于去重）
  final Set<String> _loadedPaperIds = {};

  // ========== 多领域 query 映射 ==========
  static const Map<String, String> _categoryQueryMap = {
    // 用户原始分类
    '认知与决策': 'cognitive science decision making judgment',
    '情绪与心理健康': 'emotion mental health psychology stress anxiety',
    '脑科学与神经': 'neuroscience brain cognition neural',
    '发展与教育': 'developmental psychology education learning child',
    '社会与行为': 'social psychology behavior interaction group',
    'AI与人类': 'artificial intelligence AI machine learning deep learning',
    '方法与工具': 'statistics methodology measurement psychometrics',
    // 用户可能的新增兴趣
    '数学': 'mathematics probability statistics algebra topology geometry',
    '计算机': 'computer science algorithms software engineering systems',
    '人工智能': 'artificial intelligence large language model machine learning',
    '机器学习': 'machine learning deep learning neural network',
    '神经科学': 'neuroscience brain neural computation',
    '教育学': 'education learning science teaching pedagogy',
    '医学': 'medicine public health clinical trial therapy health',
    '经济学': 'economics behavioral economics game theory decision making',
    '统计学': 'statistics Bayesian causal inference data analysis',
    '社会学': 'sociology social inequality population',
    '计算建模': 'computational modeling simulation machine learning',
  };

  // ========== 分页与缓存 ==========
  final Map<String, List<Map<String, dynamic>>> _categoryArxivCache = {};
  final Map<String, int> _categoryPageMap = <String, int>{};
  bool _loadingInitial = false;
  final Map<String, int> _categoryEmptyRetryCount = <String, int>{};

  // ========== 分类 → arXiv 查询 ==========

  /// 获取分类对应的 arXiv 查询词（支持模糊匹配）
  String _getQueryForCategory(String category) {
    if (_categoryQueryMap.containsKey(category)) {
      return _categoryQueryMap[category]!;
    }
    // 模糊匹配：取前缀比较
    final catLen = category.length;
    final catPrefix = catLen >= 2 ? category.substring(0, 2) : category;
    for (final entry in _categoryQueryMap.entries) {
      final keyLen = entry.key.length;
      final keyPrefix = keyLen >= 2 ? entry.key.substring(0, 2) : entry.key;
      if (category.contains(keyPrefix) ||
          entry.key.contains(catPrefix)) {
        return entry.value;
      }
    }
    // 回退：直接使用分类名称
    return category;
  }

  // ========== 领域标签列表 ==========

  List<String> get _categories {
    try {
      final onboarding = context.read<OnboardingService>();
      if (onboarding.isInitialized && onboarding.data.interests.isNotEmpty) {
        return ['全部', ...onboarding.data.interests];
      }
    } catch (_) {}
    return _defaultCategories;
  }

  // ========== 分类匹配 ==========

  bool _isPaperInCategory(Map<String, dynamic> paper, String category) {
    if (category == '全部') return true;
    // 精确匹配 category 字段
    if (paper['category'] == category) return true;
    // 匹配标签（支持中文标签和英文 arXiv 分类）
    final tags = paper['tags'] as List? ?? [];
    if (tags.any((tag) => tag == category)) return true;

    // 构建可搜索文本
    final searchable = [
      paper['title']?.toString() ?? '',
      paper['journal']?.toString() ?? '',
      paper['journalName']?.toString() ?? '',
      paper['summary']?.toString() ?? '',
      paper['abstract']?.toString() ?? '',
    ].join(' ').toLowerCase();

    // 分类中文名关键词匹配
    final catLower = category.toLowerCase();
    if (searchable.contains(catLower) || searchable.contains(category)) return true;

    // 分类关键词拆分匹配
    final keywords = catLower.split(' ');
    for (final keyword in keywords) {
      if (keyword.length > 2 && searchable.contains(keyword)) return true;
    }

    // 针对用户兴趣的中文标签匹配
    // arXiv 返回的英文论文需要匹配到中文分类
    final query = _getQueryForCategory(category);
    final queryWords = query.split(' ');
    for (final word in queryWords) {
      if (word.length > 3 && searchable.contains(word.toLowerCase())) return true;
    }

    return false;
  }

  // ========== 搜索过滤 ==========

  List<Map<String, dynamic>> _applySearch(List<Map<String, dynamic>> papers) {
    if (_searchQuery.isEmpty) return papers;
    final q = _searchQuery.toLowerCase();
    return papers.where((p) {
      final searchable = [
        p['title']?.toString() ?? '',
        p['summary']?.toString() ?? '',
        p['abstract']?.toString() ?? '',
        p['journal']?.toString() ?? '',
        p['journalName']?.toString() ?? '',
        p['author']?.toString() ?? '',
        p['authors']?.toString() ?? '',
        ...(p['tags'] as List? ?? []).map((e) => e.toString()),
      ].join(' ').toLowerCase();
      return searchable.contains(q);
    }).toList();
  }

  // ========== 生命周期 ==========

  @override
  void initState() {
    super.initState();
    _loadInitialPapers();
    _scrollController.addListener(_onScroll);
  }

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

  // ========== 滚动监听 ==========

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMorePapers();
    }
  }

  // ========== 数据加载 ==========

  /// 加载当前分类的 arXiv 初始数据（首次切换分类时）
  Future<void> _loadArxivForCategory(String category) async {
    if (category == '全部') {
      // "全部" 分类：从多个领域混合加载
      await _loadDiversePapers();
      return;
    }

    if (_loadingInitial) return;

    // 缓存命中
    if (_categoryArxivCache.containsKey(category) &&
        _categoryArxivCache[category]!.isNotEmpty) {
      print('💾 使用缓存：$category');
      return;
    }

    setState(() {
      _loadingInitial = true;
    });

    try {
      final query = _getQueryForCategory(category);
      final newPapers = await _fetchArxivPapersWithQuery(query, start: 0, category: category);
      setState(() {
        // 如果 arXiv 返回为空，使用 mock 兜底
        if (newPapers.isEmpty) {
          final fallback = _generateMockFallback(category);
          _categoryArxivCache[category] = fallback;
          print('⚠️ arXiv 无结果，使用 mock 兜底 ${fallback.length} 篇：$category');
        } else {
          _categoryArxivCache[category] = newPapers;
          print('✅ arXiv 获取 ${newPapers.length} 篇：$category');
        }
        _categoryPageMap[category] = 1;
        _loadingInitial = false;
      });
    } catch (e) {
      print('❌ arXiv 请求失败 ($category)：$e，使用 mock 兜底');
      final fallback = _generateMockFallback(category);
      setState(() {
        _categoryArxivCache[category] = fallback;
        _loadingInitial = false;
      });
    }
  }

  /// "全部" 分类：混合多个领域加载
  Future<void> _loadDiversePapers() async {
    if (_loadingInitial) return;
    if (_categoryArxivCache.containsKey('全部') &&
        _categoryArxivCache['全部']!.isNotEmpty) {
      print('💾 使用"全部"缓存');
      return;
    }

    setState(() {
      _loadingInitial = true;
    });

    // 选取多个领域的查询词
    List<String> queries;
    try {
      final onboarding = context.read<OnboardingService>();
      if (onboarding.isInitialized && onboarding.data.interests.isNotEmpty) {
        queries = onboarding.data.interests
            .take(4)
            .map(_getQueryForCategory)
            .toList();
      } else {
        queries = [
          _getQueryForCategory('认知与决策'),
          _getQueryForCategory('AI与人类'),
          _getQueryForCategory('脑科学与神经'),
          _getQueryForCategory('社会与行为'),
        ];
      }
    } catch (_) {
      queries = [
        _getQueryForCategory('认知与决策'),
        _getQueryForCategory('AI与人类'),
        _getQueryForCategory('脑科学与神经'),
      ];
    }

    final allPapers = <Map<String, dynamic>>[];
    final existingIds = _loadedPaperIds.toSet();

    for (final query in queries) {
      try {
        final results = await _arxivService.search(
          query: query,
          maxResults: 5,
          start: 0,
        );
        for (final paper in results) {
          final map = paper.toJson(category: '');
          final id = map['id']?.toString() ?? '';
          final arxivId = id.startsWith('arxiv_') ? id : 'arxiv_${id.replaceAll('/', '_')}';
          if (!existingIds.contains(arxivId)) {
            map['id'] = arxivId;
            allPapers.add(map);
            existingIds.add(arxivId);
          }
        }
      } catch (e) {
        print('⚠️ "全部" 混合加载失败 ($query)：$e');
      }
    }

    setState(() {
      _categoryArxivCache['全部'] = allPapers;
      _categoryPageMap['全部'] = 1;
      _loadingInitial = false;
    });
    print('✅ "全部" 混合加载 ${allPapers.length} 篇');
  }

  /// 加载更多（划到底部时触发）
  Future<void> _loadMorePapers() async {
    if (_isLoadingMore || _loadingInitial) return;
    if (!_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final page = _categoryPageMap[selectedCategory] ?? 0;
      final start = page * 10;

      late List<Map<String, dynamic>> newPapers;

      if (selectedCategory == '全部') {
        // "全部" 用第一个 query 加载更多
        List<String> queries;
        try {
          final onboarding = context.read<OnboardingService>();
          if (onboarding.isInitialized && onboarding.data.interests.isNotEmpty) {
            queries = onboarding.data.interests.take(4).map(_getQueryForCategory).toList();
          } else {
            queries = ['cognitive science', 'machine learning', 'neuroscience'];
          }
        } catch (_) {
          queries = ['cognitive science', 'machine learning'];
        }
        newPapers = [];
        final existingIds = _loadedPaperIds.toSet();
        for (final query in queries) {
          final results = await _arxivService.search(
            query: query,
            maxResults: 5,
            start: start,
          );
          for (final paper in results) {
            final map = paper.toJson(category: '');
            final id = map['id']?.toString() ?? '';
            final arxivId = id.startsWith('arxiv_') ? id : 'arxiv_${id.replaceAll('/', '_')}';
            if (!existingIds.contains(arxivId)) {
              map['id'] = arxivId;
              newPapers.add(map);
              existingIds.add(arxivId);
            }
          }
        }
      } else {
        final query = _getQueryForCategory(selectedCategory);
        newPapers = await _fetchArxivPapersWithQuery(query, start: start, category: selectedCategory);
      }

      if (newPapers.isNotEmpty) {
        setState(() {
          papers.addAll(newPapers);
          // 更新缓存
          final existing = _categoryArxivCache[selectedCategory] ?? [];
          for (final p in newPapers) {
            if (!existing.any((e) => e['id'] == p['id'])) {
              existing.add(p);
            }
          }
          _categoryArxivCache[selectedCategory] = existing;
          _categoryPageMap[selectedCategory] = page + 1;
          _isLoadingMore = false;
          // 重置空重试计数
          _categoryEmptyRetryCount.remove(selectedCategory);
        });
        print('📊 加载更多 ${newPapers.length} 篇，总数：${papers.length}');
      } else {
        // 连续空结果计数
        final retries = _categoryEmptyRetryCount[selectedCategory] ?? 0;
        if (retries >= 2) {
          setState(() {
            _categoryHasMore[selectedCategory] = false;
            _isLoadingMore = false;
          });
          print('🏁 该分类无更多内容：$selectedCategory');
        } else {
          setState(() {
            _categoryEmptyRetryCount[selectedCategory] = retries + 1;
            _isLoadingMore = false;
          });
          print('⚠️ 暂无结果，重试计数：${retries + 1}/3');
        }
      }
    } catch (e) {
      print('加载更多失败：$e');
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  /// 从 arXiv 获取论文
  Future<List<Map<String, dynamic>>> _fetchArxivPapersWithQuery(
    String query, {
    int start = 0,
    String? category,
  }) async {
    final results = await _arxivService.search(
      query: query,
      maxResults: 10,
      start: start,
    );

    return results.map((paper) {
      final map = paper.toJson(category: category ?? selectedCategory);
      final id = map['id']?.toString() ?? '';
      if (!id.startsWith('arxiv_')) {
        map['id'] = 'arxiv_${id.replaceAll('/', '_')}';
      }
      return map;
    }).toList();
  }

  /// 生成某分类的 mock 兜底论文
  List<Map<String, dynamic>> _generateMockFallback(String category) {
    final query = _getQueryForCategory(category);
    final templates = <Map<String, dynamic>>[
      {
        'title': '最新研究：$category 领域的重要发现',
        'summary': '该研究在$category 领域取得了突破性进展，为相关理论和实践提供了新的视角。',
        'journal': 'arXiv',
        'journalName': 'arXiv',
        'journalLogo': '📄',
        'publishDate': '2026-04-20',
        'author': 'Smith et al.',
        'category': category,
        'tags': [category, query.split(' ').firstWhere((w) => w.length > 3, orElse: () => '科学')],
        'likes': 100 + (category.hashCode % 200),
        'coverAspectRatio': 0.85,
      },
      {
        'title': '$category 前沿：新方法与新发现',
        'summary': '本文综述了$category 领域的最新进展，讨论了方法学创新和未来研究方向。',
        'journal': 'arXiv',
        'journalName': 'arXiv',
        'journalLogo': '📄',
        'publishDate': '2026-04-18',
        'author': 'Johnson et al.',
        'category': category,
        'tags': [category, '综述'],
        'likes': 80 + (category.hashCode % 150),
        'coverAspectRatio': 0.9,
      },
      {
        'title': '实证研究：$query 的行为实验证据',
        'summary': '通过精心设计的实验范式，本研究为$category 提供了新的实证证据。',
        'journal': 'arXiv',
        'journalName': 'arXiv',
        'journalLogo': '📄',
        'publishDate': '2026-04-15',
        'author': 'Wang et al.',
        'category': category,
        'tags': [category, '实证研究'],
        'likes': 60 + (category.hashCode % 100),
        'coverAspectRatio': 0.8,
      },
      {
        'title': '理论框架：$category 的计算模型',
        'summary': '本文提出了一种新的计算框架来解释$category 中的核心现象。',
        'journal': 'arXiv',
        'journalName': 'arXiv',
        'journalLogo': '📄',
        'publishDate': '2026-04-12',
        'author': 'Chen et al.',
        'category': category,
        'tags': [category, '理论'],
        'likes': 45 + (category.hashCode % 80),
        'coverAspectRatio': 0.75,
      },
    ];

    return templates.asMap().entries.map((entry) {
      final map = Map<String, dynamic>.from(entry.value);
      map['id'] = 'mock_fallback_${category}_${entry.key}';
      return map;
    }).toList();
  }

  // ========== 构建显示数据 ==========

  List<Map<String, dynamic>> _getDisplayPapers() {
    final result = <Map<String, dynamic>>[];
    final existingIds = <String>{};

    // 1. 加入 Mock 论文
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

    // 3. 分类筛选
    if (selectedCategory != '全部') {
      return result.where((p) => _isPaperInCategory(p, selectedCategory)).toList();
    }
    return result;
  }

  // ========== Build ==========

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
                  _isSearching
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: '搜索论文...',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppColors.surfaceBackground,
                                isDense: true,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          child: const Icon(Icons.search, color: AppColors.textTertiary, size: 24),
                        ),
                  if (_isSearching)
                    IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textTertiary, size: 20),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    )
                  else
                    const SizedBox(width: 12),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: _categories.map((cat) => _buildChip(cat)).toList(),
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

  Widget _buildSubscribePage() {
    final activity = context.watch<UserActivityService>();
    if (activity.subscribedJournals.isEmpty) {
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
              style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    final subscribed = activity.subscribedJournals;
    var filtered = papers.where((p) {
      final journal = p['journal']?.toString() ?? '';
      return subscribed.any((s) => journal.contains(s.toString()));
    }).toList();

    if (selectedCategory != '全部') {
      filtered = filtered.where((p) => _isPaperInCategory(p, selectedCategory)).toList();
    }
    filtered = _applySearch(filtered);

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedCategory == '全部'
                  ? '已订阅的期刊暂无新文章'
                  : '该领域暂无订阅内容，去推荐页发现更多相关文献吧',
              style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    return _buildPaperListWithPapers(filtered);
  }

  Widget _buildRecommendPage() {
    var displayPapers = _getDisplayPapers();
    displayPapers = _applySearch(displayPapers);

    return RefreshIndicator(
      onRefresh: () async {
        _categoryPageMap.clear();
        _categoryHasMore.clear();
        _loadedPaperIds.clear();
        _categoryArxivCache.clear();
        _categoryEmptyRetryCount.clear();
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

  /// 论文列表（双列瀑布流 + 底部 footer）
  Widget _buildPaperListWithPapers(List<Map<String, dynamic>> displayPapers) {
    // 初始加载中
    if (_loadingInitial && displayPapers.isEmpty) {
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

    // 空状态
    if (displayPapers.isEmpty) {
      String emptyMsg;
      if (_searchQuery.isNotEmpty) {
        emptyMsg = '未找到与「$_searchQuery」相关的内容';
      } else if (selectedCategory != '全部') {
        emptyMsg = '该分类下暂无内容，下拉加载更多试试';
      } else {
        emptyMsg = '暂无内容，下滑加载更多';
      }
      return Center(
        child: Text(
          emptyMsg,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    // 分成左右两列
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
      child: Column(
        children: [
          // 两列瀑布流
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  children: leftPapers
                      .map((paper) => XiaohongshuCard(paper: paper))
                      .toList(),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 9,
                child: Column(
                  children: rightPapers
                      .map((paper) => XiaohongshuCard(paper: paper))
                      .toList(),
                ),
              ),
            ],
          ),
          // 底部 footer（在 Row 外面，独立居中）
          if (_isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '正在加载更多...',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!_isLoadingMore && !_hasMore && displayPapers.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
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

  // ========== 分类标签 ==========

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
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceBackground,
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
