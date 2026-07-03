@echo off
chcp 65001 >nul
echo ========================================
echo   券商金股网站 - 一键更新
echo ========================================
echo.
echo [步骤1] 检查是否有新的梳理文件需要生成总结...
echo.

cd /d "%~dp0\.."

REM 查找最新的梳理文件和总结文件，对比月份
setlocal enabledelayedexpansion
set LATEST_COMB=
for /f "delims=" %%f in ('dir /b /o-n "*梳理*.xlsx" 2^>nul') do (
    if not defined LATEST_COMB set "LATEST_COMB=%%f"
)

if not defined LATEST_COMB (
    echo 未找到梳理文件！
    pause
    exit /b 1
)

echo 最新梳理文件: %LATEST_COMB%

REM 提取梳理文件月份 (从文件名中提取YYYYMMDD)
for /f "tokens=1 delims=." %%a in ("%LATEST_COMB%") do set COMB_BASE=%%a
set COMB_DATE=%COMB_BASE:~-8%
set COMB_MONTH=%COMB_DATE:~4,2%
set /a COMB_MONTH_NUM=1%COMB_MONTH% - 100

REM 检查对应月份的总结文件是否存在
set SUMMARY_EXISTS=
for /f "delims=" %%f in ('dir /b /o-n "*总结*%COMB_DATE%*.xlsx" 2^>nul') do (
    set "SUMMARY_EXISTS=%%f"
)

if defined SUMMARY_EXISTS (
    echo 总结文件已存在: %SUMMARY_EXISTS%
    echo 跳过生成步骤，直接构建网站...
) else (
    echo 需要生成 %COMB_MONTH_NUM%月 总结...

    REM 找上月总结文件
    set PREV_SUMMARY=
    for /f "delims=" %%f in ('dir /b /o-n "*总结*.xlsx" 2^>nul') do (
        if not defined PREV_SUMMARY set "PREV_SUMMARY=%%f"
    )

    set OUTPUT_NAME=南方基金券商月度金股总结_%COMB_DATE%.xlsx
    echo 生成: !OUTPUT_NAME!
    python generate_monthly_gold_stock.py "%LATEST_COMB%" "!PREV_SUMMARY!" "!OUTPUT_NAME!" %COMB_MONTH_NUM%

    if errorlevel 1 (
        echo × 总结生成失败！
        pause
        exit /b 1
    )
    echo ✓ 总结生成完成
)

echo.
echo [步骤2] 构建网站数据...
cd gold_stock_site
python build_site.py

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo ✓ 全部完成！正在打开网站...
    echo ========================================
    start "" "index.html"
) else (
    echo.
    echo × 网站构建失败！
    pause
)
