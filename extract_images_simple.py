#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从 PDF 中提取图片 - 使用 pdfminer.six 库
如果安装失败，也可以手动从学术网站获取论文配图
"""

import os
import subprocess
import sys

def install_and_extract():
    try:
        # 尝试安装 pdfminer.six
        print("正在安装 pdfminer.six...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pdfminer.six", "-q"])

        from pdfminer.high_level import extract_pages
        from pdfminer.layout import LTImage
        from pdfminer.pdfdocument import PDFDocument
        from pdfminer.pdfparser import PDFParser

        pdf_path = r"D:/桌面/representational geometrics reveal differential effects of response correlations on population codes in neurophysiology and functional magnetic resonance imaging.pdf"
        output_dir = r"D:/桌面/brain_scroll_app/assets/paper_images"

        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        print(f"打开 PDF: {pdf_path}")

        # 使用 PDFParser 直接提取图片
        pdf_file = open(pdf_path, 'rb')
        parser = PDFParser(pdf_file)
        doc = PDFDocument(parser)

        image_count = 0

        # 遍历 PDF 对象
        for objid, obj in doc.get_objects():
            try:
                if hasattr(obj, 'get') and callable(obj.get):
                    # 检查是否是图片对象
                    if obj.get('/Subtype') and obj.get('/Subtype').name == '/Image':
                        image_count += 1

                        # 获取图片数据
                        data = obj.get_data()
                        width = obj.get('/Width')
                        height = obj.get('/Height')
                        color_space = obj.get('/ColorSpace')

                        # 确定文件扩展名
                        bits_per_component = obj.get('/BitsPerComponent', 8)
                        ext = 'png'  # 默认

                        # 保存文件
                        filename = f"figure_{image_count}.{ext}"
                        output_path = os.path.join(output_dir, filename)

                        with open(output_path, 'wb') as f:
                            f.write(data)

                        print(f"提取图片 {image_count}: {filename} ({width}x{height})")

            except Exception as e:
                continue

        pdf_file.close()
        print(f"\n完成！提取了 {image_count} 张图片到：{output_dir}")

    except Exception as e:
        print(f"PDF 提取失败：{e}")
        print("\n建议方案:")
        print("1. 手动从论文网站下载配图")
        print("2. 使用在线 PDF 转图片工具")
        print("3. 使用 Adobe Acrobat 导出图片")


if __name__ == "__main__":
    install_and_extract()
