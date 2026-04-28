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
    // 示例文章 1
    {
      'id': '9',
      'title': 'ImageNet Classification with Deep Convolutional Neural Networks',
      'summary': '经典论文：AlexNet 开创性的 CNN 架构，包含卷积层、池化层和全连接层的可视化',
      'journal': 'arXiv:2203.11115',
      'publishDate': '2022-03',
      'author': 'Krizevsky et al.',
      'coverImagePath': 'assets/paper_images/arxiv_2203_11115_fig1.png',
      'category': 'AI与人类',
      'likes': 1256,
      'comments': 189,
    },
    // 示例文章 2
    {
      'id': '10',
      'title': 'Deep Learning in Neural Networks: An Overview',
      'summary': '深度学习综述：展示多层神经网络的学习机制和反向传播算法',
      'journal': 'arXiv:2203.11115',
      'publishDate': '2022-03',
      'author': 'Schmidhuber et al.',
      'coverImagePath': 'assets/paper_images/Deep learning in Neural Networks An overview.png',
      'category': 'AI与人类',
      'likes': 892,
      'comments': 134,
    },
    // 示例文章 3
    {
      'id': '11',
      'title': 'A Survey of Large Language Models',
      'summary': '大语言模型全面综述：展示 LLM 的架构、训练方法和应用场景',
      'journal': 'arXiv:2301.07095',
      'publishDate': '2023-01',
      'author': 'Zhao et al.',
      'coverImagePath': 'assets/paper_images/arxiv_2301_07095_fig1.png',
      'category': 'AI与人类',
      'likes': 2341,
      'comments': 312,
    },
    // 示例文章 4
    {
      'id': '12',
      'title': 'Deep Arbitrary Polynomial Chaos Neural Network',
      'summary': '深度任意多项式混沌神经网络：结合齐次混沌理论和深度学习的新方法',
      'journal': 'arXiv:2306.14753',
      'publishDate': '2023-06',
      'author': 'Oladyshkin et al.',
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
      'category': '关注消息',
    },
    {
      'id': '2',
      'sender': '用户 B456',
      'action': '评论了你的文章',
      'content': '这篇解读太棒了！特别是关于 Study 2 的设计逻辑，之前一直没太明白...',
      'time': '1 小时前',
      'unread': true,
      'iconName': 'person',
      'category': '推送消息',
    },
    {
      'id': '3',
      'sender': 'PsyBrain Daily',
      'action': '发布了新内容',
      'content': 'Science | 工作记忆容量的个体差异源于... ',
      'time': '3 小时前',
      'unread': false,
      'colorName': 'purple',
      'category': '推送消息',
    },
    {
      'id': '4',
      'sender': '认知科学评论',
      'action': '点赞了你的评论',
      'time': '昨天',
      'unread': false,
      'iconName': 'school',
      'category': '点赞消息',
    },
    {
      'id': '5',
      'sender': '系统通知',
      'action': '你的内容已被推荐至首页精选',
      'time': '2 天前',
      'unread': false,
      'iconName': 'star',
      'category': '官方消息',
    },
  ];

  // ========== 论坛帖子数据 ==========
  static final List<Map<String, dynamic>> marketplacePosts = [
    // ===== 选题灵感 =====
    {
      'id': 'mp_1',
      'title': '从 CoT 论文出发：模型的解释是真实推理，还是更像人类的文本？',
      'content': '''灵感来源：Wei et al. (2022) "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models"
链接：https://arxiv.org/abs/2201.11903

这篇文章最核心的发现是：当模型被要求"一步步推理"时，它在复杂推理任务上的表现会明显提升。但一个可以继续追问的问题是——模型写出的推理过程，究竟是在真实帮助它思考，还是只是生成了一个更像人类解释的文本？

可以转化成一个本科生可做的小项目：选取一批逻辑题或常识题，比较"直接回答"、"先解释再回答"、"先给答案再补解释"三种条件下，模型答案正确率和解释可信度的变化。进一步还可以让真人被试评价这些解释是否让他们更相信模型。

这个选题的优点是材料容易收集，实验成本低，而且能连接认知心理学中的解释、信任与元认知判断问题。

执行建议：用 ChatGPT API 或免费的开源模型（如 Llama 3）做三组对比实验，收集 200-500 条回答，然后请 30-50 个被试做 Likert 量表评分。''',
      'summary': '基于 CoT 论文，探讨模型解释是真实推理还是生成文本，附本科生可执行方案',
      'authorName': '认知实验室新人',
      'authorRole': '硕士生',
      'authorAvatar': '🧑‍🔬',
      'createdAt': '2 小时前',
      'tags': ['选题灵感', '大语言模型', '推理'],
      'likes': 523,
      'commentsCount': 67,
      'saves': 312,
      'comments': [
        {
          'author': 'LLM研究者',
          'role': '博士生',
          'avatar': '💻',
          'text': '这个思路好！其实可以再加一个"随机生成解释"的条件作为基线对照。',
          'time': '1 小时前',
        },
        {
          'author': '心理学人',
          'role': '本科生',
          'avatar': '🧠',
          'text': '被试评价的解释可信度，应该和模型答案的正确性分开评，不然会confound。',
          'time': '45 分钟前',
        },
      ],
    },
    {
      'id': 'mp_2',
      'title': '从睡眠论文延展出情绪记忆选题：REM 到底在做什么？',
      'content': '''灵感来源：Walker & van der Helm (2009) "Sleep and emotional memory processing"
链接：DOI: 10.1037/a0016570

这篇文章系统综述了睡眠对情绪记忆加工的影响，核心结论是：REM 睡眠（快速眼动睡眠）期间，杏仁核-海马通道的重组会优先巩固情绪性记忆，同时弱化记忆的"疼痛感"。

可以延展的问题是：如果我们在 REM 睡眠期间给予温和的外在线索（如气味提示），能否进一步调节情绪记忆的强度？

本科生可以做的实验设计：
1. 第一天：学习一批情绪图片（IAPS），一半在学习后伴随玫瑰气味
2. 睡眠夜：实验组在 REM 睡眠期间重新释放玫瑰气味
3. 第二天：测试图片记忆准确度和情绪反应（皮电、主观评分）

这个选题门槛不高，但设计精巧。如果学校没有睡眠监测设备，可以用"午睡 vs 不午睡"的简化设计来近似研究。''',
      'summary': '从睡眠与情绪记忆的经典综述出发，延展出一个可操作的本科生实验设计',
      'authorName': '睡眠研究员',
      'authorRole': '博士生',
      'authorAvatar': '😴',
      'createdAt': '5 小时前',
      'tags': ['选题灵感', '睡眠', '情绪记忆'],
      'likes': 445,
      'commentsCount': 43,
      'saves': 289,
      'comments': [
        {
          'author': '实验设计控',
          'role': '硕士生',
          'avatar': '🔬',
          'text': '午睡设计很聪明！不过午睡通常 REM 很少，主要可能是 SWS 的作用，需要在假设里写清楚。',
          'time': '3 小时前',
        },
      ],
    },
    {
      'id': 'mp_3',
      'title': 'Transformer 论文之后：注意力权重真的可解释吗？',
      'content': '''灵感来源：Vaswani et al. (2017) "Attention Is All You Need"
链接：https://arxiv.org/abs/1706.03762

Transformer 架构改变了整个 NLP 乃至 AI 领域。但一个被广泛讨论的后续问题是：注意力权重 = 可解释性吗？

很多论文已经证明了注意力权重并不一定对应"模型到底关注了哪些词"。比如 Jain & Belinkov (2019) 和 Wiegreffe & Pinter (2019) 都讨论了这个问题。

可以做成一个有趣的大学生选题：比较"注意力权重可视化"和"人类解释"之间的一致性。具体做法——让真人标注哪些词对理解句子最重要，然后和 BERT/GPT 的注意力权重做相关性分析。

这个选题的好处：不需要训练大模型，只需要用预训练模型做推理 + 设计一个人类标注实验，成本很低但话题性很强。''',
      'summary': '对比 Transformer 注意力权重与人类理解是否一致，适合低成本研究',
      'authorName': 'NLP爱好者',
      'authorRole': '硕士生',
      'authorAvatar': '🤖',
      'createdAt': '8 小时前',
      'tags': ['选题灵感', 'Transformer', '可解释性'],
      'likes': 367,
      'commentsCount': 38,
      'saves': 201,
      'comments': [
        {
          'author': 'ML新手',
          'role': '本科生',
          'avatar': '📚',
          'text': '请问用什么工具做 BERT 注意力可视化？HuggingFace 的 transformers 可以直接拿到注意力权重吗？',
          'time': '6 小时前',
        },
      ],
    },
    // ===== AI工具 =====
    {
      'id': 'mp_4',
      'title': '读论文不要一上来就让 AI 总结全文，先让它拆"研究问题"',
      'content': '''很多人用 AI 读论文时，第一句话就是"帮我总结这篇文章"。但这样很容易得到一段很空泛的摘要。更好的做法是先让 AI 拆出论文的研究问题、理论缺口和变量关系。

可以直接使用这个提示词：

"我会给你一篇论文。请你不要先总结全文，而是先回答四个问题：
1）这篇文章想解决什么具体问题？
2）它认为前人研究缺了什么？
3）它的核心自变量、因变量、中介/调节变量分别是什么？
4）如果我要基于这篇文章做一个本科生可执行的小研究，可以往哪三个方向延展？
请用简洁中文回答。"

使用建议：
- Claude：适合上传完整 PDF，长文处理能力强
- ChatGPT：适合分段提问，配合原文片段效果更好
- Perplexity：适合带来源检索的快速查找，但要检查引用真实性

注意：不要让 AI 编造参考文献！永远让它用原文提供的信息回答。''',
      'summary': '一个更高效的 AI 读论文提示词模板，附三个主流工具的使用建议',
      'authorName': '提示词工程师',
      'authorRole': '博士生',
      'authorAvatar': '💡',
      'createdAt': '3 小时前',
      'tags': ['AI工具', '论文阅读', '提示词'],
      'likes': 1234,
      'commentsCount': 89,
      'saves': 876,
      'comments': [
        {
          'author': '科研小白',
          'role': '本科生',
          'avatar': '👶',
          'text': '这个提示词太有用了！特别是第4问，直接帮我想选题方向',
          'time': '2 小时前',
        },
      ],
    },
    {
      'id': 'mp_5',
      'title': 'Connected Papers + ResearchRabbit：文献发现工具横向测评',
      'content': '''做文献综述时，找到一篇核心论文后，如何快速找到相关文献？我用过几个工具，分享一下对比：

Connected Papers (connectedpapers.com)：
- 优点：可视化图谱非常直观，能一眼看出某个领域的关键论文和聚类
- 缺点：免费用户每月只能生成有限个图谱
- 适合：快速了解一个新领域的结构

ResearchRabbit (researchrabbit.ai)：
- 优点：可以关注某个作者或论文，它会自动推荐相关新文献
- 缺点：界面稍微复杂，需要一定学习成本
- 适合：长期追踪一个研究方向的进展

Elicit (elicit.com)：
- 优点：可以直接用自然语言搜索，它会帮你提取每篇论文的方法、样本量、结论
- 缺点：对非英文论文支持一般
- 适合：快速做系统性文献综述

建议：先用 Connected Papers 画图谱了解全局，再用 ResearchRabbit 持续追踪，最后用 Elicit 提取关键信息。''',
      'summary': '三大文献发现工具的实测对比，附最佳组合使用方案',
      'authorName': '工具控研究员',
      'authorRole': '博士生',
      'authorAvatar': '🛠️',
      'createdAt': '6 小时前',
      'tags': ['AI工具', '文献综述', '效率'],
      'likes': 892,
      'commentsCount': 56,
      'saves': 634,
      'comments': [
        {
          'author': '文献管理达人',
          'role': '硕士生',
          'avatar': '📖',
          'text': '补充一个：Semantic Scholar 的 API 免费而且非常强大，可以批量获取论文的引用关系。',
          'time': '4 小时前',
        },
      ],
    },
    {
      'id': 'mp_6',
      'title': 'Claude、ChatGPT、Perplexity 读论文谁更稳？实测 20 篇认知科学论文',
      'content': '''我拿 20 篇认知科学领域的论文（包括经典文献和最新发表），分别用三个工具做"提取研究问题和核心结论"任务，结果如下：

Claude 3 Opus：
- 长文理解能力最强，可以直接上传 PDF
- 提取的研究问题最准确，很少遗漏关键变量
- 偶尔会在方法细节上出错（比如混淆被试内/被试间设计）

ChatGPT-4o：
- 结构化总结能力最好，适合做笔记
- 回答速度快，适合快速对比多篇论文
- 缺点是没有上传 PDF 功能（除非用 Plus），需要手动复制粘贴

Perplexity Pro：
- 带来源检索，回答时会标注引用了论文的哪一页
- 适合验证 AI 有没有"编造"内容
- 但长文理解不如前两者，有时会抓不住核心贡献

结论：如果只能选一个——Claude 适合深度阅读，ChatGPT 适合快速笔记，Perplexity 适合事实核查。我现在的流程是：Claude 拆论文 → ChatGPT 做笔记 → Perplexity 验真。''',
      'summary': '三款主流 AI 工具的真实对比测评，附个人工作流',
      'authorName': 'AI测评员',
      'authorRole': '硕士生',
      'authorAvatar': '📊',
      'createdAt': '10 小时前',
      'tags': ['AI工具', '对比测评', '认知科学'],
      'likes': 1567,
      'commentsCount': 134,
      'saves': 1023,
      'comments': [
        {
          'author': 'Gemini用户',
          'role': '博士生',
          'avatar': '💎',
          'text': 'Gemini Advanced 没测吗？100万token的context window在处理超长综述时特别爽。',
          'time': '8 小时前',
        },
      ],
    },
    // ===== 整合分析 =====
    {
      'id': 'mp_7',
      'title': '同样研究 LLM 幻觉，TruthfulQA、HaluEval 和 SelfCheckGPT 差在哪？',
      'content': '''如果你想研究大模型幻觉，不同论文其实采用了很不一样的测量方式。

对比三类代表性工作：

1. TruthfulQA: Measuring How Models Mimic Human Falsehoods
   Lin et al., 2022
   https://arxiv.org/abs/2109.07958

2. HaluEval: A Large-Scale Hallucination Evaluation Benchmark
   Li et al., 2023
   https://arxiv.org/abs/2305.11747

3. SelfCheckGPT: Zero-Resource Black-Box Hallucination Detection
   Manakul et al., 2023
   https://arxiv.org/abs/2303.08896

TruthfulQA 更像是在测模型是否会重复人类常见误解——它构建了一批人类常见的错误信念，然后看模型是否也会被"带偏"。

HaluEval 更偏向于构造和识别幻觉样本——它用 GPT-4 生成不同场景下的幻觉数据，然后训练一个检测器。

SelfCheckGPT 的思路完全不同：它利用模型自身多次采样的一致性来判断回答是否可靠，不需要外部事实库。

本科生项目的建议：不要急着做大规模 benchmark，先选一个窄领域（比如心理学常识、医学科普或历史事实），比较"模型自信程度"和"事实正确性"之间是否脱钩。''',
      'summary': '三类 LLM 幻觉评估方法的横向对比，附本科生可执行方案',
      'authorName': 'AI评估者',
      'authorRole': '博士生',
      'authorAvatar': '🔍',
      'createdAt': '4 小时前',
      'tags': ['整合分析', 'LLM', '幻觉评估'],
      'likes': 756,
      'commentsCount': 45,
      'saves': 489,
      'comments': [
        {
          'author': '方法论新手',
          'role': '硕士生',
          'avatar': '📝',
          'text': '讲得很清楚！TruthfulQA 那个"模型是否会重复人类误解"的角度我之前没想过。',
          'time': '2 小时前',
        },
      ],
    },
    {
      'id': 'mp_8',
      'title': '人机信任研究方法盘点：问卷、行为任务和信任校准',
      'content': '''研究"人类是否信任 AI"这个方向，目前主流有几类方法：

1. 问卷法（最常用但争议最大）
- 代表工具：Lee & See (2004) 的信任量表、Jian et al. (2000) 的信任问卷
- 优点：容易实施，样本量大
- 缺点：自报告偏差严重，"说的"和"做的"不一定一致

2. 行为任务法
- 代表范式：自动化信号检测任务（Parasuraman et al., 2000）、建议采纳范式（Harvey & Fischer, 1997）
- 思路：让被试在真实决策任务中选择是否采纳 AI 建议
- 优点：行为指标更客观
- 缺点：实验设计复杂

3. 信任校准（Calibration）
- 代表研究：Dietvorst et al. (2015) 算法厌恶研究；Logg et al. (2019) 算法欣赏研究
- 核心问题：人类的信任程度是否匹配 AI 的实际能力？
- 方法：先测量 AI 的准确率，再测量被试的采纳率，计算校准误差

本科生建议：如果你有时间做实验，选"建议采纳范式"，设计一个 AI 帮助判断的疾病诊断或情绪识别任务，改变 AI 的准确率（50%/75%/95%），看被试的信任如何变化。''',
      'summary': '人机信任研究的三类主流方法对比，附本科生实验设计建议',
      'authorName': '人机交互研究员',
      'authorRole': '博士生',
      'authorAvatar': '🤝',
      'createdAt': '7 小时前',
      'tags': ['整合分析', '人机信任', '方法学'],
      'likes': 623,
      'commentsCount': 34,
      'saves': 412,
      'comments': [],
    },
    {
      'id': 'mp_9',
      'title': '情绪记忆研究方法全景：行为实验、睡眠操控、fMRI 和心理生理指标',
      'content': '''研究"情绪如何影响记忆"这个经典话题，不同论文采用了截然不同的方法：

1. 行为实验法
- 代表：Kensinger (2009) 情绪记忆的行为研究综述
- 方法：呈现情绪图片/词汇 → 自由回忆或再认测试
- 优点：门槛低，任何实验室都能做
- 局限：无法直接观测情绪加工的神经机制

2. 睡眠操控法
- 代表：Wagner et al. (2001) "Sleep enhances implicit memory"
- 方法：学习后睡眠组 vs 清醒组 → 比较情绪记忆保持
- 优点：能检验睡眠在情绪记忆中的作用
- 局限：需要控制睡眠阶段（PSG 监测）

3. fMRI 法
- 代表：Hamann (2001) 情绪记忆的 fMRI 元分析
- 方法：学习时扫描 → 测试时比较情绪 vs 中性项目的脑激活
- 优点：能直接观测杏仁核-海马通道的参与
- 局限：成本高，样本量通常偏小

4. 心理生理指标
- 代表：LaBar & Phelps (1998) 皮肤电与情绪记忆
- 方法：学习时记录皮电/心率 → 测试时比较生理反应与记忆的关联
- 优点：低成本、高时间分辨率
- 局限：指标解释有时有歧义

如果条件有限，建议从"行为实验 + 心理生理指标"组合入手，成本低且数据丰富。''',
      'summary': '情绪记忆研究的四种主流方法全景对比，附低成本方案建议',
      'authorName': '情绪记忆研究者',
      'authorRole': '硕士生',
      'authorAvatar': '❤️',
      'createdAt': '12 小时前',
      'tags': ['整合分析', '情绪记忆', '研究方法'],
      'likes': 434,
      'commentsCount': 23,
      'saves': 278,
      'comments': [
        {
          'author': '本科生',
          'role': '大三',
          'avatar': '🎓',
          'text': '请问行为实验的情绪图片除了 IAPS 还有其他替代吗？IAPS 申请比较麻烦。',
          'time': '10 小时前',
        },
        {
          'author': '情绪记忆研究者',
          'role': '硕士生',
          'avatar': '❤️',
          'text': 'CAPS (Chinese Affective Picture System) 是国内常模版本，或者直接用文字材料也可以。',
          'time': '9 小时前',
        },
      ],
    },
    // ===== 文献拆解 =====
    {
      'id': 'mp_10',
      'title': '一篇把"注意力机制"讲成时代转折点的论文，到底做了什么？',
      'content': '''文献：Vaswani et al. (2017) "Attention Is All You Need"
链接：https://arxiv.org/abs/1706.03762

这篇文章问的问题很直接：做序列建模时，我们能不能不依赖 RNN 或 CNN，只用注意力机制完成机器翻译？

它提出了 Transformer 架构，用 self-attention 来捕捉序列中不同位置之间的关系。简单说，它让模型在处理一个词的时候，可以同时"看见"句子里其他位置的信息，而不是只能按顺序一点点读。

这篇文章的影响有多大？后来的 BERT、GPT 系列、乃至多模态大模型，底层都是 Transformer。

我的看法是：这篇文章真正厉害的地方不只是提出了一个模型，而是改变了大家对"序列信息处理"的想象。但如果本科生直接读，会比较容易卡在公式和结构图上。

改进建议：如果要基于它做课程项目，不建议复现完整 Transformer，可以从"注意力可视化是否真的可解释"这个小问题入手，比较模型注意力权重和人类解释之间是否一致。''',
      'summary': 'Transformer 论文的核心贡献与局限，附本科生可操作的项目建议',
      'authorName': '深度学习读书会',
      'authorRole': '博士生',
      'authorAvatar': '📖',
      'createdAt': '1 天前',
      'tags': ['文献拆解', 'Transformer', '深度学习'],
      'likes': 987,
      'commentsCount': 72,
      'saves': 654,
      'comments': [
        {
          'author': 'Transformer小白',
          'role': '本科生',
          'avatar': '🌱',
          'text': '讲解得太清楚了！我之前一直卡在 multi-head attention 那里。',
          'time': '20 小时前',
        },
      ],
    },
    {
      'id': 'mp_11',
      'title': 'GPT-4 到底是不是医学知识的天才？拆解 Singhal et al. 2023',
      'content': '''文献：Singhal et al. (2023) "Large Language Models Encode Clinical Knowledge"
链接：https://arxiv.org/abs/2212.13138

这篇文章问了个好问题：GPT-4 在未经微调的情况下，能否通过美国医师资格考试（USMLE）风格的题目？

答案：能。而且不只是通过——它表现超过了医学毕业生的水平，在多个医学知识子任务上达到了"专家级"。

它做了什么：
- 用 USMLE 真题和模拟题测试 GPT-4
- 比较 GPT-4 与既往 LLM（如 GPT-3.5、BioBERT）的表现
- 测试了临床推理、患者沟通、伦理判断等多个维度
- 进一步测试了 GPT-4 在医患对话中的表现

核心发现：GPT-4 不仅在知识性问答上表现出色，在"患者沟通"和"伦理判断"维度也接近人类医师水平——这超出了很多研究者的预期。

我的看法：这篇论文的亮点不在于"GPT-4 能做医生"，而在于系统地检验了 LLM 在专业领域的知识编码能力。但它没有回答一个关键问题——模型的高分是真正理解了医学知识，还是只是在"背诵"训练数据中的模式？

改进建议：后续研究可以加入"反事实测试"——给模型一些医学上不合理的假设情境，看它是否仍然给出合理回答，以此区分"理解"和"背诵"。''',
      'summary': '拆解 GPT-4 医学知识编码的里程碑论文，附关键局限和改进建议',
      'authorName': 'AI医学观察',
      'authorRole': '硕士生',
      'authorAvatar': '🏥',
      'createdAt': '1 天前',
      'tags': ['文献拆解', 'GPT-4', '医学AI'],
      'likes': 1123,
      'commentsCount': 89,
      'saves': 756,
      'comments': [
        {
          'author': '医学生',
          'role': '研二',
          'avatar': '⚕️',
          'text': '补充一点：这篇文章的第一作者 Tanay Singhal 本身就是 Johns Hopkins 的医师，所以实验设计很贴合临床实际。',
          'time': '22 小时前',
        },
      ],
    },
    {
      'id': 'mp_12',
      'title': '"Language Models are Few-Shot Learners"——GPT-3 为什么改变了游戏规则',
      'content': '''文献：Brown et al. (2020) "Language Models are Few-Shot Learners"
链接：https://arxiv.org/abs/2005.14165

这篇论文是 GPT-3 的"出生证明"。它问了一个非常直接的问题：当模型规模足够大时，它能不能仅凭几个示例就学会一个新任务，而不需要微调？

它做了什么：
- 训练了从 125M 到 175B 参数不等的系列模型
- 在 NLP benchmarks 上测试 zero-shot、one-shot、few-shot 表现
- 比较了 scaling law（模型越大 → 表现越好）

核心发现：
- 175B 参数的 GPT-3 在 few-shot 条件下，许多任务上超过了 fine-tuned 的专门模型
- 更重要的是：涌现能力（emergent abilities）——某些能力只有在模型足够大时才会突然出现

我的看法：这篇文章最大的贡献不是"GPT-3 很厉害"，而是证明了"规模本身就是技术"。它推动了整个领域从"为每个任务设计专用模型"转向"训练一个通用大模型"。

但如果要做课程项目，不建议直接复现 GPT-3。更好的切入点是研究"few-shot 学习中示例选择"对结果的影响——这既有趣又容易实施。''',
      'summary': 'GPT-3 论文的深度拆解，从 scaling law 到涌现能力，附项目建议',
      'authorName': '大模型读书会',
      'authorRole': '博士生',
      'authorAvatar': '📚',
      'createdAt': '2 天前',
      'tags': ['文献拆解', 'GPT-3', 'Few-shot Learning'],
      'likes': 876,
      'commentsCount': 56,
      'saves': 523,
      'comments': [
        {
          'author': 'LLM入门者',
          'role': '本科生',
          'avatar': '🔰',
          'text': '请问有什么入门 GPT 架构的好资源推荐吗？',
          'time': '1 天前',
        },
        {
          'author': '大模型读书会',
          'role': '博士生',
          'avatar': '📚',
          'text': '推荐 Jay Alammar 的可视化博客 thecoldeval.com，讲 GPT 非常清楚',
          'time': '22 小时前',
        },
      ],
    },
    // ===== 观点碰撞 =====
    {
      'id': 'mp_13',
      'title': 'AI 让科研更公平了，还是让会提问的人更强了？',
      'content': '''现在很多 AI 工具都能帮我们读论文、整理综述、生成代码，表面上看，它降低了科研门槛。但另一个问题是：AI 真的让所有人都更容易做科研了吗？

我的感觉是，AI 降低的是"执行门槛"——翻译、总结、格式整理、代码初稿。但它没有自动降低"判断门槛"——你仍然要知道一个问题有没有价值，知道 AI 总结得对不对，知道某个方法是否适合你的研究。

所以 AI 可能不是让所有人同时变强，而是让那些本来就会提问、会判断、会拆问题的人变得更快。

可以讨论的问题是：未来本科生科研训练中，最重要的能力会不会从"查资料"转向"提出好问题"和"验证 AI 输出"？

还有一个更深的担忧：如果越来越多的大学生依赖 AI 来做文献综述，那"会写 prompt 的人"和"不会写 prompt 的人"之间的差距，会不会变成新的学术不平等？

欢迎讨论你的看法。''',
      'summary': 'AI 降低的是执行门槛还是判断门槛？探讨科研不平等的新维度',
      'authorName': '科研反思者',
      'authorRole': '博士生',
      'authorAvatar': '🤔',
      'createdAt': '3 小时前',
      'tags': ['观点碰撞', 'AI伦理', '科研公平'],
      'likes': 1345,
      'commentsCount': 178,
      'saves': 567,
      'comments': [
        {
          'author': '本科生A',
          'role': '大三',
          'avatar': '🎓',
          'text': '我认同。我室友用 ChatGPT 一周写了综述，我两周还没看完一半论文。但他的综述里有三篇 AI 编造的引用，这就是差距——他知道怎么提问，但不知道怎么验证。',
          'time': '2 小时前',
        },
        {
          'author': '青年教师',
          'role': '讲师',
          'avatar': '👨‍🏫',
          'text': '从教师角度看，我更担心的是：学生用 AI 太快得出结论，失去了"挣扎思考"的过程。学术训练的核心恰恰是那个"痛苦"的过程。',
          'time': '1 小时前',
        },
      ],
    },
    {
      'id': 'mp_14',
      'title': '用大模型做心理学实验，被试到底是谁？',
      'content': '''现在越来越多研究直接用 ChatGPT、Claude 等 LLM 做"心理学实验"——比如测试模型是否有认知偏差、是否表现出文化差异、是否具有共情能力。

但这带来一个根本性的方法论问题：如果模型不是人，用模型做心理学实验有意义吗？

支持方观点：
- Sheng et al. (2023) 发现 GPT 在信任游戏中表现出类似人类的"信任偏差"
- 如果模型的行为模式与人类足够相似，它可以作为人类行为的"代理"来加速初步探索
- 成本低、可重复、不受被试招募限制

反对方观点：
- 模型的"行为"本质上是文本生成，和人类的认知过程没有可比性
- 用 LLM 做心理学实验可能陷入"拟人化谬误"——把文本模式误解为心理过程
- 模型的输出分布高度依赖 prompt 工程，不像人类行为有内在稳定性

我的观点：LLM 作为心理学"被试"的价值不在于"它和人一样"，而在于它能揭示语言中编码的"常识心理学模式"。真正有意义的研究应该同时包含人类组和模型组，做系统比较。''',
      'summary': 'LLM 能否作为心理学实验的被试？支持方和反对方观点盘点',
      'authorName': '方法学讨论',
      'authorRole': '硕士生',
      'authorAvatar': '⚖️',
      'createdAt': '8 小时前',
      'tags': ['观点碰撞', '方法论', 'LLM'],
      'likes': 923,
      'commentsCount': 123,
      'saves': 456,
      'comments': [
        {
          'author': '实验心理学',
          'role': '博士生',
          'avatar': '🧪',
          'text': '非常赞同"同时包含人类组和模型组"的建议。Yuan et al. (2023) 就是这样做的，发在了 Nature Human Behaviour。',
          'time': '6 小时前',
        },
      ],
    },
    {
      'id': 'mp_15',
      'title': '只追热点选题，会不会伤害真正的学术训练？',
      'content': '''现在学术界有个趋势：哪个方向火就往哪个方向扎。GPT 火了就写 AI+X，AlphaFold 火了就写 AI+蛋白质，情绪稳定了就写 AI+心理健康。

问题是：追热点真的适合本科生科研训练吗？

追热点的好处：
- 评审人熟悉，论文更容易中
- 文献资源丰富，不容易卡住
- 找工作/申研究生时"有东西可讲"

追热点的风险：
- 你可能并不真正感兴趣，只是为了"发一篇"
- 领域太拥挤，你的贡献可能很渺小
- 热点退去后，你的研究可能迅速失去关注

我认为更好的策略是：在一个你真正感兴趣的方向上，找到和一个前沿技术的"交叉点"。比如你对"睡眠"感兴趣，可以做"睡眠+AI 建模"；你对"情绪记忆"感兴趣，可以做"情绪记忆+LLM 生成内容识别"。

学术训练的核心是学会"提出问题"的能力，而不是"踩中热点"的能力。热点会退潮，但提出好问题的能力不会过时。

你怎么看？欢迎讨论。''',
      'summary': '追热点 vs 做自己感兴趣的研究，附"交叉点"策略建议',
      'authorName': '学术之路',
      'authorRole': '博士生',
      'authorAvatar': '🛤️',
      'createdAt': '12 小时前',
      'tags': ['观点碰撞', '学术训练', '选题策略'],
      'likes': 1456,
      'commentsCount': 198,
      'saves': 789,
      'comments': [
        {
          'author': '大四在读',
          'role': '本科生',
          'avatar': '🎓',
          'text': '作为正在选题的大四学生，这篇文章很及时。我原本想追 RAG 的热点，但导师让我先想清楚自己的研究问题是什么。',
          'time': '10 小时前',
        },
        {
          'author': '已经毕业的',
          'role': '硕士生',
          'avatar': '🎉',
          'text': '过来人建议：选你感兴趣但别人还没做的。不追热点不代表不追前沿，关键是你自己要对那个问题有热情。',
          'time': '8 小时前',
        },
      ],
    },
    {
      'id': 'mp_16',
      'title': 'AI 生成论文配图、摘要、代码——到底应该如何标注贡献？',
      'content': '''最近在学术圈看到一个现象：越来越多的论文中使用了 AI 生成的内容——配图、摘要润色、代码生成、甚至数据分析思路。但目前的学术规范对于"AI 贡献应该如何标注"还没有统一标准。

目前的三种做法：

1. 完全不标注
- 现状：很多论文默认使用，不提及
- 问题：如果审稿人或读者发现，可能被视为学术不端
- 风险：逐渐侵蚀学术信任

2. 在 Acknowledgments 中感谢 AI 工具
- 现状：已有部分顶刊论文这样做
- 问题：模糊，无法区分"辅助"和"独立完成"
- 风险：仍然不够透明

3. 在 Methods 中详细说明 AI 的具体用途
- 现状：少数前沿期刊开始要求
- 优点：最透明，读者可以判断
- 挑战：目前没有统一模板

我的看法：未来学术训练应该包含"AI 贡献标注规范"的教育。不是禁止用 AI，而是学会负责任地使用和透明地标注。

你们实验室对这个问题有明确规定吗？欢迎分享你们的实践。''',
      'summary': 'AI 在学术论文中的贡献标注尚无统一标准，三种做法的利弊分析',
      'authorName': '学术规范讨论',
      'authorRole': '青年教师',
      'authorAvatar': '📜',
      'createdAt': '1 天前',
      'tags': ['观点碰撞', '学术伦理', 'AI贡献'],
      'likes': 1089,
      'commentsCount': 145,
      'saves': 634,
      'comments': [
        {
          'author': '期刊编辑',
          'role': '副主编',
          'avatar': '✏️',
          'text': '我们期刊已经在起草 AI 贡献声明模板了，预计下个月上线。核心原则是：凡是涉及内容生成的 AI 使用都必须声明。',
          'time': '20 小时前',
        },
      ],
    },
  ];

  // ========== 论坛热搜榜 ==========
  static final List<Map<String, dynamic>> hotTopics = [
    {
      'id': 'ht_1',
      'title': 'CoT 真的是在推理，还是在生成解释？',
      'heat': '18.7k',
      'tag': '热',
      'tagColor': 'red',
      'relatedPostId': 'mp_1',
    },
    {
      'id': 'ht_2',
      'title': 'AI 读论文最容易犯的 3 个错误',
      'heat': '15.2k',
      'tag': '热',
      'tagColor': 'red',
      'relatedPostId': 'mp_4',
    },
    {
      'id': 'ht_3',
      'title': 'Claude、ChatGPT、Perplexity 读论文谁更稳？',
      'heat': '13.8k',
      'tag': '新',
      'tagColor': 'blue',
      'relatedPostId': 'mp_6',
    },
    {
      'id': 'ht_4',
      'title': '研究 LLM 幻觉，TruthfulQA 和 HaluEval 差在哪？',
      'heat': '11.4k',
      'tag': '讨论中',
      'tagColor': 'purple',
      'relatedPostId': 'mp_7',
    },
    {
      'id': 'ht_5',
      'title': 'Transformer 论文为什么影响这么大？',
      'heat': '10.1k',
      'tag': '热',
      'tagColor': 'red',
      'relatedPostId': 'mp_10',
    },
    {
      'id': 'ht_6',
      'title': '从一篇睡眠论文延展出情绪记忆选题',
      'heat': '8.9k',
      'tag': '新',
      'tagColor': 'blue',
      'relatedPostId': 'mp_2',
    },
    {
      'id': 'ht_7',
      'title': 'AI 会让会提问的人更强吗？',
      'heat': '8.3k',
      'tag': '讨论中',
      'tagColor': 'purple',
      'relatedPostId': 'mp_13',
    },
    {
      'id': 'ht_8',
      'title': '本科生做科研，选热点还是选可执行？',
      'heat': '7.6k',
      'tag': null,
      'tagColor': null,
      'relatedPostId': 'mp_15',
    },
    {
      'id': 'ht_9',
      'title': '用大模型做心理学实验，被试到底是谁？',
      'heat': '6.8k',
      'tag': '新',
      'tagColor': 'blue',
      'relatedPostId': 'mp_14',
    },
    {
      'id': 'ht_10',
      'title': 'AI 生成论文配图，怎么标注贡献？',
      'heat': '5.9k',
      'tag': null,
      'tagColor': null,
      'relatedPostId': 'mp_16',
    },
  ];
}
