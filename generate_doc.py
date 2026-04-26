#!/usr/bin/env python3
"""
Brain Scroll App 项目文件说明文档生成器
生成一份面向非技术用户的 Word 文档，说明项目各文件和目录的作用。
"""

from docx import Document
from docx.shared import Pt, Cm, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn
import os

doc = Document()

# ========== 全局样式设置 ==========
style = doc.styles['Normal']
style.font.name = '微软雅黑'
style.font.size = Pt(11)
style.paragraph_format.line_spacing = 1.5
style.paragraph_format.space_after = Pt(4)
style.element.rPr.rFonts.set(qn('w:eastAsia'), '微软雅黑')

# 页边距
for section in doc.sections:
    section.top_margin = Cm(2)
    section.bottom_margin = Cm(2)
    section.left_margin = Cm(2.5)
    section.right_margin = Cm(2.5)

# ========== 辅助函数 ==========

def set_cell_shading(cell, color):
    """设置单元格背景色"""
    from docx.oxml import OxmlElement
    shading = OxmlElement('w:shd')
    shading.set(qn('w:fill'), color)
    shading.set(qn('w:val'), 'clear')
    cell._tc.get_or_add_tcPr().append(shading)

def add_table_with_header(doc, headers, rows, col_widths=None):
    """创建带标题行的表格"""
    table = doc.add_table(rows=1 + len(rows), cols=len(headers))
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.style = 'Light Grid Accent 1'

    # 表头
    for i, header in enumerate(headers):
        cell = table.rows[0].cells[i]
        cell.text = header
        for paragraph in cell.paragraphs:
            paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
            for run in paragraph.runs:
                run.bold = True
                run.font.size = Pt(10)
                run.font.name = '微软雅黑'
                run.font.color.rgb = RGBColor(0x33, 0x33, 0x33)

    # 数据行
    for r_idx, row_data in enumerate(rows):
        for c_idx, cell_text in enumerate(row_data):
            cell = table.rows[r_idx + 1].cells[c_idx]
            cell.text = str(cell_text)
            for paragraph in cell.paragraphs:
                for run in paragraph.runs:
                    run.font.size = Pt(10)
                    run.font.name = '微软雅黑'

    if col_widths:
        for i, width in enumerate(col_widths):
            for row in table.rows:
                row.cells[i].width = Cm(width)

    return table

def add_file_box(doc, filepath, purpose, affects_what, modify_hint, relations=""):
    """添加一个文件说明块"""
    p = doc.add_paragraph()
    run = p.add_run(f"📄 {filepath}")
    run.bold = True
    run.font.size = Pt(12)
    run.font.color.rgb = RGBColor(0x1A, 0x73, 0xE6)

    p = doc.add_paragraph()
    p.add_run("它的作用：").bold = True
    p.add_run(f" {purpose}")

    p = doc.add_paragraph()
    p.add_run("影响范围：").bold = True
    p.add_run(f" {affects_what}")

    p = doc.add_paragraph()
    p.add_run("修改指引：").bold = True
    p.add_run(f" {modify_hint}")

    if relations:
        p = doc.add_paragraph()
        p.add_run("关联文件：").bold = True
        p.add_run(f" {relations}")

    doc.add_paragraph()  # 空行

# ========== 文档标题 ==========

title = doc.add_heading('Brain Scroll App 项目文件说明', level=0)
title.alignment = WD_ALIGN_PARAGRAPH.CENTER
for run in title.runs:
    run.font.color.rgb = RGBColor(0x1A, 0x73, 0xE6)

subtitle = doc.add_paragraph()
subtitle.alignment = WD_ALIGN_PARAGRAPH.CENTER
run = subtitle.add_run('—— 面向非技术用户的完整使用手册')
run.font.size = Pt(13)
run.font.color.rgb = RGBColor(0x66, 0x66, 0x66)
run.italic = True

doc.add_paragraph()

# ========== 目录：快速查找 ==========

doc.add_heading('一、快速查找：我想改 X，该看哪个文件？', level=1)

p = doc.add_paragraph('下面是最常用的修改场景和对应文件，您可以直接从这里找到目标文件，然后去后面的详细章节了解具体内容。')

quick_ref_headers = ['我想修改...', '应该看的文件', '难度']
quick_ref_rows = [
    ['App 的首页（大世界）', 'lib/pages/home_page.dart', '★★★'],
    ['大世界卡片样式（封面、标签、配色）', 'lib/widgets/xiaohongshu_card.dart', '★★★'],
    ['文章详情页内容（7 个模块）', 'lib/pages/article_detail_page.dart', '★★★'],
    ['登录 / 注册页面', 'lib/pages/onboarding/login_page.dart', '★★'],
    ['onboarding 引导页（学术背景 / 兴趣 / 期刊）', 'lib/pages/onboarding/ 目录下的文件', '★★'],
    ['底部导航栏（5 个 Tab）', 'lib/main.dart', '★★★'],
    ['Mock 数据（论文列表、标题、图片、标签等）', 'lib/data/mock_data.dart', '★'],
    ['App 主题色、背景色、莫兰迪色卡', 'lib/theme/app_colors.dart', '★'],
    ['图片资源（封面图、头像等）', 'assets/paper_images/ 和 assets/images/', '★'],
    ['AI 生成的文章详情内容', 'lib/services/paper_detail_generator.dart', '★★'],
    ['AI 封面图片生成', 'lib/services/tongyi_image_service.dart', '★★★★'],
    ['论文详情（摘要、背景、结果等 7 模块内容）', 'lib/data/mock_data.dart（预定义部分）', '★'],
    ['期刊名称、Logo、标签信息', 'lib/data/mock_data.dart', '★'],
    ['arXiv 论文加载（下拉加载更多）', 'lib/services/arxiv_service.dart', '★★★★'],
    ['用户信息 / 偏好数据存储', 'lib/services/user_onboarding_service.dart', '★★★'],
]

