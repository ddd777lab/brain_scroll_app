import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

/// arXiv API 服务类
/// 文档：https://arxiv.org/help/api
class ArxivService {
  // 使用 HTTPS 协议
  final String baseUrl = 'https://export.arxiv.org/api/query';

  // 多个 CORS 代理备选
  final List<String> _corsProxies = [
    'https://api.codetabs.com/v1/proxy?quest=',
    'https://corsproxy.io/?',
    'https://api.allorigins.win/raw?url=',
  ];
  int _currentProxyIndex = 0;

  /// 搜索论文
  ///
  /// [query] 搜索关键词
  /// [maxResults] 最大返回数量
  /// [start] 起始位置（用于分页）
  Future<List<ArxivPaper>> search({
    required String query,
    int maxResults = 10,
    int start = 0,
  }) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {
        'search_query': query,
        'start': start.toString(),
        'max_results': maxResults.toString(),
      });

      // Web 环境使用 CORS 代理
      final requestUrl = uri.toString();
      final url = requestUrl.contains('http')
          ? '${_corsProxies[_currentProxyIndex]}${Uri.encodeComponent(requestUrl)}'
          : requestUrl;

      print('📡 请求 arXiv API: $uri (start=$start)');
      if (url != requestUrl) {
        print('🔗 使用 CORS 代理：$url');
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      } else {
        print('❌ arXiv API 错误：${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ arXiv 搜索异常：$e');
      return [];
    }
  }

  /// 分页获取论文
  ///
  /// [query] 搜索关键词
  /// [page] 页码（从 0 开始）
  /// [pageSize] 每页数量
  Future<List<ArxivPaper>> getPapersWithPagination({
    required String query,
    int page = 0,
    int pageSize = 15,
  }) async {
    return search(
      query: query,
      maxResults: pageSize,
      start: page * pageSize,
    );
  }

  /// 根据 arXiv ID 获取论文详情
  Future<ArxivPaper?> getPaperById(String arxivId) async {
    final results = await search(query: 'id:$arxivId', maxResults: 1);
    return results.isNotEmpty ? results.first : null;
  }

  /// 解析 arXiv Atom XML 响应
  List<ArxivPaper> _parseResponse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);

      // arXiv 使用多个命名空间，需要同时查找 atom 和无命名空间的元素
      final entries = document.findAllElements('entry');

      return entries.map((entry) {
        return ArxivPaper(
          id: _getElementText(entry, 'id') ?? '',
          title: _getElementText(entry, 'title')?.replaceAll('\n', ' ').trim() ?? '',
          summary: _getElementText(entry, 'summary')?.replaceAll('\n', ' ').trim() ?? '',
          published: _getElementText(entry, 'published') ?? '',
          authors: entry
              .findAllElements('author')
              .map((author) => _getElementText(author, 'name') ?? '')
              .where((name) => name.isNotEmpty)
              .toList(),
          categories: entry
              .findAllElements('category')
              .map((cat) => cat.getAttribute('term') ?? '')
              .where((term) => term.isNotEmpty)
              .toList(),
          pdfUrl: _getPdfUrl(entry),
        );
      }).toList();
    } catch (e) {
      print('❌ XML 解析错误：$e');
      return [];
    }
  }

  String? _getElementText(XmlElement parent, String tagName) {
    final element = parent.findElements(tagName).firstOrNull;
    return element?.text;
  }

  String _getPdfUrl(XmlElement entry) {
    final links = entry.findAllElements('link', namespace: 'atom');
    for (var link in links) {
      final type = link.getAttribute('type');
      if (type == 'application/pdf') {
        return link.getAttribute('href') ?? '';
      }
    }
    // 如果没有 PDF 链接，返回 arXiv 页面
    return _getElementText(entry, 'id') ?? '';
  }
}

/// arXiv 论文数据模型
class ArxivPaper {
  final String id;
  final String title;
  final String summary;
  final String published;
  final List<String> authors;
  final List<String> categories;
  final String pdfUrl;

  ArxivPaper({
    required this.id,
    required this.title,
    required this.summary,
    required this.published,
    required this.authors,
    required this.categories,
    required this.pdfUrl,
  });

