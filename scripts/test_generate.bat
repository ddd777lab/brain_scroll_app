@echo off
setlocal

REM 设置 API Key 环境变量
set "TONGYI_API_KEY=sk-3929951e57bb4fbfbfa0ecde47e777de"

echo 已设置环境变量 TONGYI_API_KEY
echo.

"D:\online installer\flutter\bin\dart.bat" run scripts/generate_covers.dart %*

endlocal
pause
