@echo off
chcp 65001 >nul
echo ========================================
echo   一键推送到 GitHub Pages
echo ========================================
echo.

cd /d "%~dp0"

REM 检查 git 是否安装
git --version >nul 2>&1
if errorlevel 1 (
    echo × 未检测到 Git，请先安装 Git for Windows: https://git-scm.com/download/win
    pause
    exit /b 1
)

REM 检查是否已初始化仓库
if not exist ".git" (
    echo 首次推送，请先按照 DEPLOY.md 完成 Git 仓库配置。
    echo.
    echo 提示：需要先执行:
    echo   git init
    echo   git remote add origin https://github.com/你的用户名/仓库名.git
    echo.
    pause
    exit /b 1
)

echo 检查改动...
git status --short

echo.
set /p CONFIRM=确认推送? (Y/N): 
if /i not "%CONFIRM%"=="Y" (
    echo 已取消。
    pause
    exit /b 0
)

git add data.js prices.json index.html build_site.py
git commit -m "update: 数据刷新 %date% %time%"
git push

if %errorlevel% equ 0 (
    echo.
    echo ✓ 推送完成！网站将在 1-2 分钟后自动更新。
) else (
    echo.
    echo × 推送失败，请检查网络或凭证。
)
pause