add_table_with_header(doc, quick_ref_headers, quick_ref_rows, [7, 10, 2])

doc.add_paragraph()

# ========== 二、项目整体概览 ==========

doc.add_heading('二、项目整体概览', level=1)

doc.add_paragraph(
    'Brain Scroll 是一个"论文发现"类 App，设计风格参考了小红书。'
    '整个 App 分为两个大的部分：新用户首次使用时会经过一套"登录 + 偏好引导"流程（Onboarding），'
    '完成引导后进入主界面。主界面底部有 5 个导航按钮，分别对应 5 个主要页面。'
)

doc.add_paragraph('项目的基本结构如下：')

doc.add_heading('项目根目录结构', level=2)

root_headers = ['文件夹 / 文件', '说明', '你需要关注吗？']
root_rows = [
    ['lib/', 'App 的核心代码所在目录，所有页面、功能、数据都在这里', '⭐ 重点！所有修改都在这里'],
    ['assets/', '图片资源文件夹，放封面图和 App 图标等', '需要修改图片时关注'],
    ['web/', '让 App 能在浏览器中运行的配置文件', '一般不需要改'],
    ['android/', 'Android 手机运行所需的配置文件', '需要打包成 APK 时关注'],
    ['ios/', 'iPhone 运行所需的配置文件', '需要打包成 IPA 时关注'],
    ['build/', '编译过程中自动生成的临时文件', '不需要关注'],
    ['.dart_tool/', 'Flutter 自动生成的工具文件', '不需要关注'],
    ['pubspec.yaml', '管理 App 使用的第三方插件和依赖', '需要添加新插件时修改'],
    ['README.md', '项目说明文档（程序员版本）', '一般不需要看'],
    ['run.bat', '一键启动 App 的批处理文件', '双击运行即可'],
    ['extract_pdf_images.py 等', '从 PDF 提取图片的辅助脚本', '不需要关注'],
]

add_table_with_header(doc, root_headers, root_rows, [5, 9, 5])

doc.add_paragraph()

doc.add_heading('lib/ 目录详解', level=2)

doc.add_paragraph(
    'lib/ 是整个项目最重要的目录，您将来可能需要修改的文件几乎全部在这个目录下。'
    '它内部又分了好几个子目录，各司其职：'
)

lib_headers = ['子目录', '存放内容', '常用度']
lib_rows = [
    ['lib/pages/', '各个页面的界面（首页、详情页、登录页等）', '⭐⭐⭐ 最高'],
    ['lib/widgets/', '可复用的界面组件（卡片、下拉框、标签选择器等）', '⭐⭐⭐ 高'],
    ['lib/services/', '后台服务（arXiv 加载、AI 内容生成、用户数据存储）', '⭐⭐ 中高'],
    ['lib/data/', '模拟数据（论文列表、期刊信息等）', '⭐⭐⭐ 最高'],
    ['lib/theme/', '颜色、主题、字体等全局视觉配置', '⭐⭐ 中高'],
    ['lib/models/', '数据模型（目前为空）', '暂未使用'],
]

add_table_with_header(doc, lib_headers, lib_rows, [5, 10, 4])

doc.add_paragraph()

# ========== 三、核心文件详解 ==========

doc.add_heading('三、核心文件详解', level=1)

doc.add_paragraph(
    '本章节按照"从入口到页面，从页面到组件"的顺序，逐一介绍每个重要文件的作用、'
    '它影响 App 的哪个部分、以及如何修改。'
)

# --- 3.1 App 入口 ---
doc.add_heading('3.1 App 入口文件', level=2)

add_file_box(doc,
    filepath='lib/main.dart',
    purpose=(
        '这是整个 App 的"大门"。App 启动时第一个运行的就是这个文件。'
        '它做了三件大事：① 配置 App 的主题颜色（背景色、字体色等）；'
        '② 判断用户是否已经完成登录引导——如果没完成，显示登录页；已完成则进入主界面；'
        '③ 搭建底部导航栏，包含"发布"、"集市"、"大世界"、"消息"、"我的"5 个 Tab。'
    ),
    affects_what=(
        '影响整个 App：底部导航栏、主题配色、登录引导流程的入口判断。'
    ),
    modify_hint=(
        '想改底部导航栏的按钮文字或顺序？找到 MainScaffold 里的 BottomNavigationBar 部分。'
        '想改 App 的主题色？找到 ThemeData 部分。'
        '想跳过登录引导直接进入主界面？修改 OnboardingWrapper 的判断逻辑。'
    ),
    relations=(
        '引用了 pages/ 下所有页面文件和 onboarding/ 下的登录页。'
        '通过 provider 插件管理全局状态（AppState 和 OnboardingService）。'
    )
)

# --- 3.2 大世界页面 ---
doc.add_heading('3.2 大世界页面（首页信息流）', level=2)

