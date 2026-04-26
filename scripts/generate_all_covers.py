#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
论文封面 AI 批量生成器 - 使用通义万相 API
根据论文核心内容生成具体场景化的配图，不是抽象科技感
"""

import os
import json
import requests
import time
from datetime import datetime

# 设置 UTF-8 输出
import io
import sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

# 输出目录
OUTPUT_DIR = "assets/paper_images"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# API 配置
API_KEY = "sk-3929951e57bb4fbfbfa0ecde47e777de"
SUBMIT_URL = "https://dashscope.aliyuncs.com/api/v1/services/aigc/text2image/image-synthesis"
TASK_URL = "https://dashscope.aliyuncs.com/api/v1/tasks/"

# 论文数据 - 每篇论文都有具体的场景化生图 prompt
papers = [
    {
        'id': '1',
        'title': 'PNAS | 4 岁孩子已经会判断"谁本来就该知道我的事"了',
        'journal': 'PNAS',
        'prompt': '4岁亚洲小女孩，扎着两个小辫子，穿粉色连衣裙，在幼儿园教室里，蹲下来悄悄对另一个穿蓝色衣服的小女孩说耳语 ，表情神秘，旁边一个穿条纹衫的小男孩假装玩积木但在偷听，阳光从窗户洒进来，教室背景有彩色积木和绘本，温暖明亮，皮克斯动画电影风格，柔光效果',
    },
    {
        'id': '2',
        'title': 'Nature Human Behaviour | 睡眠如何重塑我们的情绪记忆',
        'journal': 'Nature Human Behaviour',
        'prompt': '岁女性侧躺在床上睡觉，穿白色睡衣，深蓝色卧室环境， 床头小夜灯发出暖光，头顶上方半透明大脑轮廓，大脑里发光的记忆碎片像拼图一样重新排列组合，梦境泡泡显示白天的海滩场景，星星点点的光斑 漂浮，梦幻紫色调，动漫插画风格，细腻笔触',
    },
    {
        'id': '3',
        'title': 'Science | 决策中的直觉：大脑如何在毫秒内做出价值判断',
        'journal': 'Science',
        'prompt': '一个人站在十字路口，面前有两个发光的选项，大脑像天平一样在快速权衡，闪电一样的思考过程，具象化决策场景，彩色铅笔简笔画风格',
    },
    {
        'id': '4',
        'title': 'Cell | 肠道微生物如何影响你的社交行为',
        'journal': 'Cell',
        'prompt': '一个人的侧面剪影，肠道里有各种卡通微生物在开派对，通过一条发光的通道和大脑对话，有趣的生命科学插画，彩色铅笔风格',
    },
    {
        'id': '5',
        'title': 'PNAS | 为什么我们会"脑补"不存在的信息',
        'journal': 'PNAS',
        'prompt': '一个人看着一幅不完整的画，大脑自动用发光的线条填补空白，视错觉风格，展示脑补过程',
    },
    {
        'id': '6',
        'title': 'Nature Neuroscience | 青少年大脑发育的关键窗口',
        'journal': 'Nature Neuroscience',
        'prompt': '一张青少年的半身侧面照，其中可以透视看到大脑部分，用手绘风格来表现大脑的思考过程，皮克斯动漫风格',
    },
    {
        'id': '7',
        'title': 'Psychological Science | 拖延症可能是因为大脑无法预测未来的情绪',
        'journal': 'Psychological Science',
        'prompt': '一个人躺在沙发上刷手机，旁边堆着未完成的工作，脑子里想着"明天再做"，时钟在滴答作响，幽默心理学插画，皮克斯动画风格',
    },
    {
        'id': '8',
        'title': 'Nature | 深度学习模型成功预测蛋白质三维结构',
        'journal': 'Nature',
        'prompt': '极简背景板，上面有文字，写着深度学习，同时旁边有一个动画风格的蛋白质配图',
    },
    {
        'id': '9',
        'title': 'ImageNet Classification with Deep Convolutional Neural Networks',
        'journal': 'arXiv',
        'prompt': '一个卷积神经网络像筛子一样层层过滤图片，从像素点逐渐识别出猫狗物体，每一层用不同颜色标注，深度学习教学图',
    },
    {
        'id': '10',
        'title': 'Deep Learning in Neural Networks: An Overview',
        'journal': 'arXiv',
        'prompt': '多层神经网络，信息从输入层像水流一样经过隐藏层，最后到达输出层，反向传播用红色箭头标注，教学示意图',
    },
    {
        'id': '11',
        'title': 'A Survey of Large Language Models',
        'journal': 'arXiv',
        'prompt': '一个巨型大脑由无数文字和数据组成，正在阅读海量书籍，知识像光线一样被吸收，大语言模型概念图',
    },
    {
        'id': '12',
        'title': 'Deep Arbitrary Polynomial Chaos Neural Network',
        'journal': 'arXiv',
        'prompt': '数学函数曲面像波浪一样起伏，神经网络节点叠加在上面，混沌与秩序结合，抽象科学可视化',
    },
]


def generate_image(prompt, output_path):
    """调用通义万相 API 生成图片"""
    print(f"  📝 Prompt: {prompt[:60]}...")

    # 构建请求
    payload = {
        "model": "wanx-v1",
        "input": {"prompt": prompt},
        "parameters": {
            "size": "1024*1024",
            "style": "<auto>",
        }
    }

    try:
        # 提交任务
        response = requests.post(
            SUBMIT_URL,
            headers={
                "Authorization": f"Bearer {API_KEY}",
                "Content-Type": "application/json",
                "X-DashScope-Async": "enable",
            },
            json=payload,
            timeout=30
        )

        if response.status_code != 200:
            print(f"  ❌ 提交失败：{response.status_code} - {response.text}")
            return False

        data = response.json()
        task_id = data.get('output', {}).get('task_id')

        if not task_id:
            print(f"  ❌ 未获取到 task_id")
            return False

        print(f"  ⏳ 等待生成... (task_id: {task_id})")

        # 轮询任务状态
        for i in range(60):  # 最多等 2 分钟
            time.sleep(2)

            task_response = requests.get(
                f"{TASK_URL}{task_id}",
                headers={"Authorization": f"Bearer {API_KEY}"},
                timeout=30
            )

            if task_response.status_code == 200:
                task_data = task_response.json()
                status = task_data.get('output', {}).get('task_status')

                if status == 'SUCCEEDED':
                    # 获取图片 URL
                    results = task_data.get('output', {}).get('results', [])
                    if results:
                        image_url = results[0].get('url')
                        print(f"  ✅ 生成成功，下载中...")

                        # 下载图片
                        img_response = requests.get(image_url, timeout=30)
                        if img_response.status_code == 200:
                            with open(output_path, 'wb') as f:
                                f.write(img_response.content)
                            print(f"  💾 已保存：{output_path}")
                            return True

                elif status == 'FAILED':
                    error_msg = task_data.get('output', {}).get('message', '未知错误')
                    print(f"  ❌ 生成失败：{error_msg}")
                    return False

        print(f"  ⏰ 等待超时")
        return False

    except Exception as e:
        print(f"  ❌ 错误：{e}")
        return False


def main():
    print("╔════════════════════════════════════════════════════════╗")
    print("║         论文封面 AI 批量生成器（场景化版本）              ║")
    print("╚════════════════════════════════════════════════════════╝\n")

    print(f"📁 输出目录：{OUTPUT_DIR}\n")
    print(f"📊 共 {len(papers)} 篇论文需要生成封面\n")

    success_count = 0

    for i, paper in enumerate(papers):
        progress = f"{i+1}/{len(papers)}"
        print(f"\n{'='*60}")
        print(f"📄 [{progress}] {paper['title'][:50]}...")
        print(f"   期刊：{paper['journal']}")

        output_path = f"{OUTPUT_DIR}/paper_{paper['id']}.png"

        if generate_image(paper['prompt'], output_path):
            success_count += 1

        # 避免请求过快
        if i < len(papers) - 1:
            time.sleep(1)

    print(f"\n\n{'='*60}")
    print("╔════════════════════════════════════════════════════════╗")
    print(f"║                    生成完成！                           ║")
    print(f"╠════════════════════════════════════════════════════════╣")
    print(f"║  成功：{success_count}/{len(papers)} 个封面                              ║")
    print(f"║  输出目录：{OUTPUT_DIR}                         ║")
    print("╚════════════════════════════════════════════════════════╝\n")


if __name__ == "__main__":
    main()
