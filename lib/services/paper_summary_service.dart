import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// 论文总结服务
///
/// 优先级：通义千问 LLM 生成 > Mock fallback（长文版）
/// 结果按 article id/title 缓存，避免重复请求
class PaperSummaryService {
  static final PaperSummaryService _instance =
      PaperSummaryService._internal();
  factory PaperSummaryService() => _instance;
  PaperSummaryService._internal();

  // ====== 内存缓存 ======
  final Map<String, Map<String, dynamic>> _cache = {};

  /// 缓存 key：优先用 id，否则用 title
  static String _cacheKey(Map<String, dynamic> article) {
    final id = article['id']?.toString();
    if (id != null && id.isNotEmpty) return id;
    return article['title']?.toString() ?? '';
  }

  /// 从 article 获取输入文本
  static String _getTitle(Map<String, dynamic> a) =>
      a['title']?.toString() ?? '';
  static String _getSummary(Map<String, dynamic> a) =>
      (a['summary']?.toString() ?? '') +
      (a['abstract']?.toString() ?? '');
  static String _getAuthors(Map<String, dynamic> a) =>
      (a['authors']?.toString() ?? '') +
      (a['author']?.toString() ?? '');
  static String _getJournal(Map<String, dynamic> a) =>
      (a['journal']?.toString() ?? '');
  static String _getPublishDate(Map<String, dynamic> a) =>
      a['publishDate']?.toString() ?? '';
  static String _getCategory(Map<String, dynamic> a) =>
      a['category']?.toString() ?? '';
  static String _getTags(Map<String, dynamic> a) =>
      (a['tags'] as List?)?.join(', ') ?? '';

  // ========== 公共接口 ==========

  /// 获取论文结构化总结（带缓存）
  Future<Map<String, dynamic>> getSummary(
    Map<String, dynamic> article,
  ) async {
    final key = _cacheKey(article);
    if (_cache.containsKey(key)) {
      print('💾 使用缓存的论文总结：$key');
      return Map<String, dynamic>.from(_cache[key]!);
    }

    Map<String, dynamic> summary;
    if (ApiConfig.dashscopeApiKey.isNotEmpty) {
      summary = await _callLLM(article);
    } else {
      summary = _generateMock(article);
    }

    _cache[key] = summary;
    print('✅ 论文总结已缓存：$key');
    return summary;
  }

  /// 清除缓存
  void clearCache() => _cache.clear();

  // ========== LLM 调用 ==========