add_file_box(doc,
    filepath='lib/pages/home_page.dart',
    purpose=(
        '这就是 App 主界面的"大世界"页面，也是用户最常看的页面。'
        '它实现了一个类似小红书的双列瀑布流布局：左边一列、右边一列，卡片高低错落。'
        '页面顶部有"订阅"和"推荐"两个 Tab 切换，以及一行分类标签（心理学、神经科学等）。'
        '页面会自动加载预置的论文数据，用户向下滚动到底部时会自动加载更多。'
    ),
    affects_what=(
        '影响 App 首页的整个信息流展示：布局方式（双列瀑布流）、'
        '顶部导航（订阅/推荐 Tab）、分类标签、加载更多内容的方式。'
    ),
    modify_hint=(
        '想修改页面背景色？找 backgroundColor 属性。'
        '想改分类标签的文字（如"心理学"改为其他）？找 _buildChip 调用处。'
        '想调整瀑布流左右列的宽度比例？找 Expanded 的 flex 值（目前左 10 右 9）。'
        '想修改"到底啦"等提示文字？直接搜索文字内容修改。'
    ),
    relations=(
        '调用 lib/widgets/xiaohongshu_card.dart 来显示每张卡片。'
        '数据来自 lib/data/mock_data.dart。'
        '加载更多时模拟调用 lib/services/arxiv_service.dart。'
        '颜色全部使用 lib/theme/app_colors.dart 统一定义。'
    )
)

# --- 3.3 大世界卡片 ---
doc.add_heading('3.3 大世界卡片组件', level=2)

add_file_box(doc,
    filepath='lib/widgets/xiaohongshu_card.dart',
    purpose=(
        '这是信息流中每张论文卡片的"设计模板"。每张卡片包括：'
        '一张封面图（可能是渐变色背景 + 期刊名 + 论文标题关键词的组合设计）、'
        '几个标签（莫兰迪色系）、标题文字、作者名和点赞数。'
        '点击卡片后会跳转到文章详情页。'
    ),
    affects_what=(
        '影响信息流中所有卡片的外观：封面图的大小比例（有 3:4、4:5、1:1 等不同尺寸）、'
        '封面渐变色配色、标签颜色和样式、标题字体大小、作者名和点赞数的位置。'
    ),
    modify_hint=(
        '想改封面图的渐变配色？找 _getGradientForJournal 方法——根据不同期刊返回不同颜色组合。'
        '想修改标签的颜色？找 _getMorandiColorForTag 方法。'
        '想调整卡片圆角大小？找 borderRadius 属性。'
        '想改卡片的间距或边距？找 padding 和 margin 属性。'
        '想增加或删掉卡片上的某个元素（如去掉点赞数）？直接增删对应代码即可。'
    ),
    relations=(
        '被 home_page.dart 调用（每个卡片实例化一次）。'
        '点击后导航到 article_detail_page.dart。'
        '颜色使用 app_colors.dart。'
        '封面宽高比从 mock_data.dart 中读取 coverAspectRatio 字段。'
    )
)

# --- 3.4 文章详情页 ---
doc.add_heading('3.4 文章详情页', level=2)

add_file_box(doc,
    filepath='lib/pages/article_detail_page.dart',
    purpose=(
        '点击卡片后进入的详情页。页面结构参考了小红书风格，包含：'
        '① 顶部导航栏（返回、分享、收藏按钮）；'
        '② 图片轮播区（可左右滑动的 3 张封面图，底部有圆点指示器）；'
        '③ 论文标题；'
        '④ 标签（莫兰迪色系）；'
        '⑤ 小红书风格的作者栏（期刊 Logo + 名称 + 关注按钮）；'
        '⑥ 基本信息卡片（标题、日期、期刊、DOI 等）；'
        '⑦ 7 个内容模块（摘要、研究背景、研究目的、研究设计、研究结果、结论与讨论）；'
        '⑧ 互动区（点赞、收藏、评论、分享图标 + 数字）；'
        '⑨ 评论区入口；'
        '⑩ 底部评论输入栏。'
    ),
    affects_what=(
        '影响用户看完论文卡片后看到的所有内容：排版样式、模块数量和内容、'
        '轮播图效果、作者栏样式、互动按钮、底部评论栏。'
    ),
    modify_hint=(
        '想增删内容模块（如增加"局限性"模块）？'
        '在 build 方法中找到 SliverToBoxAdapter 中的内容区域，'
        '仿照 _buildModule("模块名", _paperData["字段名"]) 的写法增加即可。'
        '想修改模块标题的字体大小？找 _buildModule 方法中的 TextStyle。'
        '想修改轮播图高度？找 _buildImageCarousel 中的 height: 240。'
        '想修改关注按钮颜色？找 _buildAuthorBar 中的 backgroundColor。'
    ),
    relations=(
        '数据来自 home_page.dart 传入的论文对象（通过 Route settings 传递）。'
        '如果 mock_data.dart 中有预定义的详情内容，直接使用；否则会调用 paper_detail_generator.dart 生成。'
        '颜色使用 app_colors.dart。'
    )
)

# --- 3.5 登录/注册 ---
doc.add_heading('3.5 登录 / 注册页面', level=2)

add_file_box(doc,
    filepath='lib/pages/onboarding/login_page.dart',
    purpose=(
        '新用户首次打开 App 时看到的第一个页面。'
        '支持"登录"和"注册"两种模式切换，用户输入手机号和密码后点击按钮进入下一步。'
        '目前是模拟登录（不连接真实服务器），输入任意内容即可通过。'
    ),
    affects_what=(
        '影响新用户的第一印象：登录框样式、按钮颜色、Logo 显示、密码可见性切换。'
    ),
    modify_hint=(
        '想改按钮颜色？找 ElevatedButton.styleFrom 中的 backgroundColor。'
        '想改 Logo 文字？直接修改 Text 内容。'
        '想增加"记住密码"或"忘记密码"功能？在表单区域增加 CheckBox 或链接按钮即可。'
        '想改为真正的登录验证？需要在此处增加后端 API 调用逻辑。'
    ),
    relations=(
        '完成后跳转到 academic_background_page.dart。'
        '用户数据保存到 user_onboarding_service.dart 中。'
    )
)

