import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// 通义万相 API 服务类
/// 文档：https://help.aliyun.com/zh/dashscope/developer-reference/wanx-v2-1-api
class TongyiImageService {
  final String apiKey;
  // 通义万相 API - 使用异步任务模式
  final String submitUrl = 'https://dashscope.aliyuncs.com/api/v1/services/aigc/text2image/image-synthesis';
  final String taskUrl = 'https://dashscope.aliyuncs.com/api/v1/tasks/';

  TongyiImageService({required this.apiKey});

  /// 根据论文信息生成封面图片
  Future<String?> generateCoverImage({
    required String paperTitle,
    required String journal,
    String? abstract,
    required String savePath,
  }) async {
    try {
      // 生成 Prompt
      final prompt = _buildPrompt(
        title: paperTitle,
        journal: journal,
        abstract: abstract,
      );

      print('📝 生成 Prompt: $prompt');

      // 调用 API
      final imageUrl = await _callTongyiAPI(prompt);

      if (imageUrl == null) {
        print('❌ API 调用失败，将尝试备用模型');
        return null;
      }

      print('✅ 图片生成成功：$imageUrl');

      // 下载并保存图片
      await _downloadAndSaveImage(imageUrl, savePath);

      print('💾 图片已保存到：$savePath');
      return savePath;
    } catch (e) {
      print('❌ 生成图片时出错：$e');
      return null;
    }
  }

  /// 构建生图 Prompt
  String _buildPrompt({
    required String title,
    required String journal,
    String? abstract,
  }) {
    // 从标题和摘要提取语义元素
    final semanticElements = _extractSemanticElements(title, abstract);

    // 根据期刊确定视觉风格
    final visualStyle = _getVisualStyle(journal);

    // 构建有语义的 Prompt
    return '''
学术封面设计，{style}

核心视觉元素：{elements}

设计原则：
- 极简主义构图，突出主题
- 专业学术风格，适合科学传播
- 清晰背景，高对比度
- 16:9 宽屏比例，留白空间添加文字
- 高分辨率，适合移动端展示
''';
  }

