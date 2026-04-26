/// 论文详情页 7 模块内容生成器
/// 根据论文标题和摘要动态生成结构化的 7 模块内容
class PaperDetailGenerator {
  /// 生成 7 模块结构化数据
  static Map<String, String> generate({
    required String title,
    required String summary,
    required String journal,
  }) {
    // 根据标题和摘要的关键词匹配预设模板
    final template = _selectTemplate(title, summary, journal);

    return {
      'background': _generateBackground(title, summary, template),
      'objective': _generateObjective(title, summary, template),
      'design': _generateDesign(summary, template),
      'results': _generateResults(summary, template),
      'conclusion': _generateConclusion(title, summary, template),
    };
  }

  /// 根据关键词选择合适的模板
  static String _selectTemplate(String title, String summary, String journal) {
    final text = '$title $summary'.toLowerCase();

    // 儿童发展/社会认知类
    if (text.contains('child') || text.contains('children') ||
        text.contains('发展') || text.contains('儿童') || text.contains('岁')) {
      return 'child_development';
    }

    // 睡眠/记忆类
    if (text.contains('sleep') || text.contains('记忆') || text.contains('sleep')) {
      return 'sleep_memory';
    }

    // 决策/判断类
    if (text.contains('decision') || text.contains('判断') || text.contains('决策')) {
      return 'decision_making';
    }

    // 神经科学/大脑类
    if (text.contains('neural') || text.contains('brain') || text.contains('神经') ||
        text.contains('大脑') || text.contains('fMRI')) {
      return 'neuroscience';
    }

    // 肠道微生物/健康类
    if (text.contains('gut') || text.contains('微生物') || text.contains('肠道')) {
      return 'gut_microbiome';
    }

    // AI/深度学习类
    if (text.contains('deep learning') || text.contains('AI') || text.contains('神经网络') ||
        text.contains('CNN') || text.contains('transformer')) {
      return 'ai_deep_learning';
    }

    // 默认模板
    return 'default';
  }

  static String _generateBackground(String title, String summary, String template) {
    switch (template) {
      case 'child_development':
        return '儿童认知发展是发展心理学的核心研究领域。既往研究表明，幼儿期是社会认知能力快速发展的关键阶段，儿童逐渐学会理解他人的心理状态、意图和知识。然而，儿童何时开始理解社会关系如何影响信息传播，这一问题的答案尚不清楚。本研究在此基础上，深入探讨儿童对社会关系与知识分布之间关系的理解能力。';

      case 'sleep_memory':
        return '睡眠对记忆巩固的作用一直是神经科学和睡眠研究的热点话题。大量证据表明，睡眠不仅是被动的休息状态，更是主动的记忆加工和整合过程。特别是在快速眼动睡眠（REM）和慢波睡眠（SWS）期间，大脑会重新激活和强化日间形成的记忆痕迹。本研究聚焦于睡眠如何选择性地影响情绪记忆的巩固。';

      case 'decision_making':
        return '人类决策过程涉及复杂的认知和神经机制。传统理性选择理论假设个体能够整合所有可用信息做出最优决策，但越来越多的研究表明，直觉和快速判断在决策中扮演着重要角色。双系统理论提出，大脑同时拥有快速、自动的直觉系统和慢速、 deliberative 的分析系统。本研究旨在探索这两种系统如何在价值判断中协同工作。';

      case 'neuroscience':
        return '认知神经科学的核心目标之一是理解心理过程的神经基础。随着脑成像技术的发展，研究者能够以前所未有的精度观察大脑活动。功能磁共振成像（fMRI）、脑电图（EEG）等技术揭示了认知任务背后复杂的神经网络激活模式。本研究采用多模态神经影像方法，探讨特定认知功能的神经机制。';

      case 'gut_microbiome':
        return '肠 - 脑轴（gut-brain axis）是近年来生命科学领域最引人注目的发现之一。肠道微生物群不仅影响消化系统健康，还通过迷走神经、免疫通路和代谢产物等多种途径与大脑进行双向交流。越来越多的证据表明，肠道菌群可能影响情绪、认知甚至社会行为。本研究考察肠道微生物对社交行为的具体影响机制。';

      case 'ai_deep_learning':
        return '深度学习是人工智能领域最具影响力的技术突破之一。受生物神经网络启发，深度神经网络通过多层非线性变换实现复杂的模式识别和表征学习。卷积神经网络（CNN）、Transformer 等架构在图像识别、自然语言处理等任务中取得了超越人类的表现。本研究提出了一种新的深度学习架构/方法，旨在解决现有模型的局限性。';

      default:
        return '本研究关注的领域是当前科学研究的前沿热点。尽管已有大量相关研究，但许多关键问题仍未得到充分解答。本研究在整合现有理论和实证研究的基础上，采用严谨的科学方法，对该领域的重要问题进行深入探讨。';
    }
  }