# --- 3.6 Onboarding 引导页 ---
doc.add_heading('3.6 Onboarding 引导页（学术背景 / 兴趣 / 期刊选择）', level=2)

doc.add_paragraph('登录完成后，用户需要依次完成 3 页引导。这 3 页放在 lib/pages/onboarding/ 目录下：')

add_file_box(doc,
    filepath='lib/pages/onboarding/academic_background_page.dart',
    purpose='第 2 步：让用户填写学术背景信息。包括选择专业（搜索框）、选择学位（本科/硕士/博士等按钮）、'
            '滑动条选择科研经验年限（0-100 年）。',
    affects_what='影响学术背景填写页的布局、选项内容、进度条显示。',
    modify_hint='想修改专业选项？找 dropdownItems 列表。'
                '想修改学位按钮的文字或数量？找学位按钮组。'
                '想隐藏科研经验滑块或调整范围？找 Slider 相关代码。',
    relations='引用 searchable_dropdown.dart（可搜索下拉框组件）和 user_onboarding_service.dart（保存数据）。'
)

add_file_box(doc,
    filepath='lib/pages/onboarding/interests_page.dart',
    purpose='第 3 步：让用户选择感兴趣的领域。页面显示一组预设的兴趣标签（如"儿童发展"、"社会认知"等），'
            '用户可以多选，也可以自己输入新的兴趣标签。',
    affects_what='影响兴趣选择页的标签列表、标签样式、自定义输入框。',
    modify_hint='想增删预设兴趣标签？找 predefinedInterests 列表。'
                '想修改标签的颜色？找 TagSelector 组件或页面上的颜色设置。',
    relations='引用 tag_selector.dart（标签选择器组件）和 user_onboarding_service.dart（保存数据）。'
)

add_file_box(doc,
    filepath='lib/pages/onboarding/journals_page.dart',
    purpose='第 4 步：让用户选择感兴趣的学术期刊。用户可以在搜索框中输入期刊名（带自动补全），'
            '选中的期刊会以标签形式显示在页面顶部。完成后点击按钮进入主 App。',
    affects_what='影响期刊选择页的搜索框、自动补全列表、已选期刊标签、完成按钮。',
    modify_hint='想修改自动补全的期刊列表？找 suggestedJournals 列表。'
                '想修改完成按钮跳转的目标页面？找 Navigator.pushAndRemoveUntil 部分。',
    relations='引用 searchable_dropdown.dart（搜索框）和 user_onboarding_service.dart（保存数据）。'
            '完成后导航到 main.dart 中的 MainScaffold（主界面）。'
)

# --- 3.7 其他主要页面 ---
doc.add_heading('3.7 其他主要页面', level=2)

add_file_box(doc,
    filepath='lib/pages/marketplace_page.dart',
    purpose='集市页面。显示讨论话题的网格列表，顶部有分类筛选标签（全部、心理学、神经科学等）。',
    affects_what='集市页面的布局、话题卡片样式、分类筛选。',
    modify_hint='想修改话题列表数据？去 mock_data.dart 中找 discussions。'
                '想改分类标签？找页面内的分类按钮区域。',
    relations='数据来自 mock_data.dart。'
)

add_file_box(doc,
    filepath='lib/pages/messages_page.dart',
    purpose='消息页面。显示系统通知列表，每条通知带有头像、标题、内容摘要和时间。',
    affects_what='通知列表的样式、排列方式、未读标记。',
    modify_hint='想修改通知数据？去 mock_data.dart 中找 notifications。'
                '想改通知的样式（如字体大小、图标）？直接修改列表项的 UI 代码。',
    relations='数据来自 mock_data.dart。'
)

add_file_box(doc,
    filepath='lib/pages/profile_page.dart',
    purpose='我的页面。显示用户头像、昵称、个人简介、统计数据（关注数、粉丝数、获赞数），'
            '以及一系列功能入口（设置、收藏、历史等）。'
            '如果用户还没完成 onboarding，会显示"完善你的资料"提示。',
    affects_what='个人主页的整体布局、用户信息显示、功能菜单。',
    modify_hint='想修改用户信息展示？找 OnboardingService 相关的数据读取部分。'
                '想增删功能菜单项？找功能入口列表区域。',
    relations='引用 user_onboarding_service.dart 获取用户信息。'
)

add_file_box(doc,
    filepath='lib/pages/create_page.dart',
    purpose='发布页面。用户可以在这里创建帖子：输入标题、编写内容、关联文献、上传图片、添加标签。',
    affects_what='发帖界面的所有元素：输入框、编辑器、图片上传区域、标签选择、发布按钮。',
    modify_hint='想修改发布表单？直接修改表单控件。'
                '想增加发布限制（如字数上限）？在发布逻辑中增加验证。',
    relations='暂未关联后端服务（目前是前端模拟）。'
)

# --- 3.8 组件 ---
doc.add_heading('3.8 可复用组件', level=2)

doc.add_paragraph('widgets/ 目录下放着可以被多个页面复用的界面组件：')

add_file_box(doc,
    filepath='lib/widgets/xiaohongshu_card.dart',
    purpose='（已在 3.3 节详细说明）信息流卡片的设计模板。',
    affects_what='信息流所有卡片的外观。',
    modify_hint='（详见 3.3 节）',
    relations='被 home_page.dart 调用。'
)

