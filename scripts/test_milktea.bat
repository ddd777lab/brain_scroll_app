@echo off
chcp 65001 >nul
setlocal

REM 设置 API Key
set "TONGYI_API_KEY=sk-3929951e57bb4fbfbfa0ecde47e777de"

echo.
echo ========================================
echo    测试：奶茶上瘾主题封面生成
echo ========================================
echo.

cd /d "%~dp0.."

"D:\online installer\flutter\bin\dart.bat" run scripts/generate_covers.dart --query="milk tea addiction" --count=2

echo.
echo 完成！
pause
