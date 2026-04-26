# 从 PDF 文献中提取配图的方法

由于网络环境限制，以下是几种提取 PDF 配图的方法：

## 方法 1：使用 Adobe Acrobat Reader（最简单）

1. 用 Adobe Acrobat Reader 打开 PDF
2. 点击任意图片右键 → "Save Image" 或 "复制图片"
3. 保存到 `assets/paper_images/` 目录

## 方法 2：使用在线工具

1. 访问 https://smallpdf.com/pdf-to-jpg 或 https://ilovepdf.com/zh-cn/pdf_to_jpg
2. 上传 PDF 文件
3. 下载提取的图片
4. 保存到 `assets/paper_images/` 目录

## 方法 3：使用 Python（需要安装库）

```bash
pip install PyMuPDF
```

然后运行项目中的 `extract_pdf_images.py` 脚本：

```bash
cd D:/桌面/brain_scroll_app
python extract_pdf_images.py
```

## 方法 4：从论文官网下载（推荐）

这篇论文发表于 eLife，可以直接从官网下载配图：

1. 访问论文页面
2. 找到 "Figures" 部分
3. 下载 Figure 1（通常是最具代表性的图）
4. 重命名为 `cover_image.png` 并保存到 `assets/paper_images/`

## 推荐的封面图片选择

对于这篇关于神经生理学和 fMRI 的研究论文，建议选择：

- **Figure 1**: 实验设计示意图或代表性结果图
- **Graphical Abstract**: 如果有，通常是最能概括研究的图

## 保存后的配置

将图片保存到 `assets/paper_images/` 目录后，更新 `lib/data/mock_data.dart`:

```dart
{
  'id': '9',
  'title': 'Representational geometries reveal differential effects...',
  'journal': 'eLife',
  'coverImagePath': 'assets/paper_images/cover_image.png', // 图片路径
  ...
}
```

然后重启应用即可看到真实图片效果。