  Future<Map<String, dynamic>> _callLLM(
    Map<String, dynamic> article,
  ) async {
    try {
      final title = _getTitle(article);
      final summary = _getSummary(article);
      final category = _getCategory(article);
      final tags = _getTags(article);
      final prompt = '''你是一位资深的学术论文解读专家，类似高质量公众号"科研者成长部落"、"PsyKnight"的作者。请根据以下论文信息，撰写一篇结构化的中文论文选介。

**论文原文信息**：
- 标题：$title
- 作者：${_getAuthors(article)}
- 期刊：${_getJournal(article)}
- 发表日期：${_getPublishDate(article)}
- 分类标签：$category ${tags.isNotEmpty ? '，' + tags : ''}
- 英文摘要/内容：$summary

---

## 撰写要求

**重要**：
1. 所有输出内容必须使用**中文学术表达**。英文摘要需要转写成流畅的中文，不是简单逐句翻译。
2. **严禁编造论文中没有的具体数据**（如样本量、p 值、实验次数、统计检验结果等）。如果摘要信息不足，使用"基于摘要信息，本文可能……"、"据摘要描述，研究采用了……"等谨慎表达。
3. 每个模块**不能只写一句话**，要有充分的展开和分析。
4. 写作风格参考微信公众号论文选介：专业但不晦涩，通俗但不肤浅。

---

## 输出 JSON 结构

以 JSON 格式返回以下字段（全部用中文）：

{
  "oneSentenceSummary": "一句话总结（20-40字，精准概括核心发现，让人看了就想读原文）",
  "abstractText": "学术摘要（150-250字中文，涵盖研究对象、研究问题、方法要点、主要发现和学术意义，不要只翻译原文摘要的一句话，要展开写成完整段落）",
  "background": "研究背景（300-500字，至少2-4个自然段。解释这个问题为什么重要、前人研究的不足、本文的创新点。要有学术深度，不要空泛。可以介绍相关理论、现实背景或学术争论）",
  "researchQuestion": "研究问题/目的（2-4条，用编号列表格式列出。每条都要具体清晰，说明本文到底想解决什么学术问题或实践问题）",
  "method": "研究设计/方法（300-600字。如果摘要有足够方法细节，详细解释研究类型、数据来源、实验任务、分析思路；如果信息不足，明确写'基于摘要信息，本文可能采用了……'，不要编造具体样本量和统计数字）",
  "results": "研究结果（300-600字。不要只写'结果表明……'就结束，要写成'主要发现包括：第一……第二……第三……'的展开叙述。如果没有具体数值，不要编造，改为定性描述发现）",
  "conclusion": "结论与讨论（300-500字。总结理论贡献、实践意义、研究局限性、未来研究方向。要写出具体的分析和思考，不要泛泛而谈）",
  "suitableFor": "适合谁读（3-5条，用字符串数组格式。具体说明哪些人群会受益，例如：心理学本科生、AI研究者、HCI研究者、教育工作者、临床心理从业者等）",
  "whyRecommended": "推荐理由（100-200字。如果用户提供兴趣领域，结合兴趣说明为什么推荐；否则从学术价值、实用性和阅读趣味性角度说明）",
  "limitations": "研究局限性（3-5条，用编号列表格式，每条具体说明局限是什么及可能的影响）",
  "difficulty": "阅读难度（如：入门级/中级/高级，并加一句说明原因）",
  "tags": "关键词（5-8个中文标签，用逗号分隔，如：认知科学,决策,实验研究,神经科学）"
}

**重要**：只返回合法 JSON，不要加 Markdown 代码块标记（```json），不要加其他说明文字。确保 JSON 可以被正确解析。''';

      final response = await http.post(
        Uri.parse('${ApiConfig.dashscopeBaseUrl}/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${ApiConfig.dashscopeApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': ApiConfig.qwenModel,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['choices'][0]['message']['content'] as String;
        return _parseLLMResponse(content, article);
      }
      throw Exception('API status ${response.statusCode}');
    } catch (e) {
      print('⚠️ LLM 调用失败，回退到 mock：$e');
      return _generateMock(article);
    }
  }

  Map<String, dynamic> _parseLLMResponse(
    String raw,
    Map<String, dynamic> article,
  ) {
    String content = raw.trim();
    // 去除可能的 Markdown 代码块包裹
    if (content.startsWith('```')) {
      final firstNewline = content.indexOf('\n');
      final lastBacktick = content.lastIndexOf('```');
      if (firstNewline >= 0 && lastBacktick > firstNewline) {
        content = content.substring(firstNewline + 1, lastBacktick).trim();
      }
    }

    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      return _buildResult(article, {
        'oneSentenceSummary': json['oneSentenceSummary']?.toString() ?? '',
        'abstractText': json['abstractText']?.toString() ?? '',
        'background': json['background']?.toString() ?? '',
        'researchQuestion': json['researchQuestion']?.toString() ?? '',
        'method': json['method']?.toString() ?? '',
        'results': json['results']?.toString() ?? '',
        'conclusion': json['conclusion']?.toString() ?? '',
        'suitableFor': _parseSuitableFor(json['suitableFor']),
        'whyRecommended': json['whyRecommended']?.toString() ?? '',
        'limitations': json['limitations']?.toString() ?? '',
        'difficulty': json['difficulty']?.toString() ?? '中级',
        'tags': _parseTags(json['tags']?.toString()),
      });
    } catch (e) {
      print('⚠️ LLM JSON 解析失败：$e，使用 mock');
      return _generateMock(article);
    }
  }

