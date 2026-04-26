#!/usr/bin/env dart
/// PDF 提取工具 - 从 arXiv 下载论文并提取文本和图片
///
/// 使用方法:
///   dart run scripts/extract_arxiv_pdf.dart <arxiv_id>
///   例如：dart run scripts/extract_arxiv_pdf.dart 2306.14753

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  print('╔════════════════════════════════════════════════════════╗');
  print('║         arXiv PDF 提取工具                              ║');
  print('╚════════════════════════════════════════════════════════╝\n');

  if (args.isEmpty) {
    print('❌ 请提供 arXiv ID');
    print('');
    print('用法:');
    print('  dart run scripts/extract_arxiv_pdf.dart <arxiv_id>');
    print('');
    print('示例:');
    print('  dart run scripts/extract_arxiv_pdf.dart 2306.14753');
    exit(1);
  }

  final arxivId = args.first;
  final outputDir = 'pdf_output/$arxivId';

  print('📥 arXiv ID: $arxivId');
  print('📁 输出目录：$outputDir\n');

  // 创建输出目录
  final dir = Directory(outputDir);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  // 下载 PDF
  final pdfUrl = 'https://arxiv.org/pdf/$arxivId.pdf';
  print('🔗 下载：$pdfUrl');

  try {
    final response = await http.get(Uri.parse(pdfUrl));

    if (response.statusCode != 200) {
      print('❌ 下载失败：${response.statusCode}');
      exit(1);
    }

    // 保存 PDF
    final pdfPath = '$outputDir/$arxivId.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(response.bodyBytes);
    print('✅ PDF 已下载：$pdfPath (${response.bodyBytes.length ~/ 1024} KB)\n');

    // 提示用户使用 Python 脚本提取
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    print('📌 下一步：使用 Python 提取文本和图片\n');
    print('运行以下命令:');
    print('');
    print('  python scripts/extract_arxiv_images.py $arxivId\n');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  } catch (e) {
    print('❌ 下载出错：$e');
    exit(1);
  }
}
