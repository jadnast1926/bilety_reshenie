@echo off
chcp 65001 > nul

:: =================== НАСТРОЙКИ ПУТЕЙ ===================
set PLATFORM="C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe"
set BASE_PATH="C:\Users\Дамир\OneDrive\Документы\OperAccounting"
set EXPORT_ROOT="C:\Users\Дамир\билеты_по_платформе_решение"
set DB_USER=""
set DB_PASS=""
:: =======================================================

echo ===================================================
echo   АВТОМАТИЧЕСКОЕ СОХРАНЕНИЕ БИЛЕТА В GIT
echo ===================================================
echo.

:: Автоматическая проверка и восстановление .gitignore, если его стерло
cd /d "%EXPORT_ROOT%"
if not exist ".gitignore" (
    echo === Восстановление .gitignore... ===
    echo **/ConfigDumpInfo.xml> .gitignore
)

set /p TASK_NAME="Введи название задачи или номер билета (например Bilet_01): "

:: Точный путь к папке конкретного билета
set "EXPORT_DIR=%EXPORT_ROOT%\%TASK_NAME%"

echo === Шаг 1. Безопасная очистка папки для задачи %TASK_NAME%... ===
if exist "%EXPORT_DIR%" (
    cd /d "%EXPORT_DIR%"
    for /d %%i in (*) do rmdir /s /q "%%i"
    del /q *.*
    cd /d "%EXPORT_ROOT%"
) else (
    mkdir "%EXPORT_DIR%"
)

echo === Шаг 2. Выгрузка конфигурации 1С в папку %TASK_NAME%... ===
%PLATFORM% DESIGNER /F "%BASE_PATH%" /N %DB_USER% /P %DB_PASS% /DumpConfigToFiles "%EXPORT_DIR%" /Out "%EXPORT_ROOT%\1c_logs.txt"

echo === Шаг 3. Индексация файлов в Git... ===
cd /d "%EXPORT_ROOT%"
git add .

echo === Шаг 4. Создание коммита для %TASK_NAME%... ===
git commit -m "Сохранение конфигурации для задачи: %TASK_NAME% (%date% %time%)"

echo === Шаг 5. Отправка на Гит... ===
git push origin main

echo.
echo === ВСЁ ГОТОВО! Задача %TASK_NAME% успешно изолирована и отправлена ===
pause
