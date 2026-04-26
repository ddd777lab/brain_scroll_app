import 'package:flutter/material.dart';
import '../pages/article_detail_page.dart';
import '../theme/app_colors.dart';

class XiaohongshuCard extends StatelessWidget {
  final Map<String, dynamic> paper;

  const XiaohongshuCard({
    super.key,
    required this.paper,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ArticleDetailPage(),
            settings: RouteSettings(arguments: paper),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图区域 - 使用动态宽高比
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: paper['coverAspectRatio'] ?? 1.0,
                child: _buildCoverImage(),
              ),
            ),
            // 内容区
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    paper['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // 标签
                  if (paper['tags'] != null && (paper['tags'] as List).isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: (paper['tags'] as List<String>).take(2).map((tag) {
                        final color = _getMorandiColorForTag(tag);
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: color.withOpacity(0.5)),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  if (paper['tags'] == null || (paper['tags'] as List).isEmpty)
                    const SizedBox(height: 6),
                  const SizedBox(height: 8),
                  // 用户信息和点赞
                  Row(
                    children: [
                      // 头像
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: AppColors.border,
                      ),
                      const SizedBox(width: 6),
                      // 用户名
                      Expanded(
                        child: Text(
                          paper['author'] ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 点赞数
                      const Icon(
                        Icons.favorite_border,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${paper['likes'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    // 1. 优先使用 coverImagePath
    if (paper['coverImagePath'] != null && paper['coverImagePath'].isNotEmpty) {
      return Image.asset(
        paper['coverImagePath'],
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTemplateDesign(),
      );
    }

    // 2. 如果有网络图片，使用网络图片
    if (paper['coverImage'] != null && paper['coverImage'].isNotEmpty) {
      return Image.network(
        paper['coverImage'],
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTemplateDesign(),
      );
    }

    // 3. 否则使用模板设计
    return _buildTemplateDesign();
  }

  Widget _buildTemplateDesign() {
    final journal = paper['journal'] ?? 'Journal';
    final title = paper['title'] ?? '';
    final gradient = _getGradientForJournal(journal);
    final icon = _getIconForSubject(_getSubjectFromJournal(journal));

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // 背景装饰图案
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                icon,
                size: 150,
                color: Colors.white,
              ),
            ),
          ),
          // 主要内容
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 期刊标签
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      journal,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 学科图标
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 标题关键词（截取部分）
                  if (title.isNotEmpty)
                    Flexible(
                      child: Text(
                        _getKeywordsFromTitle(title),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // 左下角角标
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '文献解读',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getKeywordsFromTitle(String title) {
    // 从标题中提取关键词（简单实现：取前几个词）
    final words = title.split(' ');
    if (words.length <= 6) return title;
    return '${words.take(6).join(' ')}...';
  }

  IconData _getIconForSubject(String subject) {
    switch (subject) {
      case 'neuroscience':
        return Icons.psychology; // 脑科学
      case 'psychology':
        return Icons.self_improvement; // 心理学
      case 'cognitive':
        return Icons.lightbulb; // 认知科学
      case 'medicine':
        return Icons.medical_services; // 医学
      case 'biology':
        return Icons.eco; // 生物学
      case 'physics':
        return Icons.science; // 物理学
      case 'social':
        return Icons.groups; // 社会科学
      default:
        return Icons.menu_book; // 默认
    }
  }

  String _getSubjectFromJournal(String journal) {
    final journalLower = journal.toLowerCase();
    if (journalLower.contains('neuro')) return 'neuroscience';
    if (journalLower.contains('psych')) return 'psychology';
    if (journalLower.contains('cognit')) return 'cognitive';
    if (journalLower.contains('med')) return 'medicine';
    if (journalLower.contains('biol')) return 'biology';
    if (journalLower.contains('phys')) return 'physics';
    if (journalLower.contains('social')) return 'social';
    if (journalLower.contains('nature')) return 'neuroscience';
    if (journalLower.contains('science')) return 'cognitive';
    if (journalLower.contains('cell')) return 'biology';
    return 'default';
  }

  Gradient _getGradientForJournal(String journal) {
    // 根据期刊名称匹配特定配色
    final journalLower = journal.toLowerCase();

    // 知名期刊特定配色
    if (journalLower.contains('nature')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)], // Nature 橙红色
      );
    }
    if (journalLower.contains('science')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A90D9), Color(0xFF365490)], // Science 蓝色
      );
    }
    if (journalLower.contains('cell')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)], // Cell 紫色
      );
    }
    if (journalLower.contains('pnas')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF667eea), Color(0xFF764ba2)], // PNAS 紫色
      );
    }
    if (journalLower.contains('neuron')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5F72BC), Color(0xFF9B59B6)], // Neuron 蓝紫色
      );
    }

    // 其他期刊使用多彩渐变
    final colors = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFF30cfd0), const Color(0xFF330867)],
    ];

    final index = journal.length % colors.length;
    final selectedColors = colors[index];

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: selectedColors,
    );
  }

  // 根据标签内容返回莫兰迪色系
  Color _getMorandiColorForTag(String tag) {
    final hash = tag.hashCode;
    final colors = [
      AppColors.morandiBlue,
      AppColors.morandiPink,
      AppColors.morandiPurple,
      AppColors.morandiGreen,
      AppColors.morandiBrown,
      AppColors.morandiBeige,
    ];
    return colors[hash.abs() % colors.length];
  }
}
