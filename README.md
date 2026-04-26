# Brain Scroll - 科研文献推荐 App

一个类似小红书/抖音的科研文献发现与分享应用。

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── pages/                    # 页面
│   ├── home_page.dart        # 大世界（主页）
│   ├── marketplace_page.dart # 集市（论坛）
│   ├── create_page.dart      # 发布页面
│   ├── messages_page.dart    # 消息页
│   ├── profile_page.dart     # 个人主页
│   └── article_detail_page.dart  # 文章详情页
├── widgets/                  # 组件
│   └── paper_card.dart       # 论文卡片组件
├── data/                     # 数据
│   └── mock_data.dart        # Mock 数据
└── models/                   # 数据模型（待添加）
```

## 功能特性

- **大世界**：瀑布流展示科研文献解读，支持精选内容大卡片展示
- **集市**：用户论坛，自由讨论科研话题
- **发布**：用户可以创作和发布内容
- **消息**：评论、点赞、关注等互动通知
- **我**：个人中心

## UI 风格

黑白极简风，类似小红书的设计语言。

## 运行项目

1. 安装 Flutter SDK（建议安装在 `D:\flutter`）
2. 配置环境变量：将 `D:\flutter\bin` 添加到 PATH
3. 运行 `flutter doctor` 检查环境
4. 运行 `flutter pub get` 安装依赖
5. 运行 `flutter run` 启动应用

## 下一步

- [ ] 接入真实 API 数据
- [ ] 完善搜索功能
- [ ] 添加文章收藏功能
- [ ] 完善评论区
- [ ] 添加用户认证系统
- [ ] 实现内容发布功能
