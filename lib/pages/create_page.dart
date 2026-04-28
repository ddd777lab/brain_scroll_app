import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _doiController = TextEditingController();
  final TextEditingController _newTopicController = TextEditingController();

  // 已添加的话题
  final List<String> _topics = [];
  // 建议话题
  final List<String> _suggestedTopics = [
    '#认知科学',
    '#神经科学',
    '#发展心理学',
    '#PNAS',
    '#Nature',
    '#Science',
    '#机器学习',
    '#肠脑轴',
  ];

  bool get _hasDoi => _doiController.text.isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _doiController.dispose();
    _newTopicController.dispose();
    super.dispose();
  }

  void _publish() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final doi = _doiController.text.trim();

    // 验证
    if (title.isEmpty) {
      _showHint('请输入标题');
      return;
    }
    if (content.isEmpty) {
      _showHint('请输入正文内容');
      return;
    }
    if (_topics.isEmpty) {
      _showHint('请至少添加一个话题标签');
      return;
    }
    if (doi.isNotEmpty && !doi.startsWith('10.') && !doi.startsWith('http')) {
      _showHint('请输入有效的 DOI 或 URL 链接');
      return;
    }

    // 发布成功
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('发布成功'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHint(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCameraBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '选择图片来源',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('从相册选择'),
                  onTap: () {
                    Navigator.pop(context);
                    _showHint('相册选择功能开发中');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('拍照拍摄'),
                  onTap: () {
                    Navigator.pop(context);
                    _showHint('相机功能开发中');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_search_outlined),
                  title: const Text('从图表选择'),
                  onTap: () {
                    Navigator.pop(context);
                    _showHint('图表选择功能开发中');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTopic(String topic) {
    setState(() {
      if (!_topics.contains(topic)) {
        _topics.add(topic);
      }
    });
  }

  void _removeTopic(String topic) {
    setState(() {
      _topics.remove(topic);
    });
  }

  void _showAddTopicDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('添加话题'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newTopicController,
                decoration: InputDecoration(
                  hintText: '输入话题，如 #机器学习',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: '# ',
                  prefixStyle: TextStyle(color: AppColors.primaryDark),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  if (value.startsWith('#')) {
                    _newTopicController.value =
                        _newTopicController.value.copyWith(
                      text: value.substring(1),
                      selection: TextSelection.collapsed(
                          offset: _newTopicController.text.length - 1),
                    );
                  }
                },
                autofocus: true,
                maxLength: 20,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '推荐话题',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedTopics
                    .where((t) => !_topics.contains(t))
                    .take(6)
                    .map((t) => ActionChip(
                          label: Text(t),
                          backgroundColor: AppColors.primaryBackground,
                          labelStyle: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 13,
                          ),
                          onPressed: () {
                            _addTopic(t);
                            Navigator.pop(context);
                            _newTopicController.clear();
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final topic = _newTopicController.text.trim();
                if (topic.isNotEmpty) {
                  _addTopic('#$topic');
                  _newTopicController.clear();
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryButtonText,
              ),
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _linkDoi() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('关联文献'),
          content: TextField(
            controller: _doiController,
            decoration: InputDecoration(
              hintText: '粘贴 DOI 或文献链接',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            maxLines: 2,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _doiController.clear();
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final doi = _doiController.text.trim();
                if (doi.isNotEmpty) {
                  // 验证 DOI 或 URL
                  if (!doi.startsWith('10.') &&
                      !doi.startsWith('http') &&
                      !doi.startsWith('https')) {
                    _showHint('请输入有效的 DOI (10.xxxx/...) 或 URL');
                    return;
                  }
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryButtonText,
              ),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布内容'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _publish,
            child: const Text(
              '发布',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题输入
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '输入标题',
                hintStyle:
                    TextStyle(color: Colors.grey[400], fontSize: 18),
                border: InputBorder.none,
                counterText: '',
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              maxLength: 50,
            ),
            const Divider(),
            // 正文输入
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: '分享你的科研解读...\n\n可以包括：\n• 研究背景和问题\n• 实验方法和设计\n• 核心发现\n• 你的思考和点评',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                counterText: '',
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: 20,
            ),
            const SizedBox(height: 24),
            // 关联文献 — DOI/URL 输入
            GestureDetector(
              onTap: _linkDoi,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _hasDoi
                      ? AppColors.primaryBackground
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasDoi
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _hasDoi ? Icons.link : Icons.link_outlined,
                          color: _hasDoi
                              ? AppColors.primaryDark
                              : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '关联文献',
                          style: TextStyle(
                            color: _hasDoi
                                ? AppColors.primaryDark
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (_hasDoi)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _doiController.clear();
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.primaryDark,
                            ),
                          ),
                      ],
                    ),
                    if (_hasDoi) ...[
                      const SizedBox(height: 8),
                      Text(
                        _doiController.text,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      Text(
                        '粘贴 DOI 或文献链接',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 添加图片
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '添加图片',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo_outlined,
                      size: 20, color: AppColors.primaryDark),
                  onPressed: _showCameraBottomSheet,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 图片占位
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: _showCameraBottomSheet,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined,
                        color: Colors.grey),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // 话题标签
            Text(
              '添加话题',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._topics.map((topic) => Chip(
                      label: Text(topic),
                      backgroundColor: AppColors.primaryBackground,
                      labelStyle: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primaryDark,
                      ),
                      onDeleted: () => _removeTopic(topic),
                    )),
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, size: 16),
                      const SizedBox(width: 4),
                      const Text('+ 添加话题'),
                    ],
                  ),
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                  onPressed: _showAddTopicDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
