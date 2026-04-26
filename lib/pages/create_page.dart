import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

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
            onPressed: () {
              // TODO: 发布逻辑
              Navigator.pop(context);
            },
            child: const Text(
              '发布',
              style: TextStyle(
                color: Colors.black,
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
              decoration: InputDecoration(
                hintText: '输入标题',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                border: InputBorder.none,
                counterText: '',
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            const Divider(),
            // 正文输入
            TextField(
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
            // 添加文献链接
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.link, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '关联文献',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '粘贴 DOI 或文献链接',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 添加图片
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildImagePlaceholder(),
                _buildImagePlaceholder(),
                _buildImagePlaceholder(),
              ],
            ),
            const SizedBox(height: 24),
            // 标签选择
            Text(
              '添加话题',
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildChip('#认知科学'),
                _buildChip('#神经科学'),
                _buildChip('#发展心理学'),
                _buildChip('#PNAS'),
                _buildChip('+ 添加话题'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
      onDeleted: label != '+ 添加话题' ? () {} : null,
    );
  }
}