  /// 转换为 Flutter App 可用的格式
  Map<String, dynamic> toJson({String? category}) {
    final idPart = id.split('/').last;
    final primaryCat = categories.isNotEmpty ? categories.first : '';

    // 从 arXiv 分类推断中文显示名
    String journalName;
    switch (primaryCat) {
      case 'cs.AI': journalName = 'AI'; break;
      case 'cs.LG': journalName = '机器学习'; break;
      case 'cs.NE': journalName = '神经网络'; break;
      case 'q-bio.NC': journalName = '神经科学'; break;
      case 'q-bio.QM': journalName = '定量生物学'; break;
      case 'q-bio.NC': journalName = '计算生物学'; break;
      case 'stat.ML': journalName = '统计机器学习'; break;
      case 'physics.bio-ph': journalName = '生物物理'; break;
      case 'eess.SP': journalName = '信号处理'; break;
      case 'eess.IV': journalName = '图像处理'; break;
      default: journalName = primaryCat.isNotEmpty ? primaryCat : 'arXiv';
    }

    // 提取年份
    String year = '2024';
    try {
      year = published.substring(0, 4);
    } catch (_) {}

    return {
      'id': 'arxiv_$idPart',
      'arxivId': id,
      'title': title,
      'summary': summary.length > 200 ? '${summary.substring(0, 200)}...' : summary,
      'abstract': summary,
      'journal': journalName,
      'journalName': journalName,
      'journalLogo': '📄',
      'publishDate': published.length >= 10 ? published.substring(0, 10) : published,
      'year': year,
      'author': authors.length <= 2
          ? authors.join(', ')
          : '${authors[0]} et al.',
      'authors': authors.join(', '),
      'url': pdfUrl.isNotEmpty ? pdfUrl : id,
      'pdfUrl': pdfUrl,
      'category': category ?? '',
      'tags': categories.take(3).toList(),
      'likes': 50 + (idPart.hashCode.abs() % 500),
      'saves': 10 + (idPart.hashCode.abs() % 100),
      'comments': 5 + (idPart.hashCode.abs() % 50),
      'coverImagePath': null,
      'coverAspectRatio': 0.8 + (idPart.hashCode.abs() % 5) * 0.05,
      'coverTemplateColor': _randomColor(idPart),
    };
  }

  static String _randomColor(String seed) {
    final colors = ['blue', 'purple', 'green', 'orange', 'pink', 'teal'];
    return colors[seed.hashCode.abs() % colors.length];
  }

  @override
  String toString() {
    return 'ArxivPaper(title: $title, journal: ${categories.firstOrNull})';
  }
}

/// 使用示例
void main() async {
  final arxivService = ArxivService();

  // 搜索神经科学相关论文
  print('🔍 搜索神经科学论文...');
  final papers = await arxivService.search(
    query: 'neural population coding',
    maxResults: 5,
  );

  for (var paper in papers) {
    print('\n📄 ${paper.title}');
    print('   作者：${paper.authors.take(3).join(', ')}...');
    print('   分类：${paper.categories.join(', ')}');
    print('   PDF: ${paper.pdfUrl}');
  }

  // 搜索特定主题
  print('\n\n🔍 搜索认知发展论文...');
  final developmentalPapers = await arxivService.search(
    query: 'child development social cognition',
    maxResults: 3,
  );

  for (var paper in developmentalPapers) {
    print('\n📄 ${paper.title}');
    print('   摘要：${paper.summary.substring(0, 100)}...');
  }

  // 转换为 App 格式
  print('\n\n📱 转换为 App 数据格式:');
  final appData = papers.map((p) => p.toJson()).toList();
  print(jsonEncode(appData.first));
}

/// 扩展方法：从 arXiv 分类推断期刊/会议名
extension ArxivCategory on ArxivPaper {
  String get readableJournal {
    if (categories.isEmpty) return 'arXiv';

    final categoryMap = {
      'q-bio.NC': '神经科学',
      'q-bio': '计算生物学',
      'cs.AI': '人工智能',
      'cs.LG': '机器学习',
      'cs.NE': '神经网络',
      'q-bio.QM': '定量方法',
      'physics.bio-ph': '生物物理',
      'stat.ML': '统计机器学习',
      'eess.SP': '信号处理',
      'eess.IV': '图像处理',
    };

    for (var cat in categories) {
      if (categoryMap.containsKey(cat)) {
        return categoryMap[cat]!;
      }
    }

    // 返回主分类
    return categories.first.split('.').first;
  }

  /// 获取适合生图的关键词
  String get imageKeywords {
    final keywordMap = {
      'q-bio.NC': '神经网络、大脑、神经元',
      'cs.AI': '人工智能、机器人、科技',
      'cs.LG': '数据可视化、算法、图表',
      'q-bio': 'DNA、细胞、分子',
      'physics': '物理、粒子、波形',
      'stat': '统计图表、数据分布',
    };

    for (var cat in categories) {
      if (keywordMap.containsKey(cat)) {
        return keywordMap[cat]!;
      }
    }

    return '科学研究、数据分析';
  }
}
