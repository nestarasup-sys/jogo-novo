@echo off
setlocal

set "PROJECT_DIR=%~dp0"
set "GODOT_EXE=%LOCALAPPDATA%\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe"

if not exist "%GODOT_EXE%" set "GODOT_EXE="

if not defined GODOT_EXE (
    for /f "delims=" %%G in ('where.exe Godot_v4.7.2-stable_win64.exe 2^>nul') do if not defined GODOT_EXE set "GODOT_EXE=%%G"
)

if not defined GODOT_EXE (
    echo Godot 4.7.2 nao foi encontrado.
    echo Instale a versao Godot 4.7.2 ou adicione o executavel ao PATH.
    pause
    exit /b 1
)

start "Jogo Novo" "%GODOT_EXE%" --path "%PROJECT_DIR%"
endlocal