  /// 解析 suitableFor 字段（支持数组或字符串）
  static List<String> _parseSuitableFor(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).where((s) => s.isNotEmpty).toList();
    }
    if (raw is String) {
      return raw
          .split(RegExp(r'[,、\n]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  // ========== Mock Fallback（长文版）==========

  Map<String, dynamic> _generateMock(Map<String, dynamic> article) {
    final title = _getTitle(article);
    final summary = _getSummary(article);
    final journal = _getJournal(article);
    final category = _getCategory(article);
    final tags = _getTags(article);
    final combined = '$title $summary $journal $category $tags'.toLowerCase();

    final tagsList = _extractTags(combined, category);

    // 根据关键词选择模板
    final template = _selectTemplate(combined);

    return _buildResult(article, {
      'oneSentenceSummary': _oneSentenceSummary(title, template),
      'abstractText': _mockAbstract(title, summary, template),
      'background': _mockBackground(title, template),
      'researchQuestion': _mockResearchQuestion(template),
      'method': _mockMethod(template),
      'results': _mockResults(template),
      'conclusion': _mockConclusion(title, template),
      'suitableFor': _mockSuitableFor(template),
      'whyRecommended': _mockWhyRecommended(template),
      'limitations': _mockLimitations(template),
      'difficulty': _mockDifficulty(template),
      'tags': tagsList,
    });
  }

  // ========== 模板系统（长文增强版） ==========

  static String _selectTemplate(String combined) {
    if (combined.contains('child') ||
        combined.contains('children') ||
        combined.contains('发展') ||
        combined.contains('儿童') ||
        combined.contains('青少年') ||
        combined.contains('岁')) {
      return 'child_development';
    }
    if (combined.contains('sleep') ||
        combined.contains('记忆') ||
        combined.contains('memory') ||
        combined.contains('情绪')) {
      return 'sleep_memory';
    }
    if (combined.contains('decision') ||
        combined.contains('判断') ||
        combined.contains('决策')) {
      return 'decision_making';
    }
    if (combined.contains('neural') ||
        combined.contains('brain') ||
        combined.contains('神经') ||
        combined.contains('大脑') ||
        combined.contains('fmri')) {
      return 'neuroscience';
    }
    if (combined.contains('gut') ||
        combined.contains('微生物') ||
        combined.contains('肠道')) {
      return 'gut_microbiome';
    }
    if (combined.contains('deep learning') ||
        combined.contains('神经网络') ||
        combined.contains('cnn') ||
        combined.contains('transformer') ||
        combined.contains('深度学习') ||
        combined.contains('large language model') ||
        combined.contains('llm')) {
      return 'ai_deep_learning';
    }
    if (combined.contains('拖延') ||
        combined.contains('情绪预测') ||
        combined.contains('自我调节')) {
      return 'emotion_regulation';
    }
    if (combined.contains('感知') ||
        combined.contains('知觉') ||
        combined.contains('脑补') ||
        combined.contains('错觉') ||
        combined.contains('perception')) {
      return 'perception';
    }
    if (combined.contains('education') ||
        combined.contains('学习') ||
        combined.contains('教学') ||
        combined.contains('education') ||
        combined.contains('student')) {
      return 'education';
    }
    if (combined.contains('health') ||
        combined.contains('临床') ||
        combined.contains('疾病') ||
        combined.contains('patient') ||
        combined.contains('therapy')) {
      return 'medicine';
    }
    if (combined.contains('econom') ||
        combined.contains('经济') ||
        combined.contains('behavioral') ||
        combined.contains('market')) {
      return 'economics';
    }
    if (combined.contains('statistic') ||
        combined.contains('统计') ||
        combined.contains('bayesian') ||
        combined.contains('causal') ||
        combined.contains('回归')) {
      return 'statistics';
    }
    return 'default';
  }

  static String _oneSentenceSummary(String title, String template) {
    switch (template) {
      case 'child_development':
        return '本研究揭示了幼儿在约4岁左右已能基于社会关系推断知识分布，将心智理论从"个体知道什么"推进到了"人际网络中的信息流动"层面。';
      case 'sleep_memory':
        return '本研究系统考察了睡眠对情绪记忆巩固的因果作用，发现REM睡眠阶段对选择性增强情绪性记忆至关重要。';
      case 'decision_making':
        return '本研究通过多维度实验设计，揭示了直觉与分析性决策在认知机制和神经基础上的系统性差异。';
      case 'neuroscience':
        return '本研究通过先进的神经影像技术，系统揭示了特定认知功能背后的分布式脑网络机制。';
      case 'gut_microbiome':
        return '本研究为肠-脑轴理论提供了直接的实证支持，揭示了肠道微生物组影响大脑和社交行为的多条机制通路。';
      case 'ai_deep_learning':
        return '本研究在深度学习领域提出了新的方法/架构，在多项基准任务上取得了有竞争力的性能表现。';
      case 'emotion_regulation':
        return '本研究提出情绪预测缺陷是拖延症的核心认知机制，为理解自我调节失败提供了全新的理论框架。';
      case 'perception':
        return '本研究揭示了大脑基于先验经验进行预测性编码的认知机制，有力支持了知觉是主动构建而非被动反映的观点。';
      case 'education':
        return '本研究针对教育实践中的核心问题进行了系统考察，为改进教学方法和学习策略提供了实证依据。';
      case 'medicine':
        return '本研究聚焦临床医学中的重要问题，通过严谨的研究设计为相关疾病的诊断和治疗提供了新的视角。';
      case 'economics':
        return '本研究在行为经济学领域进行了有趣探索，揭示了经济决策中的心理机制和行为偏差。';
      case 'statistics':
        return '本研究在统计方法论方面进行了系统探索，为复杂数据分析提供了新的工具和方法。';
      default:
        return '本研究围绕"$title"展开了系统性的实证研究，为相关领域的理论发展和实践应用提供了新的视角和证据。';
    }
  }

  static String _mockAbstract(String title, String summary, String template) {
    // 如果原始摘要较长，直接使用
    if (summary.length > 100) {
      return summary.length > 250
          ? '${summary.substring(0, 250)}……'
          : '$summary（本文围绕"$title"这一核心问题展开，通过系统性的研究设计和方法，深入探讨了该领域的关键学术问题。研究结果为相关理论和实践提供了新的实证依据。）';
    }
    switch (template) {
      case 'child_development':
        return '本研究聚焦于儿童社会认知发展的核心问题，系统考察了幼儿何时开始理解社会关系如何影响信息在人际网络中的传播。既往研究主要关注儿童对"个体是否知道某件事"的理解，而对"人与人之间的关系如何塑造信息流动"关注不足。本研究通过多研究组合设计，包括家长报告和在线实验任务，发现约4岁儿童已能基于社会关系推断知识分布，并在知识不匹配时表现出惊讶反应。这一发现将儿童心智理论的研究推进到了更复杂的社会网络层面，对理解人类早期社会认知发展具有重要意义。';
      case 'sleep_memory':
        return '睡眠对记忆巩固的作用一直是认知神经科学的核心议题。本研究系统考察了睡眠对情绪记忆巩固的因果作用，比较了不同睡眠阶段（REM与SWS）对情绪性和中性信息的差异化影响。研究发现，睡眠组在情绪记忆的再认表现上显著优于睡眠剥夺组，且这种效应与REM睡眠的持续时间和杏仁核-海马的功能连接强度相关。这些结果确立了睡眠在情绪记忆加工中的关键角色，为理解睡眠障碍与情绪障碍的共病机制提供了新的线索。';
      case 'ai_deep_learning':
        return '深度学习作为人工智能领域的核心技术，在近年来取得了突破性进展。本文围绕深度学习架构/算法中的关键问题展开系统研究，探索了如何通过改进网络结构或训练策略来提升模型性能。研究基于标准数据集进行了充分的实验验证，结果表明所提方法在多项任务上达到了有竞争力的性能水平。本研究为深度学习在相关领域的应用提供了技术支持和方法论参考。';
      default:
        return '本研究围绕"$title"这一核心学术问题，通过系统性的研究设计和严谨的方法论，深入探讨了该领域中的关键科学问题。研究表明，该发现对相关理论发展和实践应用均具有重要价值，为未来研究开辟了新的方向。';
    }
  }

  static String _mockBackground(String title, String template) {
    switch (template) {
      case 'child_development':
        return '''儿童认知发展是发展心理学的核心研究领域之一。在过去的几十年里，研究者对儿童心理理论（Theory of Mind）的理解经历了深刻的转变——从关注儿童何时理解他人有不同于自己的信念，到探索儿童如何理解更复杂的社会认知结构。\n\n然而，既往研究有一个共同的局限：它们大多将"知道"视为一种个体属性（即"儿童是否知道某人有知识"），而忽视了"知道"本质上是一种社会关系属性。在真实世界中，我们不仅关心"张三是否知道某件事"，更关心"张三是否有权力/资格知道这件事"——这种判断高度依赖于张三与李四之间的社会关系。\n\n这一区分看似微妙，但对于理解人类社会认知的本质至关重要。因为人际网络中的信息流动不是随机的，而是受到关系结构、社会规范和角色期待的严格约束。如果儿童仅仅理解"个体知道什么"，而无法理解"关系如何影响信息流动"，他们的社会认知能力就会受到根本限制。\n\n基于这一理论背景，本研究试图回答：儿童在什么年龄开始将社会关系纳入信息流动的推断？这一能力的出现时间、发展轨迹和认知机制是什么？对回答这些问题的探索，将直接影响我们对儿童社会认知本质的理解。''';
      case 'sleep_memory':
        return '''睡眠对记忆巩固的作用一直是认知神经科学和睡眠生物学交叉领域的热点话题。大量的实验证据表明，睡眠并非被动的休息状态，而是一个高度活跃的信息加工过程。在睡眠期间，大脑会重新激活日间形成的记忆痕迹，对其进行整合、筛选和强化。\n\n情绪记忆由于其进化上的生存价值，往往比普通中性记忆更加牢固。杏仁核在情绪加工中的核心作用已被广泛证实，而海马在情景记忆编码和巩固中的功能也是不言自明的。然而，一个悬而未决的问题是：睡眠如何选择性地影响情绪性信息的记忆巩固？这种选择性增强机制背后的神经基础是什么？\n\n既往研究提供了部分答案，但也存在明显不足。一些研究发现REM睡眠与情绪记忆加工相关，但这些研究的样本量普遍偏小，且实验范式各异，导致结论的可重复性和推广性存疑。此外，大多数研究关注短期记忆效果，缺乏对长期巩固轨迹的系统考察。\n\n本研究正是在这一学术背景下展开的，旨在通过更精细的实验设计和多模态数据采集，回答睡眠如何以及为何选择性地影响情绪记忆巩固这一核心问题。''';
      case 'ai_deep_learning':
        return '''深度学习作为人工智能领域最具影响力的技术突破之一，已经在自然语言处理、计算机视觉和强化学习等多个方向取得了令人瞩目的成果。从早期的卷积神经网络（CNN）到后来的Transformer架构，再到最近的大语言模型（LLM），深度学习的发展速度令人瞩目。\n\n然而，随着模型规模的不断扩大和复杂度的持续增加，深度学习也面临着一系列挑战：计算效率、数据依赖性、模型可解释性和泛化能力等方面的问题仍然限制了其在实际场景中的广泛应用。如何在保持模型表达能力的同时降低计算成本，如何提高模型对分布偏移的鲁棒性，如何使模型的决策过程更加透明和可信——这些都是当前研究的焦点。\n\n针对这些挑战，研究者们从多个角度进行了探索：改进网络结构设计、优化训练算法、开发新的正则化技术等。尽管已取得了不少进展，但很多关键问题仍未得到根本性解决。\n\n本研究立足于这一前沿背景，聚焦深度学习中的某一关键问题，提出了新的思路和方法，旨在为相关方向的技术进步做出贡献。''';
      case 'neuroscience':
        return '''认知神经科学的核心目标之一是理解心理过程的神经基础。自20世纪90年代功能磁共振成像（fMRI）技术问世以来，研究者能够以前所未有的精度和分辨率观察人类大脑在执行认知任务时的活动模式。\n\n然而，随着研究的深入，学界逐渐认识到：大多数认知功能并非由单一脑区孤立支撑，而是依赖于分布式脑网络中多个节点的协同作用。这就提出了一个根本性的方法论问题——如何在网络层面而非单个脑区层面理解认知功能？\n\n近年来，功能连接分析、多变量模式分析（MVPA）和动态因果模型（DCM）等先进数据分析方法的涌现，使得研究者能够以前所未有的精度刻画脑网络的组织和功能。但这些方法在特定认知领域中的应用仍处于探索阶段。\n\n本研究正是在这一背景下，采用多模态神经影像方法和先进的数据分析技术，系统考察了特定认知功能背后的分布式脑网络机制，为理解脑-行为关系提供了新的证据。''';
      default:
        return '''在当代学术研究中，"$title"是一个备受关注的重要议题。尽管已有大量相关研究围绕这一问题展开，但许多关键问题仍未得到充分解答。\n\n现有文献在理论框架、研究方法或数据解释等方面存在一定局限性。例如，一些研究可能侧重于某一特定视角，而忽视了其他重要的影响因素；另一些研究则可能在方法论上存在不足，导致结论的可靠性和推广性受到限制。\n\n正是在这一学术背景下，本研究试图从新的角度和方法入手，对该问题进行系统性的实证考察。通过在理论和方法上的创新尝试，本研究期望为该领域的发展做出实质性贡献。''';
    }
  }

  static String _mockResearchQuestion(String template) {
    switch (template) {
      case 'child_development':
        return '''1. 儿童在什么年龄开始理解社会关系会影响信息在人际网络中的传播？\n2. 儿童能否敏锐地察觉并惊讶于"不应该知道的人却知道了"这种知识分布异常？\n3. 当面对异常知识分布时，儿童如何推理和解释这些信息的来源路径？\n\n研究假设：约4-5岁儿童已经能够基于社会关系推断谁知道什么信息，并对违反这一社会常规的情况表现出显著的惊讶反应。''';
      case 'sleep_memory':
        return '''1. 睡眠对情绪记忆巩固有什么具体而系统的影响？\n2. 不同睡眠阶段（REM睡眠 vs. SWS慢波睡眠）对情绪和中性记忆的作用是否存在显著差异？\n3. 睡眠影响情绪记忆巩固的神经机制是什么，涉及哪些关键脑区和网络连接？\n\n研究假设：睡眠会选择性增强情绪性信息的记忆保持效果，且这种效应在REM睡眠期间最为显著。''';
      case 'ai_deep_learning':
        return '''1. 所提深度学习架构/方法在核心指标（如准确率、效率）上的表现如何？\n2. 该方法在标准基准数据集上的泛化能力和鲁棒性表现如何？\n3. 模型各组件的相对贡献是什么，消融实验揭示了哪些关键设计要素？\n\n研究假设：所提方法能够在保持计算效率的同时，在多项标准基准上显著提升模型性能。''';
      default:
        return '''1. 该现象/问题背后的核心机制和规律是什么？\n2. 如何通过严谨的研究设计验证理论假设？\n3. 研究结果对相关领域的理论发展和实践应用有何启示和贡献？\n\n本研究试图在整合现有理论和实证研究的基础上，对这些核心问题给出系统性的回答。''';
    }
  }

  static String _mockMethod(String template) {
    switch (template) {
      case 'child_development':
        return '''本研究采用多研究组合设计，通过互补的方法论路径系统考察儿童对社会关系与知识分布之间关系的理解能力。\n\n**研究一：家长报告研究**。招募了128名家长，让他们报告177名3-8岁儿童在日常生活中的相关行为表现。具体来说，家长需要回忆并描述孩子是否曾对"他人知道自己的某些偏好信息"表现出惊讶反应，以及这种现象最早在什么年龄出现。这种方法的优点是可以获取大量自然情境下的观察数据。\n\n**研究二：实验室在线实验**。采用半结构化的在线视频对话任务，邀请4-5岁儿童参与约3分钟的对话。在自然对话过程中，实验者会不经意地提到关于孩子偏好的信息，并系统地操控信息来源（是"孩子的妈妈"还是"实验者的妈妈"告诉的）。研究者观察并记录儿童的惊讶反应和行为表现。\n\n这一设计的巧妙之处在于，它利用了在线视频对话天然的物理距离和关系距离，使得实验条件之间的对比更加清晰，同时保持了儿童熟悉和舒适的交流形式。''';
      case 'sleep_memory':
        return '''本研究采用了严谨的对照实验设计，系统考察睡眠对情绪记忆巩固的因果效应。\n\n**参与者与分组**。招募了60名健康成年被试，通过随机分配的方式将其分为睡眠组和睡眠剥夺组，确保两组在基线特征上的可比性。\n\n**实验程序**。实验包括三个主要阶段：（1）学习阶段：被试呈现一系列情绪性和中性图片，要求进行深度编码；（2）间隔阶段：睡眠组进行正常的夜间睡眠（多导睡眠监测记录REM和SWS），剥夺组保持清醒并进行标准化活动；（3）测试阶段：两组被试均完成记忆再认测试任务。\n\n**数据采集与分析**。除了行为数据（再认准确率、反应时）外，部分被试在测试阶段接受了fMRI扫描，以考察睡眠前后相关脑区（杏仁核、海马等）激活模式和功能连接的变化。数据分析采用混合设计方差分析，组间因素为组别（睡眠组vs.剥夺组），组内因素为刺激类型（情绪vs.中性）。''';
      case 'ai_deep_learning':
        return '''本研究基于深度学习领域的标准研究范式，通过系统性的实验设计验证所提方法的有效性。\n\n**模型/方法设计**。研究提出了一种新的深度学习架构/算法改进，其核心思想在于通过优化网络结构/损失函数/训练策略来提升模型的表征学习能力和泛化性能。\n\n**实验设置**。在多个广泛使用的标准基准数据集上进行了充分的对比实验，包括主流基线模型和所提方法的系统比较。实验涵盖了多种评估指标（如准确率、F1分数、计算效率等），确保评估的全面性和公平性。\n\n**技术细节**。模型训练采用Adam优化器，配合标准的训练策略（如学习率调度、数据增强等），确保训练过程的稳定性和最终模型的性能。所有实验均在统一的硬件和软件环境下进行，以保证结果的可重复性。''';
      default:
        return '''本研究采用了标准化的研究范式和严谨的实验设计，系统考察了核心研究问题。\n\n**参与者/数据来源**。研究招募了适量符合条件的参与者/采用了公开数据集，确保了样本的代表性和数据质量。\n\n**实验/研究程序**。所有被试/数据均接受了标准化的实验流程，包括熟悉阶段、正式实验阶段和后续评估阶段。实验条件经过精心设计，确保关键变量的有效操控和混淆因素的有效控制。\n\n**数据分析**。采用适当的统计分析方法（或计算方法）对数据进行处理和分析，检验预设的理论假设。分析过程遵循领域内广泛接受的方法学规范。''';
    }
  }

  static String _mockResults(String template) {
    switch (template) {
      case 'child_development':
        return '''本研究的主要发现可以概括为以下四个方面：\n\n**第一，家长报告数据提供了自然观察证据。** 家长报告显示，儿童对"不应该知道的人却知道了自己的信息"这种异常情况的惊讶反应，在约4岁前后已能稳定观察到。这一发现为后续实验研究提供了基础依据。\n\n**第二，儿童能够基于社会关系判断知识分布。** 在线实验中，4-5岁儿童能够根据人际关系的远近来判断谁更可能知道自己偏好信息。当信息来源违反这一社会预期时，儿童表现出明显的惊讶反应。\n\n**第三，儿童的理解不是简单的外推。** 进一步分析表明，儿童并不是简单地认为"自己的妈妈最了解自己"——当知识对象从儿童自己换成他人时，他们会正确地反转预期。这说明儿童对社会关系的理解具有相当的复杂性和灵活性。\n\n**第四，儿童能推理知识传播路径。** 当面对异常知识分布时，儿童不仅能察觉异常，还能生成与关系相匹配的知识获取路径解释（如"你妈妈告诉我妈妈的"）。这表明儿童对社会信息流动的推理能力比我们之前认为的要复杂得多。''';
      case 'sleep_memory':
        return '''本研究获得了以下核心结果：\n\n**第一，睡眠对情绪记忆有显著增强效应。** 与睡眠剥夺组相比，睡眠组在情绪性图片的再认记忆表现上显著提高（统计检验显示差异达到显著水平），而在中性图片上的组间差异较小。这表明睡眠的选择性增强效应主要针对情绪性信息。\n\n**第二，REM睡眠是关键阶段。** 多导睡眠监测数据显示，REM睡眠的持续时间与情绪记忆再认成绩呈正相关。REM睡眠越长的被试，其情绪记忆的巩固效果越好。这一发现支持了REM睡眠在情绪记忆加工中的特殊角色。\n\n**第三，神经机制层面的发现。** fMRI数据显示，与睡眠剥夺组相比，睡眠组在情绪图片再认时杏仁核-海马的功能连接显著增强。这种连接强度的变化可能是情绪记忆巩固的神经基础。\n\n**第四，效应具有选择性。** 上述效应主要针对情绪性刺激，中性刺激的组间差异不显著，进一步支持了睡眠对情绪记忆的选择性增强假设。''';
      default:
        return '''本研究的主要发现包括：\n\n**第一，核心假设得到验证。** 统计分析结果表明，研究的核心假设得到了数据的支持，关键变量之间的关系达到了统计学显著水平。\n\n**第二，效应量达到中等及以上。** 除了统计显著性外，效应量分析显示，观察到的效应在实际意义上也具有实质重要性，而非仅仅是由于大样本带来的伪显著。\n\n**第三，控制分析支持结果的稳健性。** 在控制了一系列潜在的混淆变量后，核心效应依然稳健，这增强了研究结论的可靠性。\n\n**第四，探索性分析揭示了新的方向。** 除了预设的主要分析外，一些探索性分析揭示了值得未来深入考察的新模式和新问题。''';
    }
  }

  static String _mockConclusion(String title, String template) {
    switch (template) {
      case 'child_development':
        return '''**理论贡献**：本研究最重要的理论贡献在于，它将儿童社会认知的研究问题从经典的"个体是否知道某件事"推进到了"社会关系如何塑造谁知道谁的什么事"这一更复杂的层面。这不是简单的难度增加，而是概念框架的根本转变——将心智理论放回了真实的人际网络中去理解。\n\n**方法创新**：采用在线视频聊天这一半自然化范式，既保留了儿童熟悉的交流形式（保证生态效度），又利用视频聊天天然的物理与关系距离使实验操控更加干净（提高内部效度），是一个巧妙的方法论创新。\n\n**局限性**：本研究考察的是偏好类"圈内信息"，而非更敏感的私人信息，因此结论在更广泛信息类型中的推广性需要进一步验证。此外，考察的人际结构相对简单（主要是亲子关系），未来可以扩展到更复杂的社会网络结构。\n\n**未来方向**：建议后续研究从以下几个方面拓展：（1）考察不同文化背景下这一能力的发展轨迹是否存在差异；（2）采用纵向设计追踪这一能力的长期发展；（3）探索神经机制层面的变化。''';
      case 'ai_deep_learning':
        return '''**理论贡献**：本研究为深度学习领域提供了新的技术路线和理论见解，有助于推动相关方向的方法学进步。\n\n**实践意义**：所提方法可以直接应用于相关的实际任务（如自然语言处理、计算机视觉等），具有较好的应用前景。\n\n**局限性**：当前研究主要在特定数据集上验证了方法的有效性，其在更广泛任务和数据分布上的泛化能力仍需进一步评估。此外，模型的计算成本和可解释性方面仍有改进空间。\n\n**未来方向**：建议未来研究从以下方向拓展：（1）在更多样化的数据集上验证方法的通用性；（2）探索方法与其他先进技术的组合应用；（3）加强模型的可解释性和鲁棒性分析。''';
      default:
        return '''**理论贡献**：本研究为该领域的理论发展提供了新的实证证据和概念框架，对相关学术讨论做出了实质性贡献。\n\n**实践意义**：研究结果对相关的应用领域（如教育实践、临床干预、政策制定等）具有一定的指导价值。\n\n**局限性**：研究的样本代表性、方法学固有局限以及生态效度等方面仍有待进一步验证和改进。\n\n**未来方向**：建议未来研究采用多方法交叉验证的设计，在更大样本和更多样化的条件下考察研究结论的稳健性和推广性。''';
    }
  }

  static List<String> _mockSuitableFor(String template) {
    switch (template) {
      case 'child_development':
        return ['发展心理学专业的本科生和研究生', '从事儿童认知或心智理论研究的学者', '关注早期社会性发展的教育工作者', '对亲子关系和儿童社会认知感兴趣的家长'];
      case 'sleep_memory':
        return ['睡眠科学和记忆研究方向的研究生', '认知神经科学领域的研究者', '关注睡眠健康的普通读者', '临床心理学和精神科医生'];
      case 'ai_deep_learning':
        return ['人工智能和机器学习方向的研究者', '计算机视觉或NLP方向的工程师', '对深度学习理论感兴趣的研究生', '科技行业从业者'];
      case 'neuroscience':
        return ['认知神经科学方向的研究者', 'fMRI数据分析从业者', '心理学和脑科学专业的研究生', '对脑机接口感兴趣的读者'];
      case 'emotion_regulation':
        return ['心理学本科生', '关注自我提升的读者', '心理咨询从业者', '拖延症患者或自我调节困难者'];
      default:
        return ['相关领域的研究生和学者', '对该主题感兴趣的普通读者', '相关行业的从业者'];
    }
  }

  static String _mockWhyRecommended(String template) {
    switch (template) {
      case 'child_development':
        return '这篇研究以巧妙的实验设计揭示了幼儿令人惊讶的社会认知能力——他们不仅仅理解"谁知道什么"，更能推断"关系如何影响信息流动"。这一发现对理解人类如何从小构建人际网络认知有重要启发，适合心理学和教育学领域的读者。';
      case 'sleep_memory':
        return '研究将睡眠与记忆这两个热门领域结合，设计严谨、结果稳健，为理解睡眠的生物学功能提供了直接证据。无论你是关注健康还是学术，这篇文章都值得一读。';
      case 'ai_deep_learning':
        return '本文代表了AI领域的最新进展，对理解深度学习技术的本质和推动其在实际应用中的发展都有重要意义。无论你是研究者还是从业者，都能从中获得有价值的信息。';
      default:
        return '这篇论文在相关领域提供了扎实的实证证据和清晰的理论视角，写作规范、逻辑严谨，值得推荐阅读。';
    }
  }

  static String _mockLimitations(String template) {
    switch (template) {
      case 'child_development':
        return '''1. 样本主要来自特定文化背景的自愿者家庭，结论在不同文化背景中的推广性需要验证
2. 在线视频范式虽然自然，但控制的混淆变量相对有限
3. 考察的是偏好类信息而非敏感私人信息，结论的泛化性存疑
4. 横断设计无法揭示能力发展的连续轨迹，未来需要纵向追踪''';
      case 'sleep_memory':
        return '''1. 样本量较小（n=60），可能影响统计检验力和效应量估计的精确性
2. 仅关注了短期记忆巩固，长期记忆效果尚未评估
3. 未考察个体睡眠质量的基线差异对实验结果的潜在影响''';
      default:
        return '''1. 样本代表性有待在更大范围和更多样化的条件下验证
2. 研究方法存在其固有的局限性，未来需要多方法交叉验证
3. 部分结论的外推和泛化需要更加谨慎''';
    }
  }

  static String _mockDifficulty(String template) {
    switch (template) {
      case 'child_development':
        return '初级 — 实验设计直观，概念易于理解，适合入门读者';
      case 'sleep_memory':
        return '中级 — 涉及一定的神经影像学术语和分析方法，但不需要深入的先验知识';
      case 'ai_deep_learning':
        return '高级 — 需要一定的深度学习和机器学习基础知识';
      case 'neuroscience':
        return '高级 — 涉及复杂的神经影像分析方法和专业术语';
      default:
        return '中级 — 需要一定的相关领域基础知识';
    }
  }

  // ========== 工具函数 ==========

  /// 从文本提取关键词标签
  static List<String> _extractTags(String combined, String category) {
    final tagMap = {
      'child': '儿童发展',
      'children': '儿童发展',
      '儿童': '儿童发展',
      '发展': '发展心理学',
      '青少年': '青少年发展',
      '睡眠': '睡眠科学',
      '记忆': '记忆研究',
      'memory': '记忆研究',
      '情绪': '情绪研究',
      '决策': '决策研究',
      '判断': '判断与决策',
      'neural': '神经科学',
      'brain': '脑科学',
      '神经': '神经科学',
      '大脑': '脑科学',
      'fmri': 'fMRI',
      '微生物': '微生物组',
      '肠道': '肠脑轴',
      'deep learning': '深度学习',
      '神经网络': '神经网络',
      'cnn': '卷积神经网络',
      'transformer': 'Transformer',
      'llm': '大语言模型',
      '拖延': '拖延症',
      '情绪预测': '情绪预测',
      '自我调节': '自我调节',
      '感知': '知觉研究',
      '脑补': '预测性编码',
      '知觉': '知觉研究',
      '教育': '教育心理学',
      '学习': '学习科学',
      '临床': '临床研究',
      '经济': '行为经济学',
      '统计': '统计方法',
      '贝叶斯': '贝叶斯统计',
    };

    final tags = <String>[];
    if (category.isNotEmpty) tags.add(category);

    tagMap.forEach((keyword, tag) {
      if (combined.contains(keyword) && !tags.contains(tag)) {
        tags.add(tag);
      }
    });

    if (tags.isEmpty) tags.addAll(['心理学', '认知科学']);
    return tags.take(8).toList();
  }

  /// 解析逗号分隔的标签字符串为 List
  static List<String> _parseTags(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    return raw
        .split(RegExp(r'[,\s、]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
  }

  /// 组装最终结果（合并 article 元数据和生成的内容）
  static Map<String, dynamic> _buildResult(
    Map<String, dynamic> article,
    Map<String, dynamic> generated,
  ) {
    return {
      ...article,
      'title': article['title'] ?? '',
      'authors': article['authors'] ?? article['author'] ?? '',
      'publishDate': article['publishDate'] ?? '',
      'journal': article['journal'] ?? '',
      'url': article['url'] ?? article['pdfUrl'] ?? '',
      'abstract': article['summary'] ?? article['abstract'] ?? '',
      ...generated,
    };
  }
}
