import 'package:flutter/material.dart';

/// Brain Scroll 应用主题色系统
/// 整体风格：轻盈、简洁、年轻化，类似小红书/信息流产品
class AppColors {
  // ========== 全局背景色 ==========
  // 米白色系，柔和温暖，适合长时间阅读
  static const Color background = Color(0xFFFAF8F3);

  // 页面内区域背景（如卡片间隔）
  static const Color surfaceBackground = Color(0xFFF5F2ED);

  // ========== 卡片背景 ==========
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ========== 主题色（浅天蓝） ==========
  static const Color primary = Color(0xFFA9D8F5);
  static const Color primaryLight = Color(0xFFD4EDFF);
  static const Color primaryDark = Color(0xFF4A90B8);
  static const Color primaryBackground = Color(0xFFEAF6FD);
  static const Color primaryButtonText = Color(0xFF1B3A4B);

  // ========== 文本颜色 ==========
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textPlaceholder = Color(0xFFCCCCCC);

  // ========== 分割线/边框 ==========
  static const Color divider = Color(0xFFE5E5E5);
  static const Color border = Color(0xFFEFEFEF);

  // ========== 莫兰迪色系（用于标签、装饰） ==========
  // 灰蓝
  static const Color morandiBlue = Color(0xFFA8B8C8);
  static const Color morandiBlueLight = Color(0xFFD4DCE4);

  // 豆沙粉
  static const Color morandiPink = Color(0xFFD4A5A5);
  static const Color morandiPinkLight = Color(0xFFE8D0D0);

  // 雾霾紫
  static const Color morandiPurple = Color(0xFFB5A8C4);
  static const Color morandiPurpleLight = Color(0xFFDDD6E4);

  // 鼠尾草绿
  static const Color morandiGreen = Color(0xFFA8B89C);
  static const Color morandiGreenLight = Color(0xFFD4DCC8);

  // 奶茶棕
  static const Color morandiBrown = Color(0xFFC4B5A8);
  static const Color morandiBrownLight = Color(0xFFE4DCD4);

  // 米杏色
  static const Color morandiBeige = Color(0xFFD4C4B0);
  static const Color morandiBeigeLight = Color(0xFFE8E0D4);

  // ========== 功能色 ==========
  static const Color error = Color(0xFFEB5757);
  static const Color warning = Color(0xFFF2994A);
  static const Color success = Color(0xFF27AE60);
  static const Color info = Color(0xFF2D9CDB);

  // ========== 封面模板渐变色系 ==========
  // 每个色系包含起始色和结束色，用于渐变背景
  static const List<List<Color>> coverGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],  // 橙红（Nature）
    [Color(0xFF4A90D9), Color(0xFF365490)],  // 蓝（Science）
    [Color(0xFF9B59B6), Color(0xFF8E44AD)],  // 紫（Cell）
    [Color(0xFF667eea), Color(0xFF764ba2)],  // 蓝紫（PNAS）
    [Color(0xFF5F72BC), Color(0xFF9B59B6)],  // 蓝紫（Neuron）
    [Color(0xFFA8B8C8), Color(0xFFB5A8C4)],  // 莫兰迪灰蓝紫
    [Color(0xFFD4A5A5), Color(0xFFC4B5A8)],  // 莫兰迪粉棕
    [Color(0xFFA8B89C), Color(0xFFB8C8A8)],  // 莫兰迪绿
  ];
}
