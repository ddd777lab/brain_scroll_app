# PDF Handler Skill

## 功能说明

此 skill 用于帮助 Codex 处理 PDF 文件，包括：
- 从 arXiv 下载论文 PDF
- 从 PDF 提取文本内容
- 从 PDF 提取图片/图表（如果没有嵌入图片，自动渲染页面为 PNG）
- 解析学术论文 PDF 结构
- 批量处理多个 PDF 文件

## 快速使用（推荐）

### 一键下载并提取（PowerShell）

```powershell
# 步骤 1: 下载 PDF
cd "D:\桌面\brain_scroll_app"
"D:\online installer\flutter\bin\dart.bat" run scripts/extract_arxiv_pdf.dart 2306.14753

# 步骤 2: 提取文本和图片
python scripts/extract_arxiv_images.py 2306.14753
```

### 或者使用批处理（一键完成）

```powershell
scripts\extract_pdf.bat 2306.14753
```

输出目录：`pdf_output/2306.14753/`

---

## 使用方法

### 1. 提取 PDF 文本内容

```bash
# 安装依赖
pip install pymupdf4llm

# 提取 PDF 文本
pymupdf4llm.to_markdown("路径/到/文件.pdf") > output.md
```

### 2. Python 脚本方式

```python
import fitz  # PyMuPDF
import pymupdf4llm

# 方法 1: 提取纯文本
def extract_text_from_pdf(pdf_path):
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text()
    doc.close()
    return text

# 方法 2: 提取为 Markdown（保留格式）
def extract_markdown_from_pdf(pdf_path):
    return pymupdf4llm.to_markdown(pdf_path)

# 方法 3: 提取图片
def extract_images_from_pdf(pdf_path, output_dir="images"):
    import os
    os.makedirs(output_dir, exist_ok=True)

    doc = fitz.open(pdf_path)
    for i, page in enumerate(doc):
        images = page.get_images()
        for j, img in enumerate(images):
            xref = img[0]
            base_image = doc.extract_image(xref)
            image_bytes = base_image["image"]
            image_ext = base_image["ext"]

            with open(f"{output_dir}/page{i+1}_img{j+1}.{image_ext}", "wb") as f:
                f.write(image_bytes)
    doc.close()
```

### 3. 从 arXiv 下载 PDF 并提取配图

```python
import requests
import fitz
import os

def download_and_extract_arxiv(arxiv_id, output_dir="arxiv_output"):
    """
    从 arXiv 下载论文 PDF 并提取所有图片

    arxiv_id: arXiv ID，如 "2306.14753"
    """
    os.makedirs(output_dir, exist_ok=True)

    # 下载 PDF
    pdf_url = f"https://arxiv.org/pdf/{arxiv_id}.pdf"
    print(f"📥 下载：{pdf_url}")

    response = requests.get(pdf_url)
    pdf_path = f"{output_dir}/{arxiv_id}.pdf"

    with open(pdf_path, "wb") as f:
        f.write(response.content)

    print(f"✅ PDF 已保存到：{pdf_path}")

    # 提取文本
    doc = fitz.open(pdf_path)
    full_text = ""
    for page in doc:
        full_text += page.get_text()
    doc.close()

    # 保存文本
    with open(f"{output_dir}/{arxiv_id}_text.txt", "w", encoding="utf-8") as f:
        f.write(full_text)

    print(f"✅ 文本已提取")

    # 提取图片
    extract_images_from_pdf(pdf_path, f"{output_dir}/{arxiv_id}_images")
    print(f"✅ 图片已提取到：{output_dir}/{arxiv_id}_images/")

    return {
        "pdf": pdf_path,
        "text": f"{output_dir}/{arxiv_id}_text.txt",
        "images_dir": f"{output_dir}/{arxiv_id}_images"
    }

def extract_images_from_pdf(pdf_path, output_dir):
    import os
    os.makedirs(output_dir, exist_ok=True)

    doc = fitz.open(pdf_path)
    image_count = 0

    for i, page in enumerate(doc):
        images = page.get_images()
        for j, img in enumerate(images):
            xref = img[0]
            try:
                base_image = doc.extract_image(xref)
                image_bytes = base_image["image"]
                image_ext = base_image["ext"]

                image_count += 1
                with open(f"{output_dir}/figure_{image_count}.{image_ext}", "wb") as f:
                    f.write(image_bytes)
                print(f"  📷 提取图片：figure_{image_count}.{image_ext}")
            except Exception as e:
                print(f"  ⚠️ 跳过图片 {xref}: {e}")

    doc.close()
    print(f"✅ 共提取 {image_count} 张图片")
```

## 依赖安装

```bash
# 基础 PDF 处理
pip install pymupdf

# Markdown 格式输出（推荐）
pip install pymupdf4llm

# 网络下载
pip install requests
```

## 使用示例

### 示例 1：提取单篇 arXiv 论文
```python
result = download_and_extract_arxiv("2306.14753")
print(f"PDF: {result['pdf']}")
print(f"文本：{result['text']}")
print(f"图片目录：{result['images_dir']}")
```

### 示例 2：批量处理
```python
arxiv_ids = ["2306.14753", "2305.12345", "2304.67890"]
for arxiv_id in arxiv_ids:
    download_and_extract_arxiv(arxiv_id)
```

## 注意事项

1. **版权**：仅提取用于个人学习/研究的论文
2. **图片质量**：提取的图片是 PDF 中嵌入的原始分辨率
3. **公式处理**：复杂数学公式可能无法完美提取为文本
4. **中文支持**：PyMuPDF 支持中文 PDF，但某些字体可能需额外配置

## 快速命令

```bash
# 创建快捷脚本
echo "python extract_arxiv.py %*" > extract.bat

# extract_arxiv.py
# import sys
# download_and_extract_arxiv(sys.argv[1])
```