add_file_box(doc,
    filepath='lib/widgets/paper_card.dart',
    purpose='另一款论文卡片组件，目前有但使用较少。设计风格与 xiaohongshu_card.dart 有所不同。',
    affects_what='如果使用此组件的页面会受到影响。',
    modify_hint='目前主要使用 xiaohongshu_card.dart，此组件暂不需要修改。',
    relations='与 xiaohongshu_card.dart 功能类似，属于备选方案。'
)

add_file_box(doc,
    filepath='lib/widgets/onboarding/searchable_dropdown.dart',
    purpose='可搜索的下拉选择框。用户在输入文字时可以实时过滤选项，支持点击外部区域关闭。',
    affects_what='学术背景页的专业选择、期刊选择页的搜索框。',
    modify_hint='想修改下拉框的高度？找 maxHeight 属性。'
                '想修改搜索过滤逻辑？找 onChanged 相关代码。',
    relations='被 academic_background_page.dart 和 journals_page.dart 使用。'
)

add_file_box(doc,
    filepath='lib/widgets/onboarding/tag_selector.dart',
    purpose='标签多选器。用户可以从预设标签中选择多个，也可以自己输入新标签。选中后以高亮标签显示。',
    affects_what='兴趣选择页的所有标签交互。',
    modify_hint='想修改标签选中后的颜色？找选中状态的 decoration 属性。'
                '想限制最多可选数量？在添加逻辑中增加计数判断。',
    relations='被 interests_page.dart 使用。'
)

# --- 3.9 数据层 ---
doc.add_heading('3.9 数据层', level=2)

add_file_box(doc,
    filepath='lib/data/mock_data.dart',
    purpose=(
        '这是整个 App 的"数据库"。因为 App 目前没有连接真实服务器，'
        '所以所有页面上能看到的数据——论文列表（12+ 篇）、每篇论文的 7 模块详情内容、'
        '集市讨论话题、系统通知、期刊名称、封面图片路径、标签、点赞数、作者名等——'
        '全部存在这里。'
    ),
    affects_what=(
        '影响所有页面的显示内容。只要改了这个文件的数据，App 上能看到的所有文字、图片、'
        '标签、期刊名、论文信息都会跟着变。'
    ),
    modify_hint=(
        '想修改论文标题？找到 papers 列表，修改 title 字段。'
        '想增加新论文？复制一篇论文的 {} 块，修改里面的字段即可。'
        '想修改 7 模块内容（摘要、背景、结果等）？找到 paperDetails 字典，'
        '每篇论文有一个 ID 对应一个字典，包含 abstract、background、objective、design、results、conclusion 等字段。'
        '想修改封面图片？修改 coverImagePath 字段，指向 assets/paper_images/ 下的图片文件名。'
        '想修改标签？修改 tags 列表。'
        '想修改期刊名？修改 journal 和 journalName 字段。'
        '想修改封面宽高比（卡片高度）？修改 coverAspectRatio 字段（0.75=矮胖，1.0=正方形）。'
    ),
    relations=(
        '被 home_page.dart（论文列表）、article_detail_page.dart（详情内容）、'
        'marketplace_page.dart（讨论数据）、messages_page.dart（通知数据）引用。'
        '是整 App 的数据源头。'
    )
)

# --- 3.10 主题色 ---
doc.add_heading('3.10 颜色和主题', level=2)

add_file_box(doc,
    filepath='lib/theme/app_colors.dart',
    purpose=(
        '这里是整个 App 的"调色板"。App 里用到的所有颜色都集中定义在这里，'
        '包括：背景色（米白色 #FAF8F3）、主色调（薄荷绿 #4ADE80）、'
        '文字颜色（深灰、中灰、浅灰三个层级）、边框颜色、'
        '以及一套完整的"莫兰迪色系"（灰蓝、豆沙粉、雾霾紫、鼠尾草绿、奶茶棕、米杏色），'
        '用于标签和装饰元素。'
    ),
    affects_what=(
        '影响整个 App 的视觉风格。修改这里的颜色，所有引用该颜色的页面都会同步更新。'
    ),
    modify_hint=(
        '想改全局背景色？修改 background 的值（当前是 0xFFFAF8F3）。'
        '想改按钮/主题色？修改 primary 的值（当前是 0xFF4ADE80）。'
        '想改莫兰迪色系？修改 morandiXxx 系列颜色。'
        '想新增一个全局颜色？在这里定义后，在各个页面中用 AppColors.颜色名 调用。'
        '颜色值格式：0xFF 开头 + 6 位十六进制色号，如 0xFFFF0000 是红色。'
    ),
    relations=(
        '被几乎所有页面和组件引用（home_page.dart、article_detail_page.dart、'
        'xiaohongshu_card.dart 等）。'
    )
)

# --- 3.11 服务层 ---
doc.add_heading('3.11 服务层（后台功能）', level=2)

doc.add_paragraph('services/ 目录下放着 App 的"后台服务"——不直接显示在界面上，但为页面提供数据和支持：')

add_file_box(doc,
    filepath='lib/services/user_onboarding_service.dart',
    purpose='用户引导数据管理。保存用户在 onboarding 过程中输入的所有信息：手机号、密码、专业、学位、'
            '科研经验、兴趣标签、关注的期刊。这些信息在"我的"页面会显示。',
    affects_what='影响用户信息的存储和读取。',
    modify_hint='想增加新的用户信息字段（如"研究方向"）？'
                '在 OnboardingData 中增加字段，再增加对应的 update 方法即可。',
    relations='被 main.dart（判断是否完成引导）、profile_page.dart（显示用户信息）、'
              '所有 onboarding 页面（保存数据）引用。'
)

