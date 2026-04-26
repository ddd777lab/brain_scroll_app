@echo off
setlocal

set "FLUTTER_PATH=D:\online installer\flutter"

set "QUERY=%~1"
set "COUNT=%~2"

if "%QUERY%"=="" set "QUERY=neural population coding"
if "%COUNT%"=="" set "COUNT=2"

echo.
echo ========================================
echo    论文封面自动生成工具
echo ========================================
echo.
echo 提示：首次运行前请设置 API Key 环境变量
echo.
echo 临时设置 (当前窗口有效):
echo   set TONGYI_API_KEY=你的 API Key
echo.
echo 永久设置 (重启后有效):
echo   右键此电脑 - 属性 - 高级系统设置 - 环境变量
echo   新建系统变量：TONGYI_API_KEY
echo.
echo ========================================
echo.

"%FLUTTER_PATH%\bin\dart.bat" run scripts/generate_covers.dart --query=%QUERY% --count=%COUNT%

echo.
echo Done!
pause