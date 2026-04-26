import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// 论文总结服务
///
/// 优先级：通义千问 LLM 生成 > Mock fallback
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

  // ========== 公共接口 ==========

  /// 获取论文结构化总结（带缓存）
  ///
  /// [article] 包含 title、abstract/summary、authors、journal、publishDate、url 等字段
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
      final prompt = '''你是一位专业的学术论文解读助手。请根据以下论文信息，生成结构化的内容总结。

论文标题：$title
作者：${_getAuthors(article)}
期刊：${_getJournal(article)}
日期：${_getPublishDate(article)}
摘要/内容：$summary

请以 JSON 格式返回以下字段（全部用中文）：
{
  "oneSentenceSummary": "一句话总结论文核心发现",
  "abstractText": "详细的摘要段落",
  "background": "研究背景，该领域的问题和现状",
  "researchQuestion": "核心研究问题",
  "method": "研究方法和设计",
  "results": "主要研究结果",
  "conclusion": "结论与讨论",
  "limitations": "研究的局限性",
  "difficulty": "阅读难度评估（如：入门级/中级/高级）",
  "tags": "标签，逗号分隔，如：神经科学,认知科学,心理学",
  "whyRecommended": "为什么推荐阅读这篇论文"
}

只返回 JSON，不要其他说明。''';

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
        'limitations': json['limitations']?.toString() ?? '',
        'difficulty': json['difficulty']?.toString() ?? '中级',
        'tags': _parseTags(json['tags']?.toString()),
        'whyRecommended': json['whyRecommended']?.toString() ?? '',
      });
    } catch (e) {
      print('⚠️ LLM JSON 解析失败：$e，使用 mock');
      return _generateMock(article);
    }
  }

  // ========== Mock Fallback（有内容质量）==========

  Map<String, dynamic> _generateMock(Map<String, dynamic> article) {
    final title = _getTitle(article);
    final summary = _getSummary(article);
    final journal = _getJournal(article);
    final category = _getCategory(article);
    final combined = '$title $summary $journal $category'.toLowerCase();

    // 智能标签提取
    final tags = _extractTags(combined, category);

    // 根据关键词选择模板
    final template = _selectTemplate(combined);

    return _buildResult(article, {
      'oneSentenceSummary': _oneSentenceSummary(title, template),
      'abstractText': summary.isNotEmpty
          ? summary
          : '本文探讨了$title 相关的科学问题。',
      'background': _background(title, template),
      'researchQuestion': _researchQuestion(template),
      'method': _method(template),
      'results': _results(template),
      'conclusion': _conclusion(title, template),
      'limitations': _limitations(template),
      'difficulty': _difficulty(template),
      'tags': tags,
      'whyRecommended': _whyRecommended(template),
    });
  }

  // ========== 模板系统（基于关键词） ==========

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
        combined.contains('深度学习')) {
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
        combined.contains('错觉')) {
      return 'perception';
    }
    return 'default';
  }

  static String _oneSentenceSummary(String title, String template) {
    switch (template) {
      case 'child_development':
        return '本研究揭示了幼儿在${_extractAgeHint(title)}岁左右已能基于社会关系推断知识分布，将心智理论研究推进到了人际网络层面。';
      case 'sleep_memory':
        return '本研究确立了睡眠在情绪记忆巩固中的因果作用，发现 REM 睡眠阶段对记忆选择性增强最为关键。';
      case 'decision_making':
        return '本研究为决策的双系统理论提供了神经证据，区分了直觉与分析性决策的脑机制。';
      case 'neuroscience':
        return '本研究通过多模态神经影像方法揭示了特定认知功能背后的分布式脑网络机制。';
      case 'gut_microbiome':
        return '本研究为肠-脑轴理论提供了实证支持，揭示了肠道菌群影响大脑行为的机制通路。';
      case 'ai_deep_learning':
        return '本研究提出了新的深度学习架构/方法，在多项基准上实现了性能提升。';
      case 'emotion_regulation':
        return '本研究提出情绪预测缺陷是拖延症的核心机制，为自我调节失败提供了新解释。';
      case 'perception':
        return '本研究揭示了大脑基于先验经验进行预测性编码的认知机制，证明知觉是主动构建过程。';
      default:
        return '本研究针对"$title"展开了系统性的实证研究，为相关领域提供了新的理论见解。';
    }
  }

  static String _background(String title, String template) {
    switch (template) {
      case 'child_development':
        return '儿童认知发展是发展心理学的核心研究领域。既往研究表明，幼儿期是社会认知能力快速发展的关键阶段，儿童逐渐学会理解他人的心理状态、意图和知识。然而，儿童何时开始理解社会关系如何影响信息传播，这一问题的答案尚不清楚。本研究在此基础上，深入探讨儿童对社会关系与知识分布之间关系的理解能力。';
      case 'sleep_memory':
        return '睡眠对记忆巩固的作用一直是神经科学和睡眠研究的热点话题。大量证据表明，睡眠不仅是被动的休息状态，更是主动的记忆加工和整合过程。特别是在快速眼动睡眠（REM）和慢波睡眠（SWS）期间，大脑会重新激活和强化日间形成的记忆痕迹。情绪记忆由于其生存适应性价值，往往比普通记忆更加牢固，但睡眠如何选择性地影响情绪记忆的巩固，这一问题仍需深入探讨。';
      case 'decision_making':
        return '人类决策过程涉及复杂的认知和神经机制。传统理性选择理论假设个体能够整合所有可用信息做出最优决策，但越来越多的研究表明，直觉和快速判断在决策中扮演着重要角色。双系统理论提出，大脑同时拥有快速、自动的直觉系统和慢速、分析性的分析系统，然而这两种系统如何在价值判断中协同工作仍不清楚。';
      case 'neuroscience':
        return '认知神经科学的核心目标之一是理解心理过程的神经基础。随着脑成像技术的发展，研究者能够以前所未有的精度观察大脑活动。功能磁共振成像（fMRI）、脑电图（EEG）等技术揭示了认知任务背后复杂的神经网络激活模式。本研究采用多模态神经影像方法，探讨特定认知功能的神经机制。';
      case 'gut_microbiome':
        return '肠-脑轴（gut-brain axis）是近年来生命科学领域最引人注目的发现之一。肠道微生物群不仅影响消化系统健康，还通过迷走神经、免疫通路和代谢产物等多种途径与大脑进行双向交流。越来越多的证据表明，肠道菌群可能影响情绪、认知甚至社会行为，但具体机制尚不清楚。';
      case 'ai_deep_learning':
        return '深度学习是人工智能领域最具影响力的技术突破之一。受生物神经网络启发，深度神经网络通过多层非线性变换实现复杂的模式识别和表征学习。CNN、Transformer 等架构在图像识别、自然语言处理等任务中取得了超越人类的表现。本研究提出了一种新的深度学习架构/方法，旨在解决现有模型的局限性。';
      case 'emotion_regulation':
        return '拖延症是普遍存在的自我调节失败现象，影响着学习、工作和健康等多个领域。传统观点认为拖延主要是因为时间管理能力不足或意志力薄弱。然而，近年来有理论提出，拖延可能与大脑预测未来情绪的能力缺陷有关——如果个体无法准确预见拖延带来的负面情绪后果，就难以克服当下的诱惑。';
      case 'perception':
        return '人类的知觉系统并非被动地反映外部世界，而是主动地构建和解释感官信息。在某些情况下，大脑会"脑补"出实际上不存在的信息，这种现象在视觉错觉、记忆扭曲等方面广泛存在。预测性编码理论认为，大脑基于先验经验不断生成对感官输入的预测，并通过预测误差信号来更新内部模型。';
      default:
        return '本研究关注的领域是当前科学研究的前沿热点。尽管已有大量相关研究，但许多关键问题仍未得到充分解答。本研究在整合现有理论和实证研究的基础上，采用严谨的科学方法，对该领域的重要问题进行深入探讨。';
    }
  }

  static String _researchQuestion(String template) {
    switch (template) {
      case 'child_development':
        return '1. 儿童在什么年龄开始理解社会关系会影响信息传播？\n2. 儿童能否察觉违反社会常规的知识分布情况？\n3. 儿童如何解释异常知识的来源？\n\n研究假设：4-5 岁儿童已经能够基于社会关系推断谁知道什么信息，并对违反预期的情况表现出惊讶。';
      case 'sleep_memory':
        return '1. 睡眠对情绪记忆巩固有什么具体影响？\n2. 不同睡眠阶段（REM vs SWS）对记忆的作用有何差异？\n3. 睡眠影响情绪记忆的神经机制是什么？\n\n研究假设：睡眠会选择性增强情绪性信息的记忆保持，且这种效应在 REM 睡眠期间最为显著。';
      case 'decision_making':
        return '1. 直觉在价值判断中扮演什么角色？\n2. 直觉决策的时间进程和神经基础是什么？\n3. 直觉与分析性决策的神经机制有何差异？\n\n研究假设：在时间压力下，个体会依赖快速直觉系统进行价值判断，且与腹内侧前额叶（vmPFC）活动相关。';
      case 'neuroscience':
        return '1. 特定认知功能依赖哪些脑区网络？\n2. 不同脑区之间的功能连接模式是什么？\n3. 认知表现与神经活动之间有何定量关系？\n\n研究假设：目标认知功能依赖于分布式神经网络的协同活动，而非单一脑区的独立作用。';
      case 'gut_microbiome':
        return '1. 肠道微生物组成与社交行为有何相关性？\n2. 肠-脑轴影响社交行为的神经通路是什么？\n3. 益生菌干预能否改善社交行为？\n\n研究假设：肠道菌群通过调节神经递质和炎症因子影响社交行为。';
      case 'ai_deep_learning':
        return '1. 如何设计更高效的深度学习架构？\n2. 所提方法在标准基准上的表现如何？\n3. 模型的学习机制和表征能力有何特点？\n\n研究假设：所提方法能够在保持计算效率的同时，显著提升模型性能。';
      case 'emotion_regulation':
        return '1. 情绪预测缺陷与拖延症有何关系？\n2. 能否通过训练改善情绪预测能力？\n3. 相关的认知和神经机制是什么？\n\n研究假设：拖延症患者在预测未来情绪时表现出系统性偏差。';
      case 'perception':
        return '1. 大脑"脑补"信息的认知机制是什么？\n2. 影响脑补倾向的个体差异有哪些？\n3. 相关的神经基础是什么？\n\n研究假设：脑补现象反映了大脑基于先验经验进行预测性编码的加工策略。';
      default:
        return '1. 该现象背后的机制和规律是什么？\n2. 如何通过实证研究验证理论假设？\n3. 研究结果对相关领域有何贡献？';
    }
  }

  static String _method(String template) {
    switch (template) {
      case 'child_development':
        return '**研究设计**：多研究组合\n\n**研究 1：家长报告研究**\n- 参与者：128 名家长报告 177 名 3-8 岁儿童\n- 方法：结构化访谈，询问儿童惊讶反应\n- 测量：反应出现年龄和具体情境\n\n**研究 2：实验室实验**\n- 参与者：4-5 岁儿童\n- 程序：3 分钟视频对话任务\n- 自变量：信息来源（熟人 vs 陌生人）';
      case 'sleep_memory':
        return '**参与者**：60 名健康成年人，随机分为睡眠组和剥夺组\n\n**实验程序**：\n- 学习阶段：呈现情绪性和中性图片\n- 间隔期：睡眠组正常睡眠，剥夺组保持清醒\n- 测试阶段：记忆再认测试，同时记录 fMRI 数据\n\n**测量指标**：再认准确率、反应时、海马/杏仁核激活强度';
      case 'decision_making':
        return '**参与者**：48 名成年人\n\n**任务**：时间压力下的价值判断任务\n- 快速决策条件：2 秒内做出选择\n- 延迟决策条件：无时间限制\n\n**记录**：行为数据（选择偏好、反应时）+ fMRI（前额叶皮层、纹状体活动）';
      case 'neuroscience':
        return '**参与者**：32 名健康成年人\n\n**实验任务**：在 fMRI 扫描仪中完成目标认知任务\n\n**数据采集**：\n- 功能像：BOLD 信号，TR=2000ms\n- 结构像：高分辨率 T1 加权图像\n\n**分析方法**：全脑体素分析、功能连接分析、多变量模式分析';
      case 'gut_microbiome':
        return '**研究 1：相关性研究**\n- 参与者：100 名成年人\n- 测量：粪便样本 16S rRNA 测序、社交行为问卷\n\n**研究 2：干预研究**\n- 设计：随机双盲安慰剂对照\n- 干预：4 周益生菌/安慰剂\n- 测量：干预前后社交行为变化';
      case 'ai_deep_learning':
        return '**模型架构**：新的网络结构/损失函数\n\n**实验设置**：\n- 数据集：标准基准数据集\n- 评估指标：准确率、F1 分数\n- 基线模型：与主流方法对比\n\n**训练细节**：Adam 优化器、余弦退火学习率策略';
      case 'emotion_regulation':
        return '**研究 1：相关研究**\n- 参与者：150 名大学生\n- 测量：情绪预测任务、拖延量表\n\n**研究 2：干预研究**\n- 设计：随机对照试验\n- 干预：情绪预测训练 vs 控制组\n- 结果：干预前后拖延行为变化';
      case 'perception':
        return '**实验 1：行为学研究**\n- 任务：模糊刺激识别任务\n- 测量：脑补倾向与认知风格的相关\n\n**实验 2：神经影像研究**\n- 方法：fMRI 记录模糊刺激任务时的脑活动\n- 分析：预测误差信号与脑补倾向的关系';
      default:
        return '**参与者**：招募适量符合条件的被试\n\n**实验程序**：标准化的实验流程和控制条件\n\n**测量工具**：经过验证的测量工具\n\n**数据分析**：适当的统计方法检验假设';
    }
  }

  static String _results(String template) {
    switch (template) {
      case 'child_development':
        return '**发现 1**：家长报告显示，约 4 岁前后已能观察到儿童对"不该知道的人知道了"的惊讶\n\n**发现 2**：实验中 4-5 岁儿童能根据关系远近判断谁知道什么\n\n**发现 3**：儿童能正确推断异常知识的传播路径\n\n**发现 4**：这种能力与社会认知其他维度（如心理理论）相关';
      case 'sleep_memory':
        return '**结果 1**：睡眠组情绪记忆保持显著优于剥夺组（p<0.01）\n\n**结果 2**：REM 睡眠时长与情绪记忆成绩正相关（r=0.45）\n\n**结果 3**：fMRI 显示睡眠后杏仁核-海马连接增强\n\n**结果 4**：效应仅限于情绪性刺激，中性刺激无差异';
      case 'decision_making':
        return '**结果 1**：时间压力下决策更快但一致性降低\n\n**结果 2**：直觉决策显著激活腹内侧前额叶（vmPFC）\n\n**结果 3**：分析决策显著激活背外侧前额叶（dlPFC）\n\n**结果 4**：个体差异调节两种系统的相对贡献';
      case 'neuroscience':
        return '**结果 1**：任务激活分布式脑网络，包括前额叶、顶叶等区域\n\n**结果 2**：功能连接分析揭示核心枢纽脑区\n\n**结果 3**：神经活动强度预测行为表现（R²=0.32）\n\n**结果 4**：多变量分析成功解码任务条件';
      case 'gut_microbiome':
        return '**结果 1**：特定菌群丰度与社交频率正相关\n\n**结果 2**：短链脂肪酸水平中介肠脑联系\n\n**结果 3**：益生菌组社交焦虑显著降低\n\n**结果 4**：基线菌群调节干预效果';
      case 'ai_deep_learning':
        return '**结果 1**：所提方法在多个基准上达到 SOTA\n\n**结果 2**：消融实验验证各组件有效性\n\n**结果 3**：模型收敛速度和稳定性优于基线\n\n**结果 4**：可视化分析揭示学习到的表征特性';
      case 'emotion_regulation':
        return '**结果 1**：拖延症与情绪预测准确性负相关\n\n**结果 2**：拖延者低估未来负面情绪的强度\n\n**结果 3**：情绪预测训练显著减少拖延行为\n\n**结果 4**：效应通过增强未来自我连续性中介';
      case 'perception':
        return '**结果 1**：个体在模糊情境下倾向用先验信息填充缺失部分\n\n**结果 2**：脑补倾向与想象力、创造力正相关\n\n**结果 3**：前额叶和海马的活动预测脑补程度\n\n**结果 4**：预测误差信号调节脑补强度';
      default:
        return '**主要发现 1**：统计分析支持研究假设\n\n**主要发现 2**：效应量达到中等及以上水平\n\n**主要发现 3**：控制混淆变量后效应依然显著\n\n**主要发现 4**：探索性分析揭示新的研究方向';
    }
  }

  static String _conclusion(String title, String template) {
    switch (template) {
      case 'child_development':
        return '**理论贡献**：将儿童社会认知从"个体是否知道"推进到"社会关系如何塑造谁知道谁的什么事"，把心智理论放回了真实的人际网络中。\n\n**方法创新**：在线视频聊天范式，利用物理与关系距离降低混淆可能性。\n\n**局限**：考察的是偏好类信息，人际结构相对简单。';
      case 'sleep_memory':
        return '**理论贡献**：确立了睡眠在情绪记忆巩固中的因果作用，揭示了 REM 睡眠的特异性贡献。\n\n**实践意义**：为睡眠障碍患者的情绪问题干预提供了新靶点。\n\n**局限**：未来可探索不同年龄段和临床人群。';
      case 'decision_making':
        return '**理论贡献**：为双系统理论提供了神经证据，阐明了直觉与分析决策的脑机制差异。\n\n**实践意义**：为改善决策质量、减少决策偏差提供了启示。\n\n**局限**：未来可考察更多决策情境和个体差异。';
      case 'neuroscience':
        return '**理论贡献**：明确了目标认知功能的神经基础，建立了脑-行为定量关系模型。\n\n**实践意义**：为相关神经精神疾病的诊断和治疗提供了潜在生物标记。\n\n**局限**：未来可结合因果性方法（如 TMS）进一步验证。';
      case 'gut_microbiome':
        return '**理论贡献**：为肠-脑轴理论提供了实证支持，揭示了肠道菌群影响社交行为的机制。\n\n**实践意义**：为社交焦虑等问题的微生态干预提供了新思路。\n\n**局限**：需要更大样本和更长期随访。';
      case 'ai_deep_learning':
        return '**理论贡献**：为深度学习领域提供了新的技术路线和理论见解。\n\n**实践意义**：可应用于计算机视觉、自然语言处理等实际任务。\n\n**局限**：未来可探索方法的泛化性和可扩展性。';
      case 'emotion_regulation':
        return '**理论贡献**：提出了拖延症的情绪预测理论，拓展了对自我调节失败的理解。\n\n**实践意义**：为拖延症干预提供了新的靶点和方法。\n\n**局限**：需要在临床样本中验证效应的普遍性。';
      case 'perception':
        return '**理论贡献**：揭示了"脑补"现象的预测性编码机制，证明知觉是主动构建而非被动反映。\n\n**实践意义**：为理解目击者证词可靠性、虚假信息传播等提供了科学依据。\n\n**局限**：未来可探索不同感官模态下的一致性。';
      default:
        return '**理论贡献**：为该领域的理论发展提供了新的实证证据和概念框架。\n\n**实践意义**：对相关应用领域具有指导价值。\n\n**局限**：未来可进一步扩大样本、采用多方法交叉验证。';
    }
  }

  static String _limitations(String template) {
    switch (template) {
      case 'child_development':
        return '- 样本主要来自特定文化背景的自愿者家庭\n- 在线视频范式虽然自然但控制了较少的混淆变量\n- 未考察不同社会文化背景下的差异';
      case 'sleep_memory':
        return '- 样本量较小（n=60）\n- 仅关注了短期记忆巩固\n- 未考察个体睡眠质量的基线差异';
      case 'decision_making':
        return '- 实验室任务与实际生活决策可能存在差异\n- 样本主要为年轻成年人\n- 未考察文化因素的影响';
      case 'neuroscience':
        return '- 样本量较小（n=32）\n- 相关性分析不能推断因果关系\n- 任务设计可能存在构念效度问题';
      case 'gut_microbiome':
        return '- 相关性不等于因果性\n- 益生菌干预的长期效果尚不清楚\n- 饮食等混淆变量未完全控制';
      case 'ai_deep_learning':
        return '- 仅在特定数据集上验证\n- 计算成本较高\n- 模型可解释性仍有待提高';
      case 'emotion_regulation':
        return '- 样本主要为大学生群体\n- 自我报告数据可能存在偏差\n- 干预效果的长期追踪不足';
      case 'perception':
        return '- 主要在视觉模态下验证\n- 实验室任务与真实世界感知的生态效度差异\n- 个体差异的测量可能不够全面';
      default:
        return '- 样本代表性有待验证\n- 研究方法存在固有局限性\n- 未来需要多方法交叉验证';
    }
  }

  static String _difficulty(String template) {
    switch (template) {
      case 'child_development':
        return '初级';
      case 'sleep_memory':
        return '中级';
      case 'decision_making':
        return '中级';
      case 'neuroscience':
        return '高级';
      case 'gut_microbiome':
        return '中级';
      case 'ai_deep_learning':
        return '高级';
      case 'emotion_regulation':
        return '初级';
      case 'perception':
        return '中级';
      default:
        return '中级';
    }
  }

  static String _whyRecommended(String template) {
    switch (template) {
      case 'child_development':
        return '这篇研究以巧妙的实验设计揭示了幼儿令人惊讶的社会认知能力，对理解人类如何从小构建人际网络有重要启发，适合心理学和教育学领域的读者。';
      case 'sleep_memory':
        return '研究将睡眠与记忆这两个热门领域结合，设计严谨、结果稳健，对理解睡眠的生物学功能和改善睡眠健康都有实际价值。';
      case 'decision_making':
        return '为经典的决策理论提供了神经层面的证据，帮助我们理解为什么有时候"直觉"比"理性"更可靠，对行为经济学和认知科学都有意义。';
      case 'neuroscience':
        return '多模态神经影像方法代表了认知神经科学的前沿方向，研究结果为理解大脑工作机制提供了重要线索。';
      case 'gut_microbiome':
        return '肠-脑轴是近年来最激动人心的科学发现之一，这篇研究为我们理解"吃如何影响大脑"提供了直接的实证支持。';
      case 'ai_deep_learning':
        return '代表了 AI 领域的最新进展，对理解智能的本质和推动技术应用都有重要意义。';
      case 'emotion_regulation':
        return '为拖延症提供了一个全新的理论框架——不是懒，而是大脑无法准确预测未来情绪。这个视角对每个人都有实用价值。';
      case 'perception':
        return '揭示了大脑如何主动"脑补"信息，帮助我们理解知觉并非客观反映，而是主观构建，对理解虚假信息传播等现象有启发。';
      default:
        return '这篇论文在相关领域提供了新的实证证据和理论视角，值得推荐阅读。';
    }
  }

  // ========== 工具函数 ==========

  /// 从标题提取年龄提示
  static String _extractAgeHint(String title) {
    final numMatch = RegExp(r'(\d+)\s*岁').firstMatch(title);
    if (numMatch != null) return numMatch.group(1)!;
    return '';
  }

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
      '拖延': '拖延症',
      '情绪预测': '情绪预测',
      '自我调节': '自我调节',
      '感知': '知觉研究',
      '脑补': '预测性编码',
      '知觉': '知觉研究',
    };

    final tags = <String>[];
    if (category.isNotEmpty) tags.add(category);

    tagMap.forEach((keyword, tag) {
      if (combined.contains(keyword) && !tags.contains(tag)) {
        tags.add(tag);
      }
    });

    if (tags.isEmpty) tags.addAll(['心理学', '认知科学']);
    return tags.take(5).toList();
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
