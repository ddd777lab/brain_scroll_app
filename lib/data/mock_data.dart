class MockData {
  // 订阅的作者列表（用于测试订阅功能）
  static final Set<String> subscribedAuthors = {};

  // 7 模块详细内容数据
  static final Map<String, Map<String, String>> paperDetails = {
    '1': {
      'background': '''日常社交里，有一条很少被明说、却几乎人人都在默认使用的规则：越亲近的人，越可能知道你的"圈内信息（insider knowledge）"。比如，妈妈知道你最喜欢吃什么，通常不奇怪；但如果一个几乎不认识的人准确说出你最爱的电影，这种感觉就会立刻变得不对劲，甚至让人有些不安。

这类判断看似琐碎，其实是很多社会行为的底层机制。我们如何沟通、如何判断亲疏、如何管理声誉、如何理解八卦为什么会传播，背后都离不开对"谁知道谁的什么事"的快速推断。问题在于，儿童什么时候开始具备这种能力？''',
      'objective': '''本研究旨在回答以下核心问题：

1. 儿童在什么年龄开始理解社会关系会影响信息传播？
2. 儿童能否察觉违反社会常规的知识分布情况？
3. 儿童能否解释异常知识的来源路径？

研究假设：4-5 岁儿童已经能够基于社会关系推断谁知道什么信息，并对违反这一规律的情况表现出惊讶。''',
      'design': '''整篇论文由三个相互衔接的研究组成：

**Study 1：家长报告研究**
- 参与者：128 名家长，报告 177 名 3-8 岁儿童情况
- 方法：家长报告孩子是否曾对他人知道自己的信息感到惊讶
- 测量：估计反应最早出现的年龄，描述具体事件

**Study 2：实时视频对话实验**
- 参与者：4-5 岁儿童
- 程序：约 3 分钟 Zoom 对话，实验者自然提起孩子偏好
- 条件：信息来源为"孩子的妈妈"vs"实验者的妈妈"
- 测量：儿童的惊讶反应

**Study 3：知识来源推断**
- 框架：沿用 Study 2 对话框架
- 问题："你觉得她是怎么知道的"
- 编码：第一手解释、第二手解释、不确定''',
      'results': '''**发现一**：家长报告显示，儿童对"不太该知道的人却知道自己信息"的惊讶，在约 4 岁前后已能观察到。

**发现二**：在实时视频对话中，4-5 岁儿童会依据关系判断谁更可能知道自己的偏好，并在不匹配时表现出惊讶。

**发现三**：儿童并不是简单地认为"自己的妈妈最懂自己"，因为当知识对象换成他人时，他们会把预期整体反转。

**发现四**：儿童不仅能察觉异常知识分布，还能生成与关系相匹配的知识获取路径解释。''',
      'conclusion': '''**理论贡献**：这篇研究最有价值的地方，在于它把儿童社会认知的问题从经典的"个体是否知道某件事"，推进到了"社会关系如何塑造谁知道谁的什么事"。这不是简单增加一个任务难度，而是把儿童心智理论放回了真实的人际网络中去理解。

**方法创新**：采用在线视频聊天这一半自然化范式，既保留了儿童熟悉的交流形式，又利用视频聊天天然的物理与关系距离，降低了混淆可能性。

**研究局限**：研究考察的是偏好类"圈内信息"，而非更敏感的私人信息；考察的人际结构相对简单。''',
    },
    '2': {
      'background': '''睡眠对记忆巩固的作用一直是神经科学和睡眠研究的热点话题。大量证据表明，睡眠不仅是被动的休息状态，更是主动的记忆加工和整合过程。特别是在快速眼动睡眠（REM）和慢波睡眠（SWS）期间，大脑会重新激活和强化日间形成的记忆痕迹。

情绪记忆由于其生存适应性价值，往往比普通记忆更加牢固。然而，睡眠如何选择性地影响情绪记忆的巩固？这一过程涉及哪些神经机制？''',
      'objective': '''本研究的主要目标：

1. 确定睡眠对情绪记忆巩固的具体影响
2. 探索不同睡眠阶段（REM vs SWS）对记忆的作用差异
3. 揭示睡眠影响情绪记忆的神经机制

研究假设：睡眠会选择性增强情绪性信息的记忆保持，且这种效应在 REM 睡眠期间最为显著。''',
      'design': '''**参与者**：60 名健康成年人，随机分为睡眠组和剥夺组

**实验程序**：
- 学习阶段：呈现情绪性和中性图片
- 间隔期：睡眠组正常睡眠，剥夺组保持清醒
- 测试阶段：记忆再认测试，同时记录 fMRI 数据

**测量指标**：
- 行为：再认准确率、反应时
- 神经：海马、杏仁核激活强度''',
      'results': '''**结果 1**：睡眠组情绪记忆保持显著优于剥夺组（p<0.01）

**结果 2**：REM 睡眠时长与情绪记忆成绩正相关（r=0.45）

**结果 3**：fMRI 显示睡眠后杏仁核 - 海马连接增强

**结果 4**：效应仅限于情绪性刺激，中性刺激无差异''',
      'conclusion': '''**理论贡献**：本研究确立了睡眠在情绪记忆巩固中的因果作用，揭示了 REM 睡眠的特异性贡献。

**实践意义**：为睡眠障碍患者的情绪问题干预提供了新靶点。

**局限与展望**：未来研究可探索不同年龄段和临床人群的睡眠 - 记忆关系。''',
    },
    '3': {
      'background': '''人类决策过程涉及复杂的认知和神经机制。传统理性选择理论假设个体能够整合所有可用信息做出最优决策，但越来越多的研究表明，直觉和快速判断在决策中扮演着重要角色。

双系统理论提出，大脑同时拥有快速、自动的直觉系统和慢速、分析性的分析系统。然而，这两种系统如何在价值判断中协同工作？''',
      'objective': '''本研究的核心目标：

1. 探索直觉在价值判断中的作用机制
2. 确定直觉决策的时间进程和神经基础
3. 比较直觉与分析性决策的差异

研究假设：在时间压力下，个体会依赖快速直觉系统进行价值判断，且这种判断与腹内侧前额叶（vmPFC）活动相关。''',
      'design': '''**任务**：时间压力下的价值判断任务

**条件**：
- 快速决策条件：2 秒内做出选择
- 延迟决策条件：无时间限制

**参与者**：48 名成年人

**记录**：
- 行为数据：选择偏好、反应时
- 神经数据：fMRI 记录前额叶皮层、纹状体活动''',
      'results': '''**结果 1**：时间压力下决策更快但一致性降低

**结果 2**：直觉决策显著激活腹内侧前额叶（vmPFC）

**结果 3**：分析决策显著激活背外侧前额叶（dlPFC）

**结果 4**：个体差异调节两种系统的相对贡献''',
      'conclusion': '''**理论贡献**：本研究为双系统理论提供了神经证据，阐明了直觉与分析决策的脑机制差异。

**实践意义**：为改善决策质量、减少决策偏差提供了启示。

**局限与展望**：未来可考察更多决策情境和个体差异因素。''',
    },
    '4': {
      'background': '''肠 - 脑轴（gut-brain axis）是近年来生命科学领域最引人注目的发现之一。肠道微生物群不仅影响消化系统健康，还通过迷走神经、免疫通路和代谢产物等多种途径与大脑进行双向交流。

越来越多的证据表明，肠道菌群可能影响情绪、认知甚至社会行为。然而，具体的影响机制尚不清楚。''',
      'objective': '''本研究的主要目的：

1. 考察肠道微生物组成与社交行为的相关性
2. 探索肠 - 脑轴影响社交行为的神经通路
3. 验证益生菌干预对社交行为的改善作用

研究假设：肠道菌群通过调节神经递质和炎症因子影响社交行为。''',
      'design': '''**研究 1：相关性研究**
- 参与者：100 名成年人
- 测量：粪便样本 16S rRNA 测序、社交行为问卷

**研究 2：干预研究**
- 设计：随机双盲安慰剂对照
- 干预：4 周益生菌/安慰剂
- 测量：干预前后社交行为变化

**数据分析**：线性回归、中介效应分析''',
      'results': '''**结果 1**：特定菌群丰度与社交频率正相关

**结果 2**：短链脂肪酸水平中介肠脑联系

**结果 3**：益生菌组社交焦虑显著降低

**结果 4**：基线菌群调节干预效果''',
      'conclusion': '''**理论贡献**：本研究为肠 - 脑轴理论提供了实证支持，揭示了肠道菌群影响社交行为的机制。

**实践意义**：为社交焦虑等问题的微生态干预提供了新思路。

**局限与展望**：需要更大样本和更长期随访验证效应稳定性。''',
    },
    '5': {
      'background': '''人类的知觉系统并非被动地反映外部世界，而是主动地构建和解释感官信息。在某些情况下，大脑会"脑补"出实际上不存在的信息，这种现象在视觉错觉、记忆扭曲等方面广泛存在。

为什么会产生这种"脑补"现象？这反映了大脑信息加工的什么特点？''',
      'objective': '''本研究旨在：

1. 探索大脑"脑补"信息的认知机制
2. 确定影响脑补倾向的个体差异因素
3. 揭示相关的神经基础

研究假设：脑补现象反映了大脑基于先验经验进行预测性编码的加工策略。''',
      'design': '''**实验 1：行为学研究**
- 任务：模糊刺激识别任务
- 测量：脑补倾向与认知风格的相关

**实验 2：神经影像研究**
- 方法：fMRI 记录被试完成模糊刺激任务时的脑活动
- 分析：预测误差信号与脑补倾向的关系''',
      'results': '''**结果 1**：个体在模糊情境下倾向于用先验信息填充缺失部分

**结果 2**：脑补倾向与想象力、创造力正相关

**结果 3**：前额叶和海马的活动预测脑补程度

**结果 4**：预测误差信号调节脑补强度''',
      'conclusion': '''**理论贡献**：本研究揭示了"脑补"现象的预测性编码机制，证明了知觉是主动构建而非被动反映的过程。

**实践意义**：为理解目击者证词可靠性、虚假信息传播等现象提供了科学依据。''',
    },
    '6': {
      'background': '''青少年期是大脑发育的关键阶段，这一时期的大脑经历着广泛的结构和功能重组。灰质体积 prune、白质完整性增强、神经网络效率提升等变化，为认知能力的发展奠定了神经基础。

然而，青少年大脑发育是否存在关键窗口期？这一时期的发育如何影响后续的心理功能？''',
      'objective': '''本研究旨在：

1. 描绘青少年大脑发育的轨迹
2. 识别发育关键窗口期
3. 建立脑发育与认知发展的关系

研究假设：青少年期特定脑区的发育速度与相应认知能力的发展存在时间上的耦合。''',
      'design': '''**设计**：纵向追踪研究

**参与者**：200 名 10-18 岁青少年，追踪 4 年

**测量**：
- 每年一次结构性和功能性 MRI 扫描
- 认知能力测试（执行功能、情绪调节等）
- 行为问卷（风险行为、同伴关系等）

**分析**：潜变量增长模型、交叉滞后分析''',
      'results': '''**结果 1**：前额叶皮层厚度在 12-14 岁变化最快

**结果 2**：杏仁核 - 前额叶连接强度预测情绪调节能力

**结果 3**：发育轨迹存在显著的个体差异

**结果 4**：早期压力加速某些脑区的成熟''',
      'conclusion': '''**理论贡献**：本研究绘制了青少年大脑发育的详细图谱，揭示了关键窗口期的存在。

**实践意义**：为青少年心理健康干预的时机选择提供了科学依据。

**局限与展望**：需要更长期的追踪来考察发育轨迹的远期影响。''',
    },
    '7': {
      'background': '''拖延症是普遍存在的自我调节失败现象，影响着学习、工作和健康等多个领域。传统观点认为拖延主要是因为时间管理能力不足或意志力薄弱。

然而，近年来有理论提出，拖延可能与大脑预测未来情绪的能力缺陷有关。如果个体无法准确预见拖延带来的负面情绪后果，就难以克服当下的诱惑。''',
      'objective': '''本研究旨在：

1. 检验情绪预测缺陷与拖延症的关系
2. 探索改善情绪预测能力的干预方法
3. 揭示相关的认知和神经机制

研究假设：拖延症患者在预测未来情绪时表现出系统性偏差。''',
      'design': '''**研究 1：相关研究**
- 参与者：150 名大学生
- 测量：情绪预测任务、拖延量表

**研究 2：干预研究**
- 设计：随机对照试验
- 干预：情绪预测训练 vs 控制组
- 结果：干预前后拖延行为变化''',
      'results': '''**结果 1**：拖延症与情绪预测准确性负相关

**结果 2**：拖延者低估未来负面情绪的强度

**结果 3**：情绪预测训练显著减少拖延行为

**结果 4**：效应通过增强未来自我连续性中介''',
      'conclusion': '''**理论贡献**：本研究提出了拖延症的情绪预测理论，拓展了对自我调节失败的理解。

**实践意义**：为拖延症干预提供了新的靶点和方法。

**局限与展望**：需要在临床样本中验证效应的普遍性。''',
    },
  };

  /// 通过 article ID 从 papers 列表中反查完整文章数据
  /// 支持前缀匹配（如 'mock_1' 也能匹配到 '1'）
  static Map<String, dynamic>? getArticleById(String id) {
    if (id.isEmpty) return null;
    // 精确匹配
    for (final paper in papers) {
      if (paper['id']?.toString() == id) return paper;
    }
    // 前缀匹配（如 'mock_1' → '1'）
    for (final paper in papers) {
      if (paper['id']?.toString() == id.replaceFirst(RegExp(r'^(mock_|arxiv_)'), '')) {
        return paper;
      }
    }
    return null;
  }

  static final List<Map<String, dynamic>> papers = [
    // 左侧大卡片
    {
      'id': '1',
      'title': 'PNAS | 4 岁孩子已经会判断"谁本来就该知道我的事"了',
      'displayTitle': '4 岁孩子已经会判断\n"谁本来就该知道我的事"了',
      'summary': '儿童什么时候开始理解社会关系会影响信息如何在人际网络中流动？',
      'journal': 'PNAS',
      'journalName': 'PNAS',
      'journalLogo': '📖',
      'publishDate': '2026-03-20',
      'year': '2026',
      'author': 'PsyBrain Daily',
      'authors': '张三，李四，王五',
      'doi': '10.1073/pnas.2026.001',
      'category': '发展与教育',
      'coverImagePath': 'assets/paper_images/4岁孩子.png',
      'coverAspectRatio': 0.8, // 4:5 比例
      'coverTemplateColor': 'purple',
      'tags': ['儿童发展', '社会认知', '心理学'],
      'likes': 256,
      'saves': 89,
      'comments': 42,
    },
    {
      'id': '2',
      'title': 'Nature Human Behaviour | 睡眠如何重塑我们的情绪记忆',
      'displayTitle': '睡眠如何重塑\n我们的情绪记忆',
      'summary': '睡眠对情绪记忆巩固的作用及其神经机制',
      'journal': 'Nature Human Behaviour',
      'journalName': 'Nature Human Behaviour',
      'journalLogo': '🧬',
      'publishDate': '2026-04-15',
      'year': '2026',
      'author': '神经科学前沿',
      'authors': 'Smith J, Chen L, Wang Y',
      'doi': '10.1038/s41562-026-001',
      'category': '情绪与心理健康',
      'coverImagePath': 'assets/paper_images/睡眠如何重塑情绪记忆.png',
      'coverAspectRatio': 0.75, // 3:4 比例
      'coverTemplateColor': 'blue',
      'tags': ['睡眠', '记忆', '神经科学'],
      'likes': 189,
      'saves': 67,
      'comments': 23,
    },
    {
      'id': '5',
      'title': 'PNAS | 为什么我们会"脑补"不存在的信息',
      'displayTitle': '为什么我们会\n"脑补"不存在的信息',
      'summary': '大脑如何主动构建和解释感官信息',
      'journal': 'PNAS',
      'journalName': 'PNAS',
      'journalLogo': '📖',
      'publishDate': '2026-04-05',
      'year': '2026',
      'author': '心智与脑',
      'authors': 'Johnson A, Liu X',
      'doi': '10.1073/pnas.2026.005',
      'category': '认知与决策',
      'coverImagePath': 'assets/paper_images/为什么我们会脑补不存在的信息.png',
      'coverAspectRatio': 1.0, // 1:1 比例
      'coverTemplateColor': 'green',
      'tags': ['知觉', '认知科学', '脑科学'],
      'likes': 167,
      'saves': 54,
      'comments': 31,
    },
    // 右侧小卡片
    {
      'id': '3',
      'title': 'Science | 决策中的直觉：大脑如何在毫秒内做出价值判断',
      'displayTitle': '决策中的直觉：\n大脑如何在毫秒内\n做出价值判断',
      'summary': '直觉和分析性决策的神经机制对比研究',
      'journal': 'Science',
      'journalName': 'Science',
      'journalLogo': '🔬',
      'publishDate': '2026-04-10',
      'year': '2026',
      'author': '认知科学评论',
      'authors': 'Williams R, Zhang W',
      'doi': '10.1126/science.2026.003',
      'category': '认知与决策',
      'coverImagePath': 'assets/paper_images/大脑如何在毫秒内做出价值判断.png',
      'coverAspectRatio': 0.8, // 4:5
      'coverTemplateColor': 'blue',
      'tags': ['决策', '神经科学', '心理学'],
      'likes': 312,
      'saves': 128,
      'comments': 56,
    },
    {
      'id': '4',
      'title': 'Cell | 肠道微生物如何影响你的社交行为',
      'displayTitle': '肠道微生物\n如何影响你的\n社交行为',
      'summary': '肠 - 脑轴对社交行为的影响机制',
      'journal': 'Cell',
      'journalName': 'Cell',
      'journalLogo': '🧫',
      'publishDate': '2026-04-08',
      'year': '2026',
      'author': 'PsyBrain Daily',
      'authors': 'Garcia M, Lee K, Zhao Y',
      'doi': '10.1016/j.cell.2026.004',
      'category': '脑科学与神经',
      'coverImagePath': 'assets/paper_images/肠道如何影响社交.png',
      'coverAspectRatio': 0.75, // 3:4
      'coverTemplateColor': 'green',
      'tags': ['肠脑轴', '微生物', '社交行为'],
      'likes': 445,
      'saves': 178,
      'comments': 78,
    },
    {
      'id': '6',
      'title': 'Nature Neuroscience | 青少年大脑发育的关键窗口',
      'displayTitle': '青少年大脑发育的\n关键窗口',
      'summary': '青少年期大脑发育轨迹与认知发展的关系',
      'journal': 'Nature Neuroscience',
      'journalName': 'Nature Neuroscience',
      'journalLogo': '🧠',
      'publishDate': '2026-04-01',
      'year': '2026',
      'author': '发展心理学前沿',
      'authors': 'Brown T, Wu J',
      'doi': '10.1038/s41593-026-001',
      'category': '发展与教育',
      'coverImagePath': 'assets/paper_images/青少年大脑发育的关键窗口.png',
      'coverAspectRatio': 1.0, // 1:1
      'coverTemplateColor': 'purple',
      'tags': ['青少年', '大脑发育', '认知发展'],
      'likes': 234,
      'saves': 92,
      'comments': 45,
    },
    // 更多数据
    {
      'id': '7',
      'title': 'Psychological Science | 拖延症可能是因为大脑无法预测未来的情绪',
      'displayTitle': '拖延症可能是因为\n大脑无法预测\n未来的情绪',
      'summary': '情绪预测缺陷与拖延症的关系研究',
      'journal': 'Psychological Science',
      'journalName': 'Psychological Science',
      'journalLogo': '📊',
      'publishDate': '2026-03-28',
      'year': '2026',
      'author': '认知科学评论',
      'authors': 'Taylor S, Chen H',
      'doi': '10.1177/0956797626001',
      'category': '情绪与心理健康',
      'coverImagePath': 'assets/paper_images/拖延症.png',
      'coverAspectRatio': 0.85, // 略长
      'coverTemplateColor': 'pink',
      'tags': ['拖延症', '情绪预测', '自我调节'],
      'likes': 178,
      'saves': 71,
      'comments': 29,
    },
    {
      'id': '8',
      'title': 'Nature | 深度学习模型成功预测蛋白质三维结构',
      'displayTitle': '深度学习模型\n成功预测蛋白质\n三维结构',
      'summary': 'AI 在结构生物学领域的突破性进展',
      'journal': 'Nature',
      'journalName': 'Nature',
      'journalLogo': '🌟',
      'publishDate': '2026-03-25',
      'year': '2026',
      'author': 'AI 与神经科学',
      'authors': 'DeepMind Team',
      'doi': '10.1038/s41586-026-001',
      'category': 'AI与人类',
      'coverImagePath': 'assets/paper_images/深度学习模型预测蛋白质三维结构.png',
      'coverAspectRatio': 0.75,
      'coverTemplateColor': 'orange',
      'tags': ['AI', '蛋白质', '结构生物学'],
      'likes': 892,
      'saves': 356,
      'comments': 134,
    },
    // 示例文章 1：使用从 PDF 提取的真实学术插图（神经网络架构图）
    {
      'id': '9',
      'title': 'ImageNet Classification with Deep Convolutional Neural Networks',
      'summary': '经典论文：AlexNet 开创性的 CNN 架构，包含卷积层、池化层和全连接层的可视化',
      'journal': 'arXiv:2203.11115',
      'publishDate': '2022-03',
      'author': 'Krizevsky et al.',
      // 使用从 PDF 提取的真实架构图（Figure 1: 神经网络结构图）
      'coverImagePath': 'assets/paper_images/arxiv_2203_11115_fig1.png',
      'category': 'AI与人类',
      'likes': 1256,
      'comments': 189,
    },
    // 示例文章 2：使用从 PDF 提取的真实学术插图（Figure 2）
    {
      'id': '10',
      'title': 'Deep Learning in Neural Networks: An Overview',
      'summary': '深度学习综述：展示多层神经网络的学习机制和反向传播算法',
      'journal': 'arXiv:2203.11115',
      'publishDate': '2022-03',
      'author': 'Schmidhuber et al.',
      // 使用从 PDF 提取的真实图表（Figure 2: 深度学习流程图）
      'coverImagePath': 'assets/paper_images/Deep learning in Neural Networks An overview.png',
      'category': 'AI与人类',
      'likes': 892,
      'comments': 134,
    },
    // 示例文章 3：使用从 PDF 提取的真实学术插图（LLM 架构图）
    {
      'id': '11',
      'title': 'A Survey of Large Language Models',
      'summary': '大语言模型全面综述：展示 LLM 的架构、训练方法和应用场景',
      'journal': 'arXiv:2301.07095',
      'publishDate': '2023-01',
      'author': 'Zhao et al.',
      // 使用从 PDF 提取的真实图表（Figure 1: LLM 架构图）
      'coverImagePath': 'assets/paper_images/arxiv_2301_07095_fig1.png',
      'category': 'AI与人类',
      'likes': 2341,
      'comments': 312,
    },
    // 示例文章 4：使用从 PDF 提取的第一页（标题页）
    {
      'id': '12',
      'title': 'Deep Arbitrary Polynomial Chaos Neural Network',
      'summary': '深度任意多项式混沌神经网络：结合齐次混沌理论和深度学习的新方法',
      'journal': 'arXiv:2306.14753',
      'publishDate': '2023-06',
      'author': 'Oladyshkin et al.',
      // 使用从 PDF 提取的第一页作为封面（显示论文标题）
      'coverImagePath': 'assets/paper_images/arxiv_2306_14753_cover.png',
      'category': '方法与工具',
      'likes': 287,
      'comments': 52,
    },
  ];

  static final List<Map<String, dynamic>> discussions = [
    {
      'id': '1',
      'title': '有研究说冥想可以改变大脑结构，有人试过吗？',
      'author': '用户 A123',
      'likes': 45,
      'colorName': 'blue',
    },
    {
      'id': '2',
      'title': '推荐一本好用的统计学教材',
      'author': '研一小白',
      'likes': 23,
      'colorName': 'green',
    },
    {
      'id': '3',
      'title': 'fMRI 数据处理求助',
      'author': '神经影像狗',
      'likes': 12,
      'colorName': 'orange',
    },
    {
      'id': '4',
      'title': '有人参加今年的 CNS 年会吗',
      'author': '会议达人',
      'likes': 67,
      'colorName': 'purple',
    },
    {
      'id': '5',
      'title': '如何优雅地 rejection proof 你的论文',
      'author': '老博士',
      'likes': 234,
      'colorName': 'red',
    },
    {
      'id': '6',
      'title': '分享一个好用的文献管理工具',
      'author': '效率控',
      'likes': 89,
      'colorName': 'teal',
    },
  ];

  static final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'sender': '神经科学前沿',
      'action': '关注了你',
      'time': '刚刚',
      'unread': true,
      'colorName': 'blue',
    },
    {
      'id': '2',
      'sender': '用户 B456',
      'action': '评论了你的文章',
      'content': '这篇解读太棒了！特别是关于 Study 2 的设计逻辑，之前一直没太明白...',
      'time': '1 小时前',
      'unread': true,
      'iconName': 'person',
    },
    {
      'id': '3',
      'sender': 'PsyBrain Daily',
      'action': '发布了新内容',
      'content': 'Science | 工作记忆容量的个体差异源于... ',
      'time': '3 小时前',
      'unread': false,
      'colorName': 'purple',
    },
    {
      'id': '4',
      'sender': '认知科学评论',
      'action': '点赞了你的评论',
      'time': '昨天',
      'unread': false,
      'iconName': 'school',
    },
    {
      'id': '5',
      'sender': '系统通知',
      'action': '你的内容已被推荐至首页精选',
      'time': '2 天前',
      'unread': false,
      'iconName': 'star',
    },
  ];

  // ========== 集市帖子数据 ==========
  static final List<Map<String, dynamic>> marketplacePosts = [
    {
      'id': 'mp_1',
      'title': '如何快速读懂一篇顶刊论文？',
      'content': '''分享一个我读论文的方法论：

1. 先看 Abstract 和 Conclusion，了解核心结论
2. 看 Figure 1，通常是整体框架图
3. 读 Introduction 最后一段，找到研究问题
4. Method 部分不需要逐字读，了解大致设计即可
5. Discussion 重点看 limitations 部分

这样读一篇论文大概 30 分钟，比从头到尾读效率高很多。大家有什么更好的方法欢迎分享！''',
      'summary': '分享一个三步读论文法，30 分钟搞定一篇顶刊',
      'authorName': '科研小白逆袭中',
      'authorRole': '博士生',
      'authorAvatar': '🧑‍🔬',
      'createdAt': '2 小时前',
      'tags': ['经验分享', '论文阅读'],
      'likes': 342,
      'commentsCount': 56,
      'saves': 189,
      'comments': [
        {
          'author': '小明同学',
          'role': '硕士生',
          'avatar': '👨‍🎓',
          'text': '这个方法太实用了！特别是看 Figure 1 那步，我之前总是忽略。',
          'time': '1 小时前',
        },
        {
          'author': 'PhD_Li',
          'role': '博士生',
          'avatar': '🧑‍🔬',
          'text': '补充一下，如果是实验性论文，Method 还是得仔细看 design 部分',
          'time': '45 分钟前',
        },
        {
          'author': '数据民工',
          'role': '科研助理',
          'avatar': '💻',
          'text': 'Discussion 的 limitations 真的是宝藏，很多灵感都来自这里',
          'time': '30 分钟前',
        },
      ],
    },
    {
      'id': 'mp_2',
      'title': '心理学本科生怎么入门计算建模？',
      'content': '''本人心理学大三，对计算建模很感兴趣，但数学基础一般（只学过高数）。想问：

1. 需要补充哪些数学知识？线性代数和概率论够吗？
2. 有什么适合新手的建模教材推荐？
3. Python 和 MATLAB 哪个更适合入门？

先谢谢各位大佬！''',
      'summary': '心理学本科生入门计算建模，求方向和建议',
      'authorName': '求知若渴',
      'authorRole': '本科生',
      'authorAvatar': '👨‍🎓',
      'createdAt': '5 小时前',
      'tags': ['论文求助', '计算建模'],
      'likes': 128,
      'commentsCount': 34,
      'saves': 95,
      'comments': [
        {
          'author': '建模老手',
          'role': 'PI',
          'avatar': '👨‍🏫',
          'text': '线性代数+概率论够用。推荐《Computational Cognitive Neuroscience》这本书，零基础友好。',
          'time': '4 小时前',
        },
        {
          'author': 'Python大法好',
          'role': '硕士生',
          'avatar': '🧑‍💻',
          'text': 'Python！现在主流都是 Python 了，MATLAB 除非你们实验室已经在用',
          'time': '3 小时前',
        },
      ],
    },
    {
      'id': 'mp_3',
      'title': 'AI 生成封面会不会影响科研可信度？',
      'content': '''最近看到很多论文用 AI 生成的配图，感觉确实漂亮。但有个担心：

如果一张论文的配图看起来太"完美"，会不会反而让审稿人/读者觉得不够严肃？

特别是我们心理学/认知科学这种偏文科的方向，用 AI 生成的示意图会不会显得不够专业？

想听听大家的看法。''',
      'summary': '讨论：AI 配图在学术论文中的接受度',
      'authorName': '审美强迫症',
      'authorRole': '硕士生',
      'authorAvatar': '🎨',
      'createdAt': '昨天',
      'tags': ['AI工具', '学术讨论'],
      'likes': 256,
      'commentsCount': 78,
      'saves': 67,
      'comments': [
        {
          'author': '生物狗',
          'role': '博士生',
          'avatar': '🧬',
          'text': '我们导师就是用 AI 生成 mechanism diagram，审人反而觉得做得很专业',
          'time': '23 小时前',
        },
        {
          'author': '传统派',
          'role': 'PI',
          'avatar': '👨‍🏫',
          'text': '内容比形式重要。如果数据不够好，封面再漂亮也没用',
          'time': '20 小时前',
        },
      ],
    },
    {
      'id': 'mp_4',
      'title': '保研联系导师邮件怎么写？',
      'content': '''马上要大三暑假了，准备申请保研。想发邮件联系导师，但不知道怎么写比较好。

目前的情况：
- 专业排名：15/120
- 有一段实验室科研经历（打杂为主）
- 英语六级 580
- 没有发表论文

邮件大概应该包含哪些内容？要不要附上简历和成绩单？求过来人指点！''',
      'summary': '保研联系导师邮件写作指南，过来人求助',
      'authorName': '迷茫大三',
      'authorRole': '本科生',
      'authorAvatar': '😰',
      'createdAt': '昨天',
      'tags': ['保研/申博', '经验分享'],
      'likes': 567,
      'commentsCount': 123,
      'saves': 445,
      'comments': [
        {
          'author': '上岸学长',
          'role': '博士生',
          'avatar': '🎓',
          'text': '一定要附简历和成绩单！邮件正文简明扼要写清楚三点：你是谁、为什么选这个导师、你能提供什么',
          'time': '22 小时前',
        },
        {
          'author': '导师视角',
          'role': 'PI',
          'avatar': '👨‍🏫',
          'text': '作为导师，我最看重的不是成绩，而是你对研究有没有真正的好奇心。邮件里体现这一点很重要。',
          'time': '18 小时前',
        },
      ],
    },
    {
      'id': 'mp_5',
      'title': '有哪些适合新手的统计学教材？',
      'content': '''推荐几本我看过觉得不错的统计学教材：

入门级：
1. 《Statistics for the Behavioral Sciences》- 心理学统计入门首选
2. 《Discovering Statistics Using SPSS》- 幽默风趣，适合零基础

进阶级：
3. 《Data Analysis Using Regression and Multilevel/Hierarchical Models》
4. 《Statistical Rethinking》- 贝叶斯统计，需要一定基础

实战级：
5. 《Applied Longitudinal Data Analysis》
6. 《Introduction to Mediation, Moderation, and Conditional Process Analysis》- Hayes 大神写的

大家还有什么推荐的？''',
      'summary': '从入门到进阶，精选 6 本统计学好书',
      'authorName': '书虫研究员',
      'authorRole': '博士生',
      'avatar': '📚',
      'createdAt': '2 天前',
      'tags': ['资料推荐', '统计学'],
      'likes': 892,
      'commentsCount': 145,
      'saves': 678,
      'comments': [
        {
          'author': '贝叶斯信徒',
          'role': '硕士生',
          'avatar': '🙏',
          'text': 'Statistical Rethinking 太棒了！McElreath 讲课视频也很好',
          'time': '1 天前',
        },
        {
          'author': 'SPSS战士',
          'role': '本科生',
          'avatar': '⚔️',
          'text': 'Discovering Statistics Using SPSS 真的很有趣， Andy Field 写得太好了',
          'time': '20 小时前',
        },
      ],
    },
    {
      'id': 'mp_6',
      'title': 'fMRI 预处理用 SPM 还是 FSL？',
      'content': '''刚进实验室，导师让我做 fMRI 数据预处理。纠结选哪个软件：

SPM：
- 据说文档全、教程多
- 有 MATLAB 界面
- 好像比较老牌

FSL：
- 开源免费
- 命令行操作
- 据说速度更快

还有人说用 AFNI 的。大家觉得新手应该选哪个？会不会影响后续分析流程？''',
      'summary': 'SPM vs FSL vs AFNI，新手该如何选？',
      'authorName': '影像新人',
      'authorRole': '硕士生',
      'authorAvatar': '🧠',
      'createdAt': '3 天前',
      'tags': ['论文求助', '方法论'],
      'likes': 198,
      'commentsCount': 67,
      'saves': 134,
      'comments': [
        {
          'author': '影像老鸟',
          'role': '博士生',
          'avatar': '🐦',
          'text': '看你导师和实验室用什么，跟着用就行。工具不重要，分析思路重要。',
          'time': '2 天前',
        },
      ],
    },
    {
      'id': 'mp_7',
      'title': '分享一下我的选题灵感来源',
      'content': '''很多师弟师妹问我选题怎么做，分享一下我的经验：

1. **读 Discussion**：每篇论文的 Discussion 最后都会说"未来可以研究XX"，这就是现成的选题方向

2. **交叉学科**：把你的方法和别人的领域结合，或者把别人的方法用在你的领域

3. **生活中的观察**：很多好选题来自日常观察。我现在的课题就来自等地铁时想到的

4. **和导师/同学聊天**：聊着聊着可能就有灵感了

5. **参加学术会议**：听别人的报告，找自己感兴趣的且能做的工作

最重要的是：选题不用追求完美，先做起来再说！''',
      'summary': '5 个选题灵感来源，帮你找到研究方向',
      'authorName': '灵感制造机',
      'authorRole': '博士生',
      'authorAvatar': '💡',
      'createdAt': '4 天前',
      'tags': ['选题灵感', '经验分享'],
      'likes': 1234,
      'commentsCount': 89,
      'saves': 567,
      'comments': [
        {
          'author': '选题困难户',
          'role': '硕士生',
          'avatar': '😭',
          'text': '第三条太真实了！我的课题也是洗澡的时候想到的',
          'time': '3 天前',
        },
        {
          'author': '行动派',
          'role': '硕士生',
          'avatar': '🏃',
          'text': '"选题不用追求完美，先做起来再说" — 这句话应该打印出来贴墙上',
          'time': '3 天前',
        },
      ],
    },
    {
      'id': 'mp_8',
      'title': '推荐几个好用的 AI 科研工具',
      'content': '''整理一下我用过的 AI 科研工具：

文献管理：
- **Elicit** — AI 辅助文献综述，输入研究问题自动找相关论文
- **Consensus** — AI 搜索引擎，直接给结论而非链接列表

论文阅读：
- **SciSpace** — 可以提问关于论文内容的问题
- **ChatPDF** — 和论文对话

写作辅助：
- **Grammarly** — 语法检查
- **Jenni AI** — AI 辅助写作

数据分析和可视化：
- **Tableau AI** — 自动数据可视化
- **Python + matplotlib/seaborn** — 最灵活

提醒：AI 工具只是辅助，核心还是要自己理解内容！''',
      'summary': '8 个 AI 科研工具，覆盖文献到写作全流程',
      'authorName': '工具控',
      'authorRole': '科研助理',
      'authorAvatar': '🤖',
      'createdAt': '5 天前',
      'tags': ['AI工具', '资料推荐'],
      'likes': 2345,
      'commentsCount': 178,
      'saves': 1234,
      'comments': [
        {
          'author': 'Consensus用户',
          'role': '博士生',
          'avatar': '🔍',
          'text': 'Consensus 真的好用！比直接搜 Google Scholar 快多了',
          'time': '4 天前',
        },
      ],
    },
  ];

  // ========== 集市热搜榜 ==========
  static final List<Map<String, dynamic>> hotTopics = [
    {
      'id': 'ht_1',
      'title': '如何快速读懂一篇顶刊论文？',
      'heat': '12.3k',
      'tag': '热',
      'tagColor': 'red',
      'relatedPostId': 'mp_1',
    },
    {
      'id': 'ht_2',
      'title': '心理学本科生怎么入门计算建模？',
      'heat': '8.7k',
      'tag': '新',
      'tagColor': 'blue',
      'relatedPostId': 'mp_2',
    },
    {
      'id': 'ht_3',
      'title': 'AI 生成封面会不会影响科研可信度？',
      'heat': '6.5k',
      'tag': '讨论中',
      'tagColor': 'purple',
      'relatedPostId': 'mp_3',
    },
    {
      'id': 'ht_4',
      'title': '保研联系导师邮件怎么写？',
      'heat': '5.2k',
      'tag': '热',
      'tagColor': 'orange',
      'relatedPostId': 'mp_4',
    },
    {
      'id': 'ht_5',
      'title': '有哪些适合新手的统计学教材？',
      'heat': '4.8k',
      'tag': null,
      'tagColor': null,
      'relatedPostId': 'mp_5',
    },
  ];
}