add_file_box(doc,
    filepath='lib/services/arxiv_service.dart',
    purpose='arXiv 论文加载服务。当用户在信息流中向下滚动到底部时，'
            '这个服务负责从 arXiv 学术网站获取更多论文数据。'
            '目前使用模拟数据代替真实 API 请求（避免跨域问题）。',
    affects_what='影响"加载更多论文"功能。',
    modify_hint='想修改模拟论文数据？在 home_page.dart 的 mockExtensions 列表中修改。'
                '想接入真实 arXiv API？在此文件中修改请求逻辑，通过代理解决跨域问题。',
    relations='被 home_page.dart 调用（加载更多时触发）。'
)

add_file_box(doc,
    filepath='lib/services/paper_detail_generator.dart',
    purpose='论文详情生成器。当一篇论文在 mock_data.dart 中没有预定义的详情内容时，'
            '这个服务会根据论文标题和摘要中的关键词，自动匹配对应的内容模板，'
            '生成 7 个模块（摘要、背景、目的、设计、结果、结论）。',
    affects_what='影响详情页中自动生成的文章内容。',
    modify_hint='想修改自动生成的内容？找到对应模板（如 child_development、sleep_memory 等），'
                '修改其中的文字即可。'
                '想增加新的模板？仿照现有模板格式增加新的字典条目。',
    relations='被 article_detail_page.dart 调用（当 mock_data 中没有对应详情时触发）。'
)

add_file_box(doc,
    filepath='lib/services/paper_summary_service.dart',
    purpose='AI 论文摘要服务。预留的接口，未来可以接入通义千问 API，'
            '实现真正的 AI 自动生成论文摘要。目前还未实际使用。',
    affects_what='暂未影响任何页面。',
    modify_hint='想接入 AI 能力？在此文件中配置 API Key 和请求逻辑。',
    relations='预留接口，未来可被 article_detail_page.dart 调用。'
)

add_file_box(doc,
    filepath='lib/services/tongyi_image_service.dart',
    purpose='AI 封面图片生成服务。通过通义万相 API 根据论文信息自动生成封面图片。'
            '目前为预留接口，暂未在主流程中使用。',
    affects_what='暂未影响任何页面。',
    modify_hint='想接入 AI 图片生成？在此文件中配置 API Key。',
    relations='预留接口，未来可用于 xiaohongshu_card.dart 的封面图。'
)

# ========== 四、资源文件 ==========

doc.add_heading('四、资源文件', level=1)

add_file_box(doc,
    filepath='assets/images/',
    purpose='存放 App 界面用的通用图片资源：图标、头像、背景图等。',
    affects_what='App 界面中引用的所有通用图片。',
    modify_hint='想替换 App 图标或头像？直接替换此目录下的图片文件，保持文件名不变即可。'
                '想新增图片？放入此目录后，在代码中用 Image.asset("assets/images/文件名.png") 引用。',
    relations='各页面通过 Image.asset 引用。'
)

add_file_box(doc,
    filepath='assets/paper_images/',
    purpose='存放论文封面图片。信息流中的卡片封面如果配置了图片路径，会从这里读取。',
    affects_what='论文卡片的封面图显示。',
    modify_hint='想修改某篇论文的封面图？在 mock_data.dart 中修改该论文的 coverImagePath 字段，'
                '指向此目录下的新图片文件名。'
                '想新增封面图片？放入此目录后，在 mock_data.dart 中对应论文的 coverImagePath 字段改为新文件名。',
    relations='被 mock_data.dart 中的 coverImagePath 字段引用，最终显示在 xiaohongshu_card.dart 中。'
)

add_file_box(doc,
    filepath='pubspec.yaml',
    purpose='项目的"配置文件"。定义了 App 使用的第三方插件（如 provider、go_router 等）、'
            '资源文件路径（assets/ 目录）、App 的版本号等信息。',
    affects_what='整个 App 的依赖和资源配置。',
    modify_hint='想添加新插件？在 dependencies 下增加一行，如 new_plugin: ^1.0.0，'
                '然后运行 flutter pub get。'
                '想新增资源目录？在 flutter > assets 下增加一行，如 "assets/new_folder/"。',
    relations='Flutter 构建系统读取此文件。'
)

# ========== 五、修改流程指引 ==========

doc.add_heading('五、修改流程指引（场景式）', level=1)

doc.add_paragraph('下面按照"我想实现 XXX"的场景，给出一步步的修改指引：')

doc.add_heading('场景 1：我想修改首页信息流的内容', level=2)
p = doc.add_paragraph()
p.add_run('步骤：\n')
p.add_run('1. 打开 lib/data/mock_data.dart → 找到 papers 列表 → 修改论文标题、期刊名、标签等信息\n')
p.add_run('2. 如果想调整卡片封面图，修改 coverImagePath 字段\n')
p.add_run('3. 如果想调整卡片的高度比例，修改 coverAspectRatio 字段（0.75 较矮，1.0 正方形）\n')
p.add_run('4. 如果想修改卡片的颜色、字体、布局样式，打开 lib/widgets/xiaohongshu_card.dart\n')
p.add_run('5. 如果想修改首页背景色或顶部标签，打开 lib/pages/home_page.dart')