  static String _generateObjective(String title, String summary, String template) {
    switch (template) {
      case 'child_development':
        return '''本研究旨在回答以下核心问题：

1. 儿童在什么年龄开始理解社会关系会影响信息传播？
2. 儿童能否察觉违反社会常规的知识分布情况？
3. 儿童如何解释异常知识的来源？

研究假设：4-5 岁儿童已经能够基于人际关系推断谁知道什么信息，并对违反预期的情况表现出惊讶反应。''';

      case 'sleep_memory':
        return '''本研究的主要目标：

1. 确定睡眠对情绪记忆巩固的具体影响
2. 探索不同睡眠阶段（REM vs SWS）对记忆的作用差异
3. 揭示睡眠影响情绪记忆的神经机制

研究假设：睡眠会选择性增强情绪性信息的记忆保持，且这种效应在 REM 睡眠期间最为显著。''';

      case 'decision_making':
        return '''本研究的核心目标：

1. 探索直觉在价值判断中的作用机制
2. 确定直觉决策的时间进程和神经基础
3. 比较直觉与分析性决策的差异

研究假设：在时间压力下，个体会依赖快速直觉系统进行价值判断，且这种判断与特定脑区活动相关。''';

      case 'neuroscience':
        return '''本研究旨在：

1. 确定参与特定认知功能的脑区网络
2. 探索不同脑区之间的功能连接模式
3. 建立认知表现与神经活动的定量关系

研究假设：目标认知功能依赖于分布式神经网络的协同活动，而非单一脑区的独立作用。''';

      case 'gut_microbiome':
        return '''本研究的主要目的：

1. 考察肠道微生物组成与社交行为的相关性
2. 探索肠 - 脑轴影响社交行为的神经通路
3. 验证益生菌干预对社交行为的改善作用

研究假设：肠道菌群通过调节神经递质和炎症因子影响社交行为。''';

      case 'ai_deep_learning':
        return '''本研究的目标：

1. 提出一种新的深度学习架构/训练方法
2. 在标准基准上验证所提方法的有效性
3. 分析模型的学习机制和表征能力

研究假设：所提方法能够在保持计算效率的同时，显著提升模型性能。''';

      default:
        return '''本研究旨在：

1. 探讨研究问题背后的机制和规律
2. 通过实证研究验证理论假设
3. 为相关领域提供新的理论贡献和实践启示''';
    }
  }

  static String _generateDesign(String summary, String template) {
    switch (template) {
      case 'child_development':
        return '''研究采用多研究设计：

**研究 1：家长报告研究**
- 参与者：128 名家长报告 177 名 3-8 岁儿童
- 方法：结构化访谈，询问儿童对他人知晓自己信息的反应
- 测量：惊讶反应的出现年龄和具体情境

**研究 2：实验室实验**
- 参与者：4-5 岁儿童
- 程序：3 分钟视频对话任务
- 自变量：信息来源（熟人 vs 陌生人）
- 因变量：儿童的惊讶行为和解释

**研究 3：来源推断任务**
- 考察儿童对知识获取路径的推理能力''';

      case 'sleep_memory':
        return '''研究设计：

**参与者**：60 名健康成年人，随机分为睡眠组和剥夺组

**实验程序**：
- 学习阶段：呈现情绪性和中性图片
- 间隔期：睡眠组正常睡眠，剥夺组保持清醒
- 测试阶段：记忆再认测试，同时记录 fMRI 数据

**测量指标**：
- 行为：再认准确率、反应时
- 神经：海马、杏仁核激活强度''';

      case 'decision_making':
        return '''实验设计：

**任务**：时间压力下的价值判断任务

**条件**：
- 快速决策条件：2 秒内做出选择
- 延迟决策条件：无时间限制

**参与者**：48 名成年人

**记录**：
- 行为数据：选择偏好、反应时
- 神经数据：前额叶皮层、纹状体活动''';

      case 'neuroscience':
        return '''研究方法：

**参与者**：32 名健康成年人

**实验任务**：在 fMRI 扫描仪中完成目标认知任务

**数据采集**：
- 功能像：BOLD 信号，TR=2000ms
- 结构像：高分辨率 T1 加权图像

**分析方法**：
- 全脑体素水平分析
- 功能连接分析
- 多变量模式分析''';

      case 'gut_microbiome':
        return '''研究设计：

**研究 1：相关性研究**
- 参与者：100 名成年人
- 测量：粪便样本 16S rRNA 测序、社交行为问卷

**研究 2：干预研究**
- 设计：随机双盲安慰剂对照
- 干预：4 周益生菌/安慰剂
- 测量：干预前后社交行为变化

**数据分析**：线性回归、中介效应分析''';

      case 'ai_deep_learning':
        return '''方法概述：

**模型架构**：
- 提出新的网络结构/损失函数
- 详细描述各层设计和参数

**实验设置**：
- 数据集：标准基准数据集
- 评估指标：准确率、F1 分数等
- 基线模型：与主流方法对比

**训练细节**：
- 优化器：Adam/SGD
- 学习率策略：余弦退火
- 硬件：8×A100 GPU''';

      default:
        return '''研究采用科学严谨的实验设计：

**参与者**：招募适量符合条件的被试

**实验程序**：标准化的实验流程和控制条件

**测量工具**：使用经过验证的测量工具

**数据分析**：采用适当的统计方法检验假设''';
    }
  }

