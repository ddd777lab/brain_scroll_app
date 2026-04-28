import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_onboarding_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/onboarding/searchable_dropdown.dart';
import 'interests_page.dart';

/// 学术背景填写页面
class AcademicBackgroundPage extends StatefulWidget {
  const AcademicBackgroundPage({super.key});

  @override
  State<AcademicBackgroundPage> createState() => _AcademicBackgroundPageState();
}

class _AcademicBackgroundPageState extends State<AcademicBackgroundPage> {
  String? _selectedMajor;
  String? _selectedDegree;
  int _researchExperience = 50;

  // 示例专业列表
  final List<String> _majors = [
    '心理学',
    '计算机科学',
    '经济学',
    '数学',
    '物理学',
    '医学',
    '社会学',
    '教育学',
    '神经科学',
    '生物学',
    '化学',
    '语言学',
    '哲学',
    '管理学',
    '法学',
    '工程学',
    '数据科学',
    '人工智能',
    '认知科学',
    '生物医学工程',
  ];

  // 学位选项
  final List<String> _degrees = ['本科', '硕士', '博士', '博士后', '其他'];

  @override
  Widget build(BuildContext context) {

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
                '我们需要更了解你',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '填写以下信息，帮助我们为你推荐更相关的内容',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 40),
              // 表单内容
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 专业选择
                      SearchableDropdown(
                        value: _selectedMajor,
                        items: _majors,
                        labelText: '你的专业',
                        hintText: '请选择或搜索专业',
                        onChanged: (value) {
                          setState(() {
                            _selectedMajor = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // 学位选择
                      Text(
                        '你的学位',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDegreeSelector(),
                      const SizedBox(height: 32),
                      // 科研经历
                      Text(
                        '相关科研经历',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildResearchExperienceSlider(),
                    ],
                  ),
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
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
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
        color: isActive || isCompleted ? AppColors.primaryDark : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDegreeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _degrees.map((degree) {
        final isSelected = _selectedDegree == degree;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDegree = degree;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? AppColors.primaryDark : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: Text(
              degree,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResearchExperienceSlider() {
    final experienceLabels = ['刚起步', '有一些经验', '经验丰富', '资深学者'];
    final experienceIndex = (_researchExperience / 33).clamp(0, 3).floor();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primaryDark,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: AppColors.primaryDark,
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: _researchExperience.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      _researchExperience = value.toInt();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              experienceLabels[experienceIndex.clamp(0, 3)],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
              ),
            ),
            Text(
              '$_researchExperience',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
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
              // 必填项校验
              if (_selectedMajor == null || _selectedMajor!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请选择您的专业'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              if (_selectedDegree == null || _selectedDegree!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('请选择您的学位'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              // 保存数据
              context.read<OnboardingService>().updateAcademicBackground(
                major: _selectedMajor,
                degree: _selectedDegree,
                researchExperience: _researchExperience,
              );
              // 跳转到兴趣领域页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InterestsPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primaryButtonText,
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
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[500],
          ),
          child: const Text('返回'),
        ),
      ],
    );
  }
}
