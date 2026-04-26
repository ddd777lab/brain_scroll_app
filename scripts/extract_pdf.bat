@echo off
chcp 65001 >nul
setlocal

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║         arXiv PDF 提取工具                              ║
echo ╚════════════════════════════════════════════════════════╝
echo.

if "%~1"=="" (
    echo ❌ 请提供 arXiv ID
    echo.
    echo 用法：scripts\extract_pdf.bat ^<arxiv_id^>
    echo.
    echo 示例：scripts\extract_pdf.bat 2306.14753
    echo.
    pause
    exit /b 1
)

set "ARXIV_ID=%~1"

echo 📥 arXiv ID: %ARXIV_ID%
echo.

REM 步骤 1: 下载 PDF
echo ════════════════════════════════════════════════════════
echo 步骤 1: 下载 PDF
echo ════════════════════════════════════════════════════════
"D:\online installer\flutter\bin\dart.bat" run scripts/extract_arxiv_pdf.dart %ARXIV_ID%
if errorlevel 1 (
    echo ❌ 下载失败
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════
echo 步骤 2: 提取文本和图片
echo ════════════════════════════════════════════════════════
python scripts/extract_arxiv_images.py %ARXIV_ID%
if errorlevel 1 (
    echo ❌ 提取失败
    echo.
    echo 请确保已安装 Python 依赖:
    echo   pip install pymupdf
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════
echo ✅ 完成!
echo ════════════════════════════════════════════════════════
echo.
echo 输出文件:
echo   📁 pdf_output\%ARXIV_ID%\
echo   📄   %ARXIV_ID%.pdf       - 原始 PDF
echo   📝   full_text.txt       - 提取的文本
echo   🖼️   figures\            - 提取的所有图片
echo.

pause
