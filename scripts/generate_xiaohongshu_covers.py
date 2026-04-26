#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
小红书风格封面生成器 - 底色 + 文字模板
用于抽象概念论文（深度学习、机器学习、数学理论等）
"""

from PIL import Image, ImageDraw, ImageFont
import os
import io
import sys

# 设置 UTF-8 输出
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

OUTPUT_DIR = "assets/paper_images"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 小红书风格配色方案
STYLE_THEMES = {
    'nature': {
        'bg_color': '#F97316',  # 橙红渐变
        'text_color': '#FFFFFF',
        'accent_color': '#FDBA74',
        'gradient': [('#F97316', 0), ('#EA580C', 0.5), ('#C2410C', 1)]
    },
    'science': {
        'bg_color': '#3B82F6',  # 蓝色渐变
        'text_color': '#FFFFFF',
        'accent_color': '#93C5FD',
        'gradient': [('#3B82F6', 0), ('#2563EB', 0.5), ('#1D4ED8', 1)]
    },
    'cell': {
        'bg_color': '#EC4899',  # 粉色渐变
        'text_color': '#FFFFFF',
        'accent_color': '#F9A8D4',
        'gradient': [('#EC4899', 0), ('#DB2777', 0.5), ('#BE185D', 1)]
    },
    'neuro': {
        'bg_color': '#8B5CF6',  # 紫色渐变
        'text_color': '#FFFFFF',
        'accent_color': '#C4B5FD',
        'gradient': [('#8B5CF6', 0), ('#7C3AED', 0.5), ('#6D28D9', 1)]
    },
    'ml': {
        'bg_color': '#10B981',  # 绿色渐变
        'text_color': '#FFFFFF',
        'accent_color': '#6EE7B7',
        'gradient': [('#10B981', 0), ('#059669', 0.5), ('#047857', 1)]
    },
    'math': {
        'bg_color': '#6366F1',  # 靛蓝渐变
        'text_color': '#FFFFFF',
        'accent_color': '#A5B4FC',
        'gradient': [('#6366F1', 0), ('#4F46E5', 0.5), ('#4338CA', 1)]
    },
}

# 学科图标映射
SUBJECT_ICONS = {
    'ml': '🤖',      # 机器学习
    'math': '📐',    # 数学
    'neuro': '🧠',   # 神经科学
    'bio': '🧬',     # 生物
    'psych': '💭',   # 心理学
    'sleep': '😴',   # 睡眠
    'child': '👶',   # 儿童
    'decision': '⚖️', # 决策
    'microbe': '🦠', # 微生物
    'protein': '🔬', # 蛋白质
    'default': '📚', # 默认
}

def create_gradient_background(width, height, gradient_colors):
    """创建渐变背景"""
    img = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(img)

    for y in range(height):
        progress = y / height
        # 找到当前进度所在的颜色区间
        for i in range(len(gradient_colors) - 1):
            color1, pos1 = gradient_colors[i]
            color2, pos2 = gradient_colors[i + 1]
            if pos1 <= progress <= pos2:
                local_progress = (progress - pos1) / (pos2 - pos1)
                r = int(int(color1[1:3], 16) + (int(color2[1:3], 16) - int(color1[1:3], 16)) * local_progress)
                g = int(int(color1[3:5], 16) + (int(color2[3:5], 16) - int(color1[3:5], 16)) * local_progress)
                b = int(int(color1[5:7], 16) + (int(color2[5:7], 16) - int(color1[5:7], 16)) * local_progress)
                draw.line([(0, y), (width, y)], fill=(r, g, b))
                break

    return img

def add_text_overlay(img, title, journal, subtitle=""):
    """添加文字叠加层"""
    draw = ImageDraw.Draw(img)
    width, height = img.size

    # 尝试加载中文字体
    try:
        # Windows 系统字体
        title_font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", int(width * 0.06))
        subtitle_font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", int(width * 0.035))
        journal_font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", int(width * 0.025))
    except:
        # 备用字体
        title_font = ImageFont.load_default()
        subtitle_font = ImageFont.load_default()
        journal_font = ImageFont.load_default()

    # 顶部期刊标签
    journal_y = int(height * 0.05)
    journal_x = int(width * 0.05)
    draw.text((journal_x, journal_y), journal, font=journal_font, fill='#FFFFFF')

    # 主标题（居中，多行）
    title_lines = wrap_text(title, int(width * 0.045), title_font)
    line_height = int(width * 0.07)
    total_height = len(title_lines) * line_height
    start_y = int((height - total_height) / 2)

    for i, line in enumerate(title_lines):
        text_y = start_y + i * line_height
        # 计算文字居中位置
        bbox = draw.textbbox((0, 0), line, font=title_font)
        text_width = bbox[2] - bbox[0]
        text_x = (width - text_width) / 2
        draw.text((text_x, text_y), line, font=title_font, fill='#FFFFFF')

    # 底部副标题
    if subtitle:
        subtitle_y = int(height * 0.85)
        bbox = draw.textbbox((0, 0), subtitle, font=subtitle_font)
        text_width = bbox[2] - bbox[0]
        text_x = (width - text_width) / 2
        draw.text((text_x, subtitle_y), subtitle, font=subtitle_font, fill='#FFFFFF')

    return img

def wrap_text(text, max_width, font):
    """文字自动换行"""
    lines = []
    current_line = ""

    for char in text:
        test_line = current_line + char
        bbox = font.getbbox(test_line)
        if bbox[2] > max_width:
            if current_line:
                lines.append(current_line)
            current_line = char
        else:
            current_line = test_line

    if current_line:
        lines.append(current_line)

    return lines

def create_xiaohongshu_cover(paper_id, title, journal, theme_name='default', subtitle=""):
    """创建小红书风格封面"""
    width, height = 1024, 1024

    # 获取配色方案
    theme = STYLE_THEMES.get(theme_name, STYLE_THEMES['ml'])

    # 创建渐变背景
    img = create_gradient_background(width, height, theme['gradient'])

    # 添加装饰元素（圆点/线条）
    draw = ImageDraw.Draw(img)
    for i in range(5):
        y = int(height * (0.1 + i * 0.2))
        x = int(width * (0.05 + i * 0.02))
        r = int(width * (0.03 - i * 0.005))
        draw.ellipse([(x, y - r), (x + r * 2, y + r)],
                    fill=theme['accent_color'],
                    outline=None)

    # 添加文字
    img = add_text_overlay(img, title, journal, subtitle)

    # 保存
    output_path = f"{OUTPUT_DIR}/paper_{paper_id}.png"
    img.save(output_path)
    print(f"✅ 已生成：{output_path}")

    return output_path

def main():
    """批量生成小红书风格封面"""
    print("╔════════════════════════════════════════════════════════╗")
    print("║         小红书风格封面生成器（抽象概念专用）              ║")
    print("╚════════════════════════════════════════════════════════╝\n")

    # 抽象概念论文列表（需要生成文字模板封面）
    papers = [
        {
            'id': '9',
            'title': 'ImageNet Classification\nwith Deep CNN',
            'journal': 'arXiv · Deep Learning',
            'theme': 'ml',
            'subtitle': '卷积神经网络架构详解',
        },
        {
            'id': '10',
            'title': 'Deep Learning in\nNeural Networks',
            'journal': 'arXiv · Overview',
            'theme': 'ml',
            'subtitle': '深度学习原理综述',
        },
        {
            'id': '11',
            'title': 'A Survey of\nLarge Language Models',
            'journal': 'arXiv · LLM Survey',
            'theme': 'ml',
            'subtitle': '大语言模型全面综述',
        },
        {
            'id': '12',
            'title': 'Deep Arbitrary\nPolynomial Chaos NN',
            'journal': 'arXiv · Math + AI',
            'theme': 'math',
            'subtitle': '混沌理论与深度学习结合',
        },
    ]

    for paper in papers:
        print(f"📄 生成：{paper['title'].replace(chr(10), ' ')}...")
        create_xiaohongshu_cover(
            paper_id=paper['id'],
            title=paper['title'],
            journal=paper['journal'],
            theme_name=paper['theme'],
            subtitle=paper['subtitle']
        )

    print("\n✅ 全部完成！")

if __name__ == "__main__":
    main()