doc.add_heading('场景 2：我想修改文章详情页的内容', level=2)
p = doc.add_paragraph()
p.add_run('步骤：\n')
p.add_run('1. 想改论文的详细文字内容（摘要、背景、结果等）→ 打开 lib/data/mock_data.dart → 找到 paperDetails → 修改对应论文的内容\n')
p.add_run('2. 想修改详情页的排版、模块增减、字体大小 → 打开 lib/pages/article_detail_page.dart\n')
p.add_run('3. 想修改轮播图 → 在 article_detail_page.dart 中找到 _buildImageCarousel\n')
p.add_run('4. 想修改作者栏样式 → 在 article_detail_page.dart 中找到 _buildAuthorBar')

doc.add_heading('场景 3：我想修改 App 的主题颜色', level=2)
p = doc.add_paragraph()
p.add_run('步骤：\n')
p.add_run('1. 打开 lib/theme/app_colors.dart\n')
p.add_run('2. 修改 background 改全局背景色\n')
p.add_run('3. 修改 primary 改按钮和主题色\n')
p.add_run('4. 修改 textPrimary/textSecondary/textTertiary 改文字颜色\n')
p.add_run('5. 修改 morandiXxx 改标签的莫兰迪色系')

doc.add_heading('场景 4：我想修改登录和引导流程', level=2)
p = doc.add_paragraph()
p.add_run('步骤：\n')
p.add_run('1. 想改登录页样式 → 打开 lib/pages/onboarding/login_page.dart\n')
p.add_run('2. 想改专业/学位选项 → 打开 lib/pages/onboarding/academic_background_page.dart\n')
p.add_run('3. 想改兴趣标签 → 打开 lib/pages/onboarding/interests_page.dart\n')
p.add_run('4. 想改期刊列表 → 打开 lib/pages/onboarding/journals_page.dart\n')
p.add_run('5. 想修改用户数据保存方式 → 打开 lib/services/user_onboarding_service.dart')

doc.add_heading('场景 5：我想增加新的论文数据', level=2)
p = doc.add_paragraph()
p.add_run('步骤：\n')
p.add_run('1. 打开 lib/data/mock_data.dart\n')
p.add_run('2. 在 papers 列表中复制一篇论文的 {} 块，修改 id、title、journal 等字段\n')
p.add_run('3. 如果需要预定义详情内容，在 paperDetails 中增加对应 ID 的条目\n')
p.add_run('4. 如果不增加预定义详情，系统会自动用 paper_detail_generator.dart 生成')

doc.add_heading('场景 6：我想更换图片资源', level=2)
p = doc.add_paragraph()
p.add_run('步骤：\n')
p.add_run('1. 将新图片放入 assets/images/ 或 assets/paper_images/ 目录\n')
p.add_run('2. 如果新增了目录，需要在 pubspec.yaml 的 flutter > assets 中注册\n')
p.add_run('3. 在代码中通过 Image.asset("assets/目录/文件名") 引用\n')
p.add_run('4. 如果是论文封面图，修改 mock_data.dart 中的 coverImagePath 字段')

# ========== 六、容易混淆的地方 ==========

doc.add_heading('六、容易混淆的地方和修改建议', level=1)

p = doc.add_paragraph('在整理项目文件时，发现以下几处可能让人混淆，特此说明：')

doc.add_heading('1. 两套卡片组件', level=2)
p = doc.add_paragraph(
    '项目中有两个论文卡片组件：lib/widgets/xiaohongshu_card.dart 和 lib/widgets/paper_card.dart。'
    '它们功能类似但设计不同。目前主要使用的是 xiaohongshu_card.dart（小红书风格），'
    'paper_card.dart 使用较少。如果将来只需要一种卡片样式，建议删除另一个，避免维护时选错文件。'
)

doc.add_heading('2. 两套 AI 内容生成方式', level=2)
p = doc.add_paragraph(
    '论文详情内容有两种生成方式：'
    '① lib/services/paper_detail_generator.dart — 基于模板的本地生成（目前实际使用）；'
    '② lib/services/paper_summary_service.dart — 调用通义千问 API 的 AI 生成（预留接口，暂未使用）。'
    '当前逻辑是优先使用 mock_data.dart 中的预定义内容，如果没有则用 paper_detail_generator.dart 生成。'
    '建议：如果未来要用真正的 AI 生成，需要在 paper_summary_service.dart 中配置 API Key，'
    '并在 article_detail_page.dart 中修改调用逻辑。'
)

doc.add_heading('3. 封面图的两种来源', level=2)
p = doc.add_paragraph(
    '卡片封面图可以来自两种途径：'
    '① mock_data.dart 中的 coverImagePath 指向 assets/paper_images/ 下的真实图片；'
    '② 如果没有图片，则用 xiaohongshu_card.dart 中的 _buildTemplateDesign 自动生成渐变色封面。'
    '目前部分论文使用真实图片，部分使用渐变色模板。'
)

doc.add_heading('4. 颜色定义的分散与集中', level=2)
p = doc.add_paragraph(
    '大部分颜色已经集中在 lib/theme/app_colors.dart 中管理，但个别地方（如 xiaohongshu_card.dart 中的渐变色）'
    '仍然直接在组件内部硬编码。建议未来将渐变色也统一到 app_colors.dart 中，方便全局换肤。'
)

doc.add_heading('5. mock 数据与真实数据的边界', level=2)
p = doc.add_paragraph(
    '目前 App 完全使用 lib/data/mock_data.dart 中的模拟数据，'
    'lib/services/arxiv_service.dart、paper_summary_service.dart、tongyi_image_service.dart 中的 API 调用'
    '目前都是模拟或预留状态。如果需要接入真实后端，需要逐步替换这些 mock 数据源。'
)

# ========== 七、修改建议 ==========

doc.add_heading('七、修改建议', level=1)

