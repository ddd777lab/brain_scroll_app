#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""重试生成最后一张封面"""

import os
import requests
import time
import io
import sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

API_KEY = "sk-3929951e57bb4fbfbfa0ecde47e777de"
SUBMIT_URL = "https://dashscope.aliyuncs.com/api/v1/services/aigc/text2image/image-synthesis"
TASK_URL = "https://dashscope.aliyuncs.com/api/v1/tasks/"

prompt = "数学函数曲面像波浪一样起伏，神经网络节点叠加在上面，混沌与秩序结合，抽象科学可视化"
output_path = "assets/paper_images/paper_12.png"

print(f"正在生成最后一张封面...")
print(f"Prompt: {prompt}")

payload = {
    "model": "wanx-v1",
    "input": {"prompt": prompt},
    "parameters": {"size": "1024*1024", "style": "<auto>"}
}

response = requests.post(SUBMIT_URL, headers={"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json", "X-DashScope-Async": "enable"}, json=payload, timeout=30)
data = response.json()
task_id = data.get('output', {}).get('task_id')
print(f"Task ID: {task_id}")

for i in range(60):
    time.sleep(2)
    task_response = requests.get(f"{TASK_URL}{task_id}", headers={"Authorization": f"Bearer {API_KEY}"}, timeout=30)
    task_data = task_response.json()
    status = task_data.get('output', {}).get('task_status')
    print(f"状态：{status}")

    if status == 'SUCCEEDED':
        results = task_data.get('output', {}).get('results', [])
        if results:
            image_url = results[0].get('url')
            print(f"下载图片：{image_url}")
            img_response = requests.get(image_url, timeout=30)
            with open(output_path, 'wb') as f:
                f.write(img_response.content)
            print(f"已保存：{output_path}")
            break
    elif status == 'FAILED':
        print(f"失败：{task_data.get('output', {}).get('message')}")
        break

print("完成！")
