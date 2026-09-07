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
:: Скрипт останавливается и ждет, пока ты введешь имя папки (например: Bilet_01)
set /p TASK_NAME="Введи название задачи или номер билета (БЕЗ ПРОБЕЛОВ, латиницей или цифрами, например Bilet_01): "

:: Формируем точный путь к изолированной папке для этого билета
set EXPORT_DIR=%EXPORT_ROOT%\%TASK_NAME%

echo.
echo === Шаг 1. Изолированная очистка папки для %TASK_NAME%... ===
:: Если папка для этого билета уже была, очищаем только её, другие билеты скрипт НЕ тронет!
if exist "%EXPORT_DIR%" (
    for /d %%i in ("%EXPORT_DIR%\*") do rmdir /s /q "%%i"
    for %%i in ("%EXPORT_DIR%\*") do del /q "%%i"
) else (
    mkdir "%EXPORT_DIR%"
)

echo === Шаг 2. Выгрузка конфигурации 1С в папку %TASK_NAME%... ===
%PLATFORM% DESIGNER /F %BASE_PATH% /N %DB_USER% /P %DB_PASS% /DumpConfigToFiles "%EXPORT_DIR%" /Out "%EXPORT_ROOT%\1c_logs.txt" -NoTruncate

echo === Шаг 3. Индексация файлов в Git... ===
cd /d %EXPORT_ROOT%
git add .

echo === Шаг 4. Создание коммита для %TASK_NAME%... ===
git commit -m "Сохранение конфигурации для задачи: %TASK_NAME% (%date% %time%)"

echo === Шаг 5. Отправка на Гит... ===
git push origin main

echo.
echo === ВСЁ ГОТОВО! Задача %TASK_NAME% успешно изолирована и отправлена ===
pause
