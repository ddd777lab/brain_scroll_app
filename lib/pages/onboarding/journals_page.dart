import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_onboarding_service.dart';
import '../../main.dart';

/// 常读期刊选择页面
class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _selectedJournals = [];
  List<String> _suggestions = [];
  bool _isShowingSuggestions = false;

  // 预设期刊列表
  final List<String> _journals = [
    '心理学报',
    'Nature',
    'Science',
    'PNAS',
    'Psychological Science',
    'Journal of Experimental Psychology',
    'Nature Human Behaviour',
    'Neuron',
    'Cell',
    'The Lancet',
    'JAMA',
    'Physical Review Letters',
    'Journal of Neuroscience',
    'Cognition',
    'Trends in Cognitive Sciences',
    'Annual Review of Psychology',
    'Developmental Science',
    'Child Development',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _suggestions = [];
      } else {
        _suggestions = _journals
            .where((j) => j.toLowerCase().contains(query.toLowerCase()))
            .where((j) => !_selectedJournals.contains(j))
            .toList();
      }
    });
  }

  void _addJournal(String journal) {
    if (!_selectedJournals.contains(journal)) {
      setState(() {
        _selectedJournals.add(journal);
        _controller.clear();
        _suggestions = [];
      });
    }
  }

  void _removeJournal(String journal) {
    setState(() {
      _selectedJournals.remove(journal);
    });
  }

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
                '你常阅读的期刊',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '选择你常读的期刊，获取最新研究动态',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),
              // 搜索框
              _buildSearchBox(primaryColor),
              const SizedBox(height: 20),
              // 已选期刊
              if (_selectedJournals.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedJournals.map((journal) {
                    return Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                journal,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => _removeJournal(journal),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: primaryColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
              // 建议列表
              if (_isShowingSuggestions && _suggestions.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final journal = _suggestions[index];
                      return ListTile(
                        dense: true,
                        title: Text(journal),
                        trailing: const Icon(Icons.add_circle_outline),
                        onTap: () => _addJournal(journal),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildSearchBox(Color primaryColor) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: '搜索期刊',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _suggestions = [];
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _isShowingSuggestions = value.isNotEmpty;
            });
            _filterSuggestions(value);
          },
        ),
        if (_isShowingSuggestions && _suggestions.isEmpty && _controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '没有找到匹配的期刊',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ),
      ],
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
        _buildProgressDot(true, false),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 保存数据
                  context.read<OnboardingService>().updateJournals(_selectedJournals);
                  // 完成 onboarding
                  context.read<OnboardingService>().completeOnboarding();
                  // 跳转到主应用容器（带底部导航）
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainScaffold()),
                    (route) => false,
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
                  '完成',
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
                context.read<OnboardingService>().updateJournals(_selectedJournals);
                // 完成 onboarding
                context.read<OnboardingService>().completeOnboarding();
                // 跳转到主应用容器（带底部导航）
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainScaffold()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[500],
              ),
              child: const Text('跳过'),
            ),
          ],
        ),
      ),
    );
  }
}