  /// 从标题和摘要提取语义元素
  String _extractSemanticElements(String title, String? abstract) {
    final text = '$title ${abstract ?? ''}'.toLowerCase();

    // 定义语义映射 - 更具体的视觉元素
    final semanticMap = {
      // 神经科学相关
      'neural': '神经网络可视化、神经元细胞、突触连接、树突轴突',
      'neuron': '神经元、大脑皮层、神经回路、电脉冲信号',
      'brain': '人类大脑解剖图、脑区功能定位、fMRI 脑成像扫描',
      'cortex': '大脑皮层分层结构、脑沟回、功能区定位图',

      // 人工智能/机器学习
      'deep learning': '深度学习神经网络架构图、多层感知器可视化、反向传播算法图',
      'machine learning': '机器学习算法流程图、决策树模型、数据聚类分析图',
      'artificial intelligence': 'AI 人工智能芯片、机器人、神经网络架构',
      'network': '复杂网络拓扑图、节点连接关系、图论网络结构',
      'polynomial': '多项式函数 3D 曲面图、数学拟合曲线、参数空间可视化',
      'chaos': '混沌吸引子相图、分形几何图案、蝴蝶效应可视化',
      'arbitrary': '任意多项式基函数展开、广义函数逼近、数学建模',

      // 数据分析
      'population': '人群统计数据分布、人口结构金字塔、频率直方图',
      'coding': '计算机代码、编程算法、伪代码流程',
      'software': '科学计算软件界面、工具箱面板、模块化架构',
      'open source': '开源协作网络、GitHub 代码仓库、分布式开发',
      'data': '科学数据可视化、多维数据散点图、热力图矩阵',
      'analysis': '统计分析图表、回归分析模型、假设检验示意图',
      'quantifying': '量化分析指标、测量标尺、精确度评估',
      'uncertainty': '不确定性量化、误差棒、置信区间 shaded area',

      // 认知科学
      'cognitive': '认知加工流程图、心理表征模型、心智思维导图',
      'memory': '记忆存储提取模型、工作记忆缓冲、长时记忆巩固',
      'attention': '注意力资源分配、选择性注意焦点、眼动追踪实验',
      'perception': '感觉知觉机制、视觉听觉通路、多感官整合',
      'decision': '决策制定过程、风险收益权衡、选择偏好树',
      'learning': '学习获得曲线、技能习得过程、知识建构',

      // 生物医学
      'gene': 'DNA 双螺旋结构、基因表达测序、染色体核型分析',
      'protein': '蛋白质三维折叠结构、酶催化活性位点、分子对接',
      'cell': '真核细胞超微结构、细胞器功能分区、细胞分裂周期',
      'molecule': '生物大分子复合物、化学键相互作用、药物靶点',
      'drug': '新药研发流程、药物代谢动力学、临床试验设计',
      'disease': '疾病病理机制、生物标志物、诊断治疗方案',
      'patient': '临床病例研究、患者队列分析、个性化医疗',

      // 物理/工程
      'quantum': '量子力学现象、叠加态纠缠态、波函数概率云',
      'particle': '亚原子粒子轨迹、高能物理对撞、探测器阵列',
      'signal': '生物医学信号处理、时频分析谱图、滤波器设计',
      'image': '医学影像重建、计算机视觉算法、图像分割配准',
      'robot': '智能机器人系统、机械臂运动规划、人机交互',
      'engineering': '工程设计优化、有限元分析、系统仿真',

      // 社会科学
      'social': '社交网络分析、人际互动关系、群体动力学',
      'behavior': '动物人类行为观测、行为范式实验、运动轨迹追踪',
      'economy': '宏观经济指标、市场供需模型、金融时间序列',
      'education': '教育教学场景、学习成果评估、课程设计',
      'child': '儿童发展里程碑、成长轨迹追踪、早期干预',
      'aging': '老龄化社会、寿命延长曲线、老年健康指标',

      // 计算神经科学专用
      'simulate': '计算机模拟仿真、数值计算算法、并行计算架构',
      'large-scale': '大规模并行计算、超级计算机集群、分布式系统',
      'circuit': '神经回路连接组、突触可塑性回路、振荡同步',
      'dynamics': '动力系统相空间、时间演化轨迹、稳定性分析',
      'activity': '神经元群体活动、发放率编码、局部场电位',
    };

    final matched = <String>[];
    for (var entry in semanticMap.entries) {
      if (text.contains(entry.key)) {
        matched.add(entry.value);
      }
    }

    if (matched.isNotEmpty) {
      return matched.take(5).join('、');
    }

    // 默认返回通用科学元素
    return '科学研究实验场景、精密仪器装置、学术论文图表、数据可视化';
  }

  /// 根据期刊确定视觉风格
  String _getVisualStyle(String journal) {
    final lowerJournal = journal.toLowerCase();

    // 顶级期刊特定配色
    if (lowerJournal.contains('nature')) return 'Nature 风格：橙红色渐变、高端学术质感、烫金边框';
    if (lowerJournal.contains('science')) return 'Science 风格：深蓝色调、严谨专业、银色装饰';
    if (lowerJournal.contains('cell')) return 'Cell 风格：紫色神秘、生命科学质感、荧光效果';
    if (lowerJournal.contains('pnas')) return 'PNAS 风格：紫罗兰色、权威学术、几何图案';
    if (lowerJournal.contains('elife')) return 'eLife 风格：青蓝色渐变、开放科学、现代简约';
    if (lowerJournal.contains('neuron')) return 'Neuron 风格：蓝紫神经色调、突触连接背景';
    if (lowerJournal.contains('psych')) return '心理学风格：柔和粉蓝、温暖治愈';

    // 学科风格
    if (lowerJournal.contains('neuro')) return '神经科学风格：脑区成像色调、电生理波形';
    if (lowerJournal.contains('bio')) return '生物学风格：自然绿色、生命质感';
    if (lowerJournal.contains('phys')) return '物理学风格：深邃蓝紫、粒子轨迹';
    if (lowerJournal.contains('chem')) return '化学风格：分子结构背景、键合图案';
    if (lowerJournal.contains('med')) return '医学风格：临床蓝、X 光片质感';
    if (lowerJournal.contains('tech') || lowerJournal.contains('cs')) return '科技风格：赛博蓝、数字化网格';

    // 默认风格
    return '现代学术风格：蓝紫渐变、简洁专业、几何装饰';
  }