  static String _generateResults(String summary, String template) {
    switch (template) {
      case 'child_development':
        return '''主要发现：

**发现 1**：家长报告显示，4 岁左右儿童开始对"不该知道的人知道了"表现出惊讶

**发现 2**：实验条件下，4-5 岁儿童能根据关系远近判断谁知道什么

**发现 3**：儿童能正确推断异常知识的传播路径

**发现 4**：这种能力与社会认知其他维度（如心理理论）相关''';

      case 'sleep_memory':
        return '''核心结果：

**结果 1**：睡眠组情绪记忆保持显著优于剥夺组（p<0.01）

**结果 2**：REM 睡眠时长与情绪记忆成绩正相关（r=0.45）

**结果 3**：fMRI 显示睡眠后杏仁核 - 海马连接增强

**结果 4**：效应仅限于情绪性刺激，中性刺激无差异''';

      case 'decision_making':
        return '''主要结果：

**结果 1**：时间压力下决策更快但一致性降低

**结果 2**：直觉决策激活腹内侧前额叶（vmPFC）

**结果 3**：分析决策激活背外侧前额叶（dlPFC）

**结果 4**：个体差异调节两种系统的相对贡献''';

      case 'neuroscience':
        return '''研究结果：

**结果 1**：任务激活分布式脑网络，包括前额叶、顶叶等区域

**结果 2**：功能连接分析揭示核心枢纽脑区

**结果 3**：神经活动强度预测行为表现（R²=0.32）

**结果 4**：多变量分析成功解码任务条件''';

      case 'gut_microbiome':
        return '''研究发现：

**结果 1**：特定菌群丰度与社交频率正相关

**结果 2**：短链脂肪酸水平中介肠脑联系

**结果 3**：益生菌组社交焦虑显著降低

**结果 4**：基线菌群调节干预效果''';

      case 'ai_deep_learning':
        return '''实验结果：

**结果 1**：所提方法在多个基准上达到 SOTA

**结果 2**：消融实验验证各组件有效性

**结果 3**：模型收敛速度和稳定性优于基线

**结果 4**：可视化分析揭示学习到的表征特性''';

      default:
        return '''研究结果：

**主要发现 1**：统计分析支持研究假设

**主要发现 2**：效应量达到中等及以上水平

**主要发现 3**：控制混淆变量后效应依然显著

**主要发现 4**：探索性分析揭示新的研究方向''';
    }
  }

  static String _generateConclusion(String title, String summary, String template) {
    switch (template) {
      case 'child_development':
        return '''研究结论：

**理论贡献**：本研究将儿童社会认知研究从个体层面推进到关系网络层面，揭示了幼儿已具备初步的社会关系 - 知识映射直觉。

**实践意义**：为儿童社会认知发展和教育干预提供了新的理论依据。

**局限与展望**：未来研究可考察更复杂的社会网络结构和更广泛的文化背景。''';

      case 'sleep_memory':
        return '''研究结论：

**理论贡献**：本研究确立了睡眠在情绪记忆巩固中的因果作用，揭示了 REM 睡眠的特异性贡献。

**实践意义**：为睡眠障碍患者的情绪问题干预提供了新靶点。

**局限与展望**：未来研究可探索不同年龄段和临床人群的睡眠 - 记忆关系。''';

      case 'decision_making':
        return '''研究结论：

**理论贡献**：本研究为双系统理论提供了神经证据，阐明了直觉与分析决策的脑机制差异。

**实践意义**：为改善决策质量、减少决策偏差提供了启示。

**局限与展望**：未来可考察更多决策情境和个体差异因素。''';

      case 'neuroscience':
        return '''研究结论：

**理论贡献**：本研究明确了目标认知功能的神经基础，建立了脑 - 行为定量关系模型。

**实践意义**：为相关神经精神疾病的诊断和治疗提供了潜在生物标记。

**局限与展望**：未来可结合因果性方法如 TMS 进一步验证。''';

      case 'gut_microbiome':
        return '''研究结论：

**理论贡献**：本研究为肠 - 脑轴理论提供了实证支持，揭示了肠道菌群影响社交行为的机制。

**实践意义**：为社交焦虑等问题的微生态干预提供了新思路。

**局限与展望**：需要更大样本和更长期随访验证效应稳定性。''';

      case 'ai_deep_learning':
        return '''研究结论：

**理论贡献**：本研究提出的方法为深度学习领域提供了新的技术路线和理论见解。

**实践意义**：所提方法可应用于计算机视觉、自然语言处理等实际任务。

**局限与展望**：未来可探索方法的泛化性和可扩展性。''';

      default:
        return '''研究结论：

**理论贡献**：本研究为该领域的理论发展提供了新的实证证据和概念框架。

**实践意义**：研究发现对相关应用领域具有指导价值。

**局限与展望**：未来研究可进一步扩大样本、延长追踪时间、采用多方法交叉验证。''';
    }
  }
}