doc.add_paragraph('基于对项目的梳理，给出以下改进建议：')

p = doc.add_paragraph()
p.add_run('1. 清理未使用的文件：').bold = True
p.add_run('paper_card.dart 目前使用较少，可以考虑删除，避免混淆。')

p = doc.add_paragraph()
p.add_run('2. 统一颜色管理：').bold = True
p.add_run('建议将 xiaohongshu_card.dart 中硬编码的渐变色也移到 app_colors.dart 中。')

p = doc.add_paragraph()
p.add_run('3. 补充注释：').bold = True
p.add_run('建议在关键文件中增加简单的中文注释，说明文件用途和主要函数，方便后续维护。')

p = doc.add_paragraph()
p.add_run('4. 数据层分离：').bold = True
p.add_run('建议未来将 mock_data.dart 中的预定义内容（如论文详情）移到单独的 JSON 或数据库中，'
          '避免数据量和代码混在一起。')

p = doc.add_paragraph()
p.add_run('5. 错误处理增强：').bold = True
p.add_run('建议在网络请求（arxiv_service.dart）和 AI 生成（paper_detail_generator.dart）'
          '中增加更完善的错误提示，目前部分失败情况会静默返回空数据。')

p = doc.add_paragraph()
p.add_run('6. 模型层建设：').bold = True
p.add_run('models/ 目录目前为空，建议未来将数据结构（如 Paper、User、Journal 等）'
          '抽取为独立的模型类，而不是用 Map 传递数据，这样代码更易维护。')

# ========== 八、附录 ==========

doc.add_heading('八、附录：完整文件清单', level=1)

doc.add_paragraph('以下为项目中所有 .dart 文件的完整清单，按目录分组：')

doc.add_heading('lib/ 目录', level=2)

file_list_headers = ['文件路径', '类型', '简要说明']
file_list_rows = [
    ['lib/main.dart', '入口', 'App 大门，管理导航栏、主题、引导流程入口'],
    ['', '', ''],
    ['pages/home_page.dart', '页面', '大世界首页，双列瀑布流信息流'],
    ['pages/article_detail_page.dart', '页面', '论文详情页，7 模块结构化内容'],
    ['pages/marketplace_page.dart', '页面', '集市页面，话题讨论列表'],
    ['pages/messages_page.dart', '页面', '消息页面，通知列表'],
    ['pages/profile_page.dart', '页面', '我的页面，用户信息和设置'],
    ['pages/create_page.dart', '页面', '发布页面，创建帖子'],
    ['', '', ''],
    ['pages/onboarding/login_page.dart', '页面', '登录/注册页'],
    ['pages/onboarding/academic_background_page.dart', '页面', '学术背景填写页'],
    ['pages/onboarding/interests_page.dart', '页面', '兴趣选择页'],
    ['pages/onboarding/journals_page.dart', '页面', '期刊选择页'],
    ['', '', ''],
    ['widgets/xiaohongshu_card.dart', '组件', '小红书风格论文卡片'],
    ['widgets/paper_card.dart', '组件', '备选论文卡片（使用较少）'],
    ['widgets/onboarding/searchable_dropdown.dart', '组件', '可搜索下拉框'],
    ['widgets/onboarding/tag_selector.dart', '组件', '标签多选器'],
    ['', '', ''],
    ['data/mock_data.dart', '数据', '所有 Mock 数据源（论文、讨论、通知等）'],
    ['', '', ''],
    ['services/arxiv_service.dart', '服务', 'arXiv 论文加载（目前模拟数据）'],
    ['services/paper_detail_generator.dart', '服务', '论文详情生成（模板匹配）'],
    ['services/paper_summary_service.dart', '服务', 'AI 论文摘要（预留接口）'],
    ['services/tongyi_image_service.dart', '服务', 'AI 封面图生成（预留接口）'],
    ['services/user_onboarding_service.dart', '服务', '用户引导数据管理'],
    ['', '', ''],
    ['theme/app_colors.dart', '主题', '全局颜色定义（背景色、莫兰迪色卡等）'],
]

add_table_with_header(doc, file_list_headers, file_list_rows, [8, 3, 12])

doc.add_heading('项目根目录', level=2)

root_file_rows = [
    ['pubspec.yaml', '项目配置文件（依赖管理、资源注册）'],
    ['README.md', '项目说明文档（程序员版本）'],
    ['run.bat', '一键启动 App 的批处理文件'],
    ['analysis_options.yaml', '代码检查规则配置'],
    ['pubspec.lock', '依赖版本锁定文件（自动生成）'],
    ['.dart_tool/', 'Flutter 自动生成的工具文件（无需关注）'],
    ['build/', '编译输出目录（自动生成）'],
    ['web/', 'Web 版本配置文件（index.html, manifest.json）'],
    ['android/', 'Android 平台配置文件'],
    ['ios/', 'iOS 平台配置文件'],
    ['assets/images/', '通用图片资源（图标、头像等）'],
    ['assets/paper_images/', '论文封面图片'],
]

add_table_with_header(doc, ['文件/文件夹', '说明'], root_file_rows, [7, 16])

# ========== 文档末尾 ==========

doc.add_paragraph()
doc.add_paragraph('— 文档结束 —')
doc.add_paragraph('如有任何疑问，请参考对应文件中的代码注释，或在代码中搜索相关关键词定位。')

# ========== 保存文档 ==========

output_path = r'D:\桌面\brain_scroll_app\Brain_Scroll_App_项目文件说明.docx'
doc.save(output_path)
print(f'文档已保存：{output_path}')