  /// 调用通义万相 API (使用 wanx-v1 模型)
  Future<String?> _callTongyiAPI(String prompt) async {
    try {
      print('🔗 请求 API: $submitUrl');
      print('🔑 API Key: ${apiKey.substring(0, 8)}...');

      // 通义万相 wanx-v1 的正确格式
      final requestBody = jsonEncode({
        'model': 'wanx-v1',
        'input': {
          'prompt': prompt,
        },
        'parameters': {
          'size': '1024*1024',
          'style': '<auto>',
        },
      });

      print('📤 请求体：$requestBody');

      // 提交任务
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'X-DashScope-Async': 'enable',
        },
        body: requestBody,
      );

      print('📥 提交响应状态码：${response.statusCode}');
      print('📄 提交响应内容：${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final taskId = data['output']?['task_id'] as String?;

        if (taskId == null) {
          print('❌ 未获取到 task_id');
          return null;
        }

        print('✅ 任务提交成功，Task ID: $taskId');
        print('⏳ 等待图片生成...');

        // 轮询任务状态
        for (var i = 0; i < 30; i++) {
          await Future.delayed(const Duration(seconds: 2));

          final taskResponse = await http.get(
            Uri.parse('$taskUrl$taskId'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );

          if (taskResponse.statusCode == 200) {
            final taskData = jsonDecode(taskResponse.body);
            final taskStatus = taskData['output']?['task_status'] as String?;

            print('📊 任务状态：$taskStatus');

            if (taskStatus == 'SUCCEEDED') {
              final result = taskData['output']?['results'];
              if (result != null && (result as List).isNotEmpty) {
                final imageUrl = result[0]['url'] as String?;
                print('✅ 图片生成成功：$imageUrl');
                return imageUrl;
              }
            } else if (taskStatus == 'FAILED') {
              print('❌ 任务失败：${taskData['output']?['message']}');
              return null;
            }
          }
        }

        print('⏰ 等待超时');
        return null;
      } else {
        print('❌ HTTP 错误：${response.statusCode}');
        print('响应内容：${response.body}');
      }

      return null;
    } catch (e) {
      print('❌ API 调用异常：$e');
      return null;
    }
  }

  /// 下载并保存图片
  Future<void> _downloadAndSaveImage(String url, String savePath) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 确保目录存在
        final directory = Directory(savePath).parent;
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // 保存图片
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        throw Exception('下载图片失败：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('保存图片时出错：$e');
    }
  }

  /// 批量生成封面（用于初始化）
  Future<Map<String, String>> batchGenerateCovers({
    required List<Map<String, dynamic>> papers,
    required String outputDir,
  }) async {
    final results = <String, String>{};

    for (var paper in papers) {
      final paperId = paper['id'] as String;
      final title = paper['title'] as String;
      final journal = paper['journal'] as String;
      final abstract = paper['abstract'] as String?;

      final savePath = '$outputDir/cover_$paperId.png';

      print('🔄 正在生成论文 $paperId 的封面...');

      final result = await generateCoverImage(
        paperTitle: title,
        journal: journal,
        abstract: abstract,
        savePath: savePath,
      );

      if (result != null) {
        results[paperId] = 'assets/paper_images/cover_$paperId.png';
        // 等待一下，避免请求过快
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return results;
  }
}

/// 使用示例
void main() async {
  // 从环境变量或配置文件读取 API Key
  const apiKey = 'YOUR_API_KEY_HERE'; // 替换为你的 API Key

  final service = TongyiImageService(apiKey: apiKey);

  // 单篇生成示例
  await service.generateCoverImage(
    paperTitle: 'Representational geometries reveal differential effects of response correlations',
    journal: 'eLife',
    abstract: 'This study examines how neural population codes differ between neurophysiology and fMRI...',
    savePath: 'assets/paper_images/cover_example.png',
  );

  // 批量生成示例
  final papers = [
    {
      'id': '1',
      'title': 'PNAS | 4 岁孩子已经会判断"谁本来就该知道我的事"了',
      'journal': 'PNAS',
      'abstract': '儿童社会认知发展研究...',
    },
    // ... 更多论文
  ];

  final results = await service.batchGenerateCovers(
    papers: papers,
    outputDir: 'assets/paper_images',
  );

  print('生成结果：$results');
}
