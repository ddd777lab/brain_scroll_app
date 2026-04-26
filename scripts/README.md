# 论文封面自动生成工具

## 功能概述

这个工具可以：
1. 从 arXiv API 获取论文元数据
2. 自动构建生图 Prompt
3. 调用通义万相 API 生成封面图片
4. 保存到本地 assets 目录

---

## 前置准备

### 1. 获取通义万相 API Key

1. 访问 https://dashscope.console.aliyun.com/
2. 登录阿里云账号
3. 开通"通义万相"服务
4. 创建 API Key

### 2. 配置 API Key

**方式 A：命令行参数**
```bash
dart run scripts/generate_covers.dart --api-key=你的 API_KEY
```

**方式 B：环境变量**
```bash
# Windows PowerShell
$env:TONGYI_API_KEY="你的 API_KEY"
dart run scripts/generate_covers.dart

# 或使用 .env 文件（推荐）
```

---

## 使用方法

### 快速开始

```bash
# 进入项目目录
cd D:/桌面/brain_scroll_app

# 运行生成脚本
dart run scripts/generate_covers.dart
```

脚本会提示你输入：
- 搜索关键词（例如：`neural population coding`）
- 需要获取的论文数量（默认 5 篇）

### 示例流程

```
╔════════════════════════════════════════════════════════╗
║         论文封面自动生成工具                            ║
╚════════════════════════════════════════════════════════╝

🔍 请输入搜索关键词（例如：neural population coding）:
> child social cognition

📊 需要获取多少篇论文？（默认 5 篇）:
> 3

🚀 开始从 arXiv 获取论文...

✅ 找到 3 篇论文

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 [1/3] Young children understand how social...

📝 生成 Prompt: 科学研究，认知科学、儿童发展主题，柔和粉蓝、心理学风格...
✅ 图片生成成功
💾 图片已保存到：assets/paper_images/cover_xxx.png

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 [2/3] ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💾 保存结果...
✅ 结果已保存到：scripts/output/papers_xxx.json
```

---

## 输出文件

### 图片文件
```
assets/paper_images/
├── cover_2304.12345.png  # arXiv ID
├── cover_2305.67890.png
└── ...
```

### 数据文件
```json
[
  {
    "id": "2304.12345",
    "arxivId": "http://arxiv.org/abs/2304.12345",
    "title": "论文标题",
    "summary": "摘要...",
    "journal": "q-bio.NC",
    "publishDate": "2023-04-15",
    "authors": "Zhang, S., Li, W.",
    "pdfUrl": "http://arxiv.org/pdf/2304.12345",
    "coverImagePath": "assets/paper_images/cover_2304.12345.png"
  }
]
```

---

## 自定义 Prompt 模板

编辑 `lib/services/tongyi_image_service.dart` 中的 `_buildPrompt()` 方法：

```dart
String _buildPrompt(...) {
  return '''
科学论文封面图，{keywords}主题，{style}风格，
极简主义设计，干净背景，高分辨率，
适合移动端展示，专业学术感，
留白空间用于添加文字，16:9 比例构图
''';
}
```

---

## 常见问题

### Q: API 调用失败怎么办？

**A:** 检查以下几点：
1. API Key 是否正确
2. 网络连接是否正常
3. 账户是否有剩余额度

### Q: 生成的图片不符合预期？

**A:** 调整 Prompt 模板：
- 添加更多风格描述词（如"赛博朋克"、"水墨风"等）
- 修改尺寸参数（`size: '1024*1024'` 改为 `'1280*720'`）
- 调整 `seed` 值重新生成

### Q: 批量生成时中途失败？

**A:** 脚本已保存中间结果，查看 `scripts/output/` 目录下的 JSON 文件，已生成的图片不会丢失。

---

## 费用说明

通义万相 API 价格（参考）：
- 新用户：免费试用额度
- 之后：约 ¥0.05-0.1/张

建议：
1. 先用免费额度测试效果
2. 确认满意后再批量生成
3. 生成的图片可重复使用

---

## 下一步

生成完成后：

1. **检查图片质量**
   ```bash
   # 查看生成的图片
   open assets/paper_images/
   ```

2. **更新 App 数据**
   将 `scripts/output/papers_xxx.json` 中的数据复制到 `lib/data/mock_data.dart`

3. **运行 App 查看效果**
   ```bash
   flutter run -d chrome
   ```

---

## 技术支持

- 通义万相文档：https://help.aliyun.com/zh/dashscope/
- arXiv API 文档：https://arxiv.org/help/api
