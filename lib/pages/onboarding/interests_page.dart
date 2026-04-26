import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_onboarding_service.dart';
import '../../widgets/onboarding/tag_selector.dart';
import 'journals_page.dart';

/// 兴趣领域选择页面
class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> _selectedInterests = [];

  // 预设兴趣领域
  final List<String> _interests = [
    '经济学',
    '数学',
    '物理学',
    '医学',
    '航空航天',
    '心理学',
    '计算机',
    '神经科学',
    '语言学',
    '哲学',
    '教育学',
    '社会学',
    '生物学',
    '化学',
    '人工智能',
    '数据科学',
    '认知科学',
    '机器学习',
    '量子物理',
    '遗传学',
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF4ADE80); // 薄荷绿

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 进度指示
              _buildProgressIndicator(),
              const SizedBox(height: 32),
              // 标题
              const Text(
                '你感兴趣的领域',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '选择你感兴趣的领域，我们会推荐相关内容',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),
              // 标签选择器
              Expanded(
                child: TagSelector(
                  tags: _interests,
                  selectedTags: _selectedInterests,
                  onSelectionChanged: (tags) {
                    setState(() {
                      _selectedInterests = tags;
                    });
                  },
                  addNewLabel: '添加其他领域',
                  selectedColor: primaryColor,
                ),
              ),
              // 底部按钮
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressDot(true, true),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        _buildProgressDot(true, true),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4ADE80),
                  const Color(0xFF4ADE80),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        _buildProgressDot(false, false),
        Expanded(
          child: Container(
            height: 2,
            color: Colors.grey[300],
          ),
        ),
        _buildProgressDot(false, false),
      ],
    );
  }

  Widget _buildProgressDot(bool isActive, bool isCompleted) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive || isCompleted ? const Color(0xFF4ADE80) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // 保存数据
              context.read<OnboardingService>().updateInterests(_selectedInterests);
              // 跳转到期刊选择页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const JournalsPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ADE80),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '下一步',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // 保存数据（可能为空）
            context.read<OnboardingService>().updateInterests(_selectedInterests);
            // 跳转到期刊选择页面
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const JournalsPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[500],
          ),
          child: const Text('跳过'),
        ),
      ],
    );
  }
}
