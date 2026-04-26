#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
arXiv PDF 图片提取工具
从 arXiv 论文 PDF 中提取所有图片和文本

使用方法:
    python scripts/extract_arxiv_images.py <arxiv_id>
"""

import sys
import os
import fitz  # PyMuPDF

# 设置 UTF-8 输出
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')


def extract_pdf(pdf_path, output_dir):
    """提取 PDF 中的文本和图片"""
    print(f"Processing: {pdf_path}\n")

    doc = fitz.open(pdf_path)
    total_pages = len(doc)
    print(f"Total pages: {total_pages}\n")

    # 提取文本
    full_text = ""
    for i, page in enumerate(doc):
        text = page.get_text()
        full_text += f"\n=== Page {i+1} ===\n\n{text}"
        print(f"  Extracting page {i+1}/{total_pages}...")

    # 保存文本
    text_path = os.path.join(output_dir, "full_text.txt")
    with open(text_path, "w", encoding="utf-8") as f:
        f.write(full_text)
    print(f"\nText saved: {text_path}\n")

    # 提取图片 - 方法 1: 直接提取嵌入的图片
    images_dir = os.path.join(output_dir, "figures")
    os.makedirs(images_dir, exist_ok=True)

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
                image_path = os.path.join(images_dir, f"figure_{image_count}.{image_ext}")

                with open(image_path, "wb") as f:
                    f.write(image_bytes)

                print(f"  Extracted (method 1): figure_{image_count}.{image_ext}")

            except Exception as e:
                print(f"  Skip image {xref}: {e}")

    # 方法 2: 如果没有找到图片，将每页渲染为图片
    if image_count == 0:
        print(f"\nNo embedded images found. Rendering pages as images...\n")
        figures_dir = os.path.join(output_dir, "pages_as_images")
        os.makedirs(figures_dir, exist_ok=True)

        for i, page in enumerate(doc):
            # 渲染为 150 DPI 的 PNG
            mat = fitz.Matrix(1.5, 1.5)
            pix = page.get_pixmap(matrix=mat)
            image_path = os.path.join(figures_dir, f"page_{i+1:03d}.png")
            pix.save(image_path)
            print(f"  Rendered: page_{i+1:03d}.png")

        print(f"\nPages rendered to: {figures_dir}")

    doc.close()

    print(f"\nDone! Total images: {image_count}")
    print(f"Images directory: {images_dir}")

    return {
        "text": text_path,
        "images_dir": images_dir,
        "image_count": image_count
    }


def main():
    if len(sys.argv) < 2:
        print("❌ 请提供 arXiv ID")
        print("\n用法:")
        print("  python scripts/extract_arxiv_images.py <arxiv_id>")
        print("\n示例:")
        print("  python scripts/extract_arxiv_images.py 2306.14753")
        sys.exit(1)

    arxiv_id = sys.argv[1]
    pdf_path = f"pdf_output/{arxiv_id}/{arxiv_id}.pdf"
    output_dir = f"pdf_output/{arxiv_id}"

    if not os.path.exists(pdf_path):
        print(f"❌ PDF 文件不存在：{pdf_path}")
        print("\n请先运行下载命令:")
        print(f"  dart run scripts/extract_arxiv_pdf.dart {arxiv_id}")
        sys.exit(1)

    extract_pdf(pdf_path, output_dir)


if __name__ == "__main__":
    main()
