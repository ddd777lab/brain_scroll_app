#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从 PDF 文献中提取配图的脚本
使用 PyMuPDF (fitz) 库提取图片
"""

import os
import sys
import fitz  # PyMuPDF

def extract_images_from_pdf(pdf_path, output_dir):
    """
    从 PDF 中提取所有图片并保存到指定目录

    Args:
        pdf_path: PDF 文件路径
        output_dir: 输出目录

    Returns:
        提取的图片文件路径列表
    """
    # 创建输出目录
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # 打开 PDF
    print(f"打开 PDF 文件：{pdf_path}")
    doc = fitz.open(pdf_path)

    extracted_images = []

    # 遍历每一页
    for page_num in range(len(doc)):
        page = doc[page_num]
        print(f"处理第 {page_num + 1}/{len(doc)} 页...")

        # 获取页面上的所有图片
        image_list = page.get_images(full=True)

        for img_index, img in enumerate(image_list):
            try:
                xref = img[0]

                # 提取图片
                base_image = doc.extract_image(xref)
                image_bytes = base_image["image"]
                image_ext = base_image["ext"]

                # 生成文件名
                output_filename = f"page_{page_num + 1}_img_{img_index + 1}.{image_ext}"
                output_path = os.path.join(output_dir, output_filename)

                # 保存图片
                with open(output_path, "wb") as f:
                    f.write(image_bytes)

                print(f"  提取：{output_filename} (大小：{len(image_bytes)} 字节)")
                extracted_images.append(output_path)

            except Exception as e:
                print(f"  提取图片失败：{e}")

    doc.close()

    print(f"\n完成！共提取 {len(extracted_images)} 张图片")
    return extracted_images


def find_largest_image(images_dir):
    """
    找到最大的图片（通常是最主要的 figure）

    Returns:
        最大图片的路径
    """
    if not os.path.exists(images_dir):
        return None

    largest_file = None
    max_size = 0

    for filename in os.listdir(images_dir):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
            filepath = os.path.join(images_dir, filename)
            file_size = os.path.getsize(filepath)

            if file_size > max_size:
                max_size = file_size
                largest_file = filepath

    return largest_file


if __name__ == "__main__":
    # PDF 文件路径
    pdf_path = r"D:/桌面/representational geometrics reveal differential effects of response correlations on population codes in neurophysiology and functional magnetic resonance imaging.pdf"

    # 输出目录（Flutter 项目的 assets 目录）
    output_dir = r"D:/桌面/brain_scroll_app/assets/paper_images"

    print("=" * 60)
    print("PDF 图片提取工具")
    print("=" * 60)

    # 检查 PDF 文件是否存在
    if not os.path.exists(pdf_path):
        print(f"错误：PDF 文件不存在：{pdf_path}")
        sys.exit(1)

    # 提取图片
    extracted = extract_images_from_pdf(pdf_path, output_dir)

    if extracted:
        print(f"\n图片保存到：{output_dir}")

        # 找到最大的图片（可能是主要的 figure）
        largest = find_largest_image(output_dir)
        if largest:
            print(f"推荐用作封面：{largest} (最大图片)")
    else:
        print("未找到图片，尝试另一种方法...")
        # 尝试直接渲染页面为图片
        doc = fitz.open(pdf_path)
        page = doc[0]  # 第一页

        # 渲染第一页为图片
        mat = fitz.Matrix(2, 2)  # 2 倍缩放
        pix = page.get_pixmap(matrix=mat)

        preview_path = os.path.join(output_dir, "page_1_preview.png")
        pix.save(preview_path)
        print(f"已保存预览图：{preview_path}")

        doc.close()
