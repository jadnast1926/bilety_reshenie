@echo off
chcp 65001 > nul

:: --- НАСТРОЙКИ ---
set PLATFORM="C:\Program Files (x86)\1cv8t\8.3.27.1508\bin\1cv8t.exe"
set BASE_PATH="C:\Users\Дамир\OneDrive\Документы\OperAccounting"
set EXPORT_DIR="C:\Users\Дамир\билеты_по_платформе_решение"
set DB_USER=""
set DB_PASS=""

echo === 0. Очистка папки от старых файлов ===
:: Переходим в папку проекта
cd /d %EXPORT_DIR%
:: Удаляем все папки, кроме скрытой .git
for /d %%i in (*) do rmdir /s /q "%%i"
:: Удаляем все файлы, кроме .gitignore и .bat
for %%i in (*) do if not "%%i"==".gitignore" if not "%%i"=="upload_to_git.bat" del /q "%%i"

echo === 1. Выгрузка конфигурации из 1С в файлы... ===
%PLATFORM% DESIGNER /F %BASE_PATH% /N %DB_USER% /P %DB_PASS% /DumpConfigToFiles %EXPORT_DIR% /Out "%EXPORT_DIR%\1c_logs.txt" -NoTruncate

echo === 2. Подготовка файлов в Git... ===
git add .

echo === 3. Создание коммита... ===
git commit -m "Авто-коммит от %date% %time%"

echo === 4. Отправка на удаленный сервер... ===
git push origin main

echo === ГОТОВО! ===
pause