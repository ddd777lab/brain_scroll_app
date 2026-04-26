#!/usr/bin/env dart
/// 论文封面生成脚本
///
/// 功能：
/// 1. 从 arXiv 搜索论文
/// 2. 自动生成生图 Prompt
/// 3. 调用通义万相生成封面
/// 4. 保存到本地 assets 目录

import 'dart:convert';
import 'dart:io';
import 'package:brain_scroll/services/tongyi_image_service.dart';
import 'package:brain_scroll/services/arxiv_service.dart';

void main(List<String> args) async {
  print('╔════════════════════════════════════════════════════════╗');
  print('║         论文封面自动生成工具                            ║');
  print('╚════════════════════════════════════════════════════════╝\n');

  // 从环境变量读取 API Key
  final apiKey = Platform.environment['TONGYI_API_KEY'];

  // 开发测试用（临时 fallback，正式使用时请删除 fallback 直接退出）
  const testApiKey = 'sk-3929951e57bb4fbfbfa0ecde47e777de';
  final effectiveApiKey = (apiKey == null || apiKey.isEmpty) ? testApiKey : apiKey;

  print('🔑 API Key: ${effectiveApiKey.substring(0, 8)}...');
  if (apiKey == null || apiKey.isEmpty) {
    print('⚠️  未检测到环境变量，使用测试 API Key');
    print('   建议设置：\$env:TONGYI_API_KEY="你的 API Key"');
    print('');
  }

  // 解析命令行参数
  String query = 'neural population coding';
  int maxResults = 5;

  for (var arg in args) {
    if (arg.startsWith('--query=')) {
      query = arg.substring('--query='.length);
    } else if (arg.startsWith('--count=')) {
      maxResults = int.parse(arg.substring('--count='.length));
    }
  }

  print('🔍 搜索关键词：$query');
  print('📊 获取论文数量：$maxResults 篇\n');

  final arxivService = ArxivService();
  final imageService = TongyiImageService(apiKey: effectiveApiKey);

  print('🚀 开始从 arXiv 获取论文...\n');

  // 搜索论文
  final papers = await arxivService.search(
    query: query,
    maxResults: maxResults,
  );

  if (papers.isEmpty) {
    print('❌ 未找到相关论文');
    exit(1);
  }

  print('✅ 找到 ${papers.length} 篇论文\n');

  // 确保输出目录存在
  final outputDir = Directory('assets/paper_images');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
    print('📁 创建目录：${outputDir.path}\n');
  }

  // 生成结果列表
  final results = <Map<String, dynamic>>[];

  // 批量生成封面
  for (var i = 0; i < papers.length; i++) {
    final paper = papers[i];
    final progress = '${i + 1}/${papers.length}';

    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final displayTitle = paper.title.length > 50 ? '${paper.title.substring(0, 50)}...' : paper.title;
    print('📄 [$progress] $displayTitle\n');

    // 生成封面
    final savePath = '${outputDir.path}/cover_${paper.id.split('/').last}.png';
    final imagePath = await imageService.generateCoverImage(
      paperTitle: paper.title,
      journal: paper.readableJournal,
      abstract: paper.summary,
      savePath: savePath,
    );

    // 构建 App 数据
    final paperData = paper.toJson();

    if (imagePath != null) {
      paperData['coverImagePath'] = 'assets/paper_images/cover_${paper.id.split('/').last}.png';
      print('✅ 封面生成成功：$imagePath');
    } else {
      print('⚠️  封面生成失败，使用默认模板');
    }

    results.add(paperData);

    // 等待一下，避免请求过快
    if (i < papers.length - 1) {
      print('⏳ 等待 2 秒...\n');
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  // 保存结果
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('💾 保存结果...\n');

  final outputFile = File('scripts/output/papers_${DateTime.now().millisecondsSinceEpoch}.json');
  if (!await outputFile.parent.exists()) {
    await outputFile.parent.create(recursive: true);
  }

  await outputFile.writeAsString(jsonEncode(results));
  print('✅ 结果已保存到：${outputFile.path}\n');

  // 打印汇总
  print('╔════════════════════════════════════════════════════════╗');
  print('║                    生成完成！                           ║');
  print('╠════════════════════════════════════════════════════════╣');
  print('║  论文数量：${results.length} 篇                            ║');
  final successCount = results.where((p) => p['coverImagePath'] != null).length;
  print('║  成功生成：$successCount 个封面                        ║');
  print('║  输出文件：${outputFile.path}                   ║');
  print('╚════════════════════════════════════════════════════════╝\n');

  print('📱 下一步：');
  print('   1. 将生成的封面图片添加到 Flutter 项目');
  print('   2. 更新 lib/data/mock_data.dart 中的论文数据');
  print('   3. 运行 flutter run 查看效果\n');
}

/// 快捷命令示例：
///
/// # 使用默认设置
/// dart run scripts/generate_covers.dart
///
/// # 指定 API Key
/// dart run scripts/generate_covers.dart --api-key=sk-xxx
///
/// # 指定搜索词和数量
/// dart run scripts/generate_covers.dart --query="deep learning" --count=10
