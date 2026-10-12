@echo off
setlocal
pushd "%~dp0"
set "GODOT_EXE="
for /f "delims=" %%G in ('where.exe Godot_v4.7.2-stable_win64.exe 2^>nul') do if not defined GODOT_EXE set "GODOT_EXE=%%G"
if not defined GODOT_EXE (
  for /f "delims=" %%G in ('where.exe godot.exe 2^>nul') do if not defined GODOT_EXE set "GODOT_EXE=%%G"
)
if not defined GODOT_EXE (
  if exist "%LOCALAPPDATA%\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe" set "GODOT_EXE=%LOCALAPPDATA%\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe"
)
if not defined GODOT_EXE (
  echo ERRO: Godot 4.7.2 nao encontrada. Configure-a no PATH ou informe o caminho do executavel.
  pause
  exit /b 2
)
echo.
echo [1/2] Importando o projeto...
"%GODOT_EXE%" --headless --path . --import
if errorlevel 1 goto :fail
echo.
echo [2/2] Rodando verificacoes do prototipo modular...
"%GODOT_EXE%" --headless --path . --script res://tests/smoke.gd
if errorlevel 1 goto :fail
echo.
echo RESULTADO: verificacoes automatizadas aprovadas.
echo Abra o jogo em janela e teste os tres ambientes antes do merge.
pause
popd
exit /b 0
:fail
echo.
echo RESULTADO: falha nos testes. Copie ou fotografe esta janela e envie para revisao.
pause
popd
exit /b 1
