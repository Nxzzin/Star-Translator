@echo off
setlocal enabledelayedexpansion

echo Desinstalando...
if exist "data\Localization\" (
    for /d %%d in ("data\Localization\*") do (
        rd /s /q "%%d" 2>nul
    )
)

if exist "user.cfg" (
    echo Verificando user.cfg...
    (for /f "tokens=*" %%a in (user.cfg) do (
        set "line=%%a"
        if not "!line:~0,11!"=="g_language " if not "!line:~0,16!"=="g_languageAudio " echo(!line!
    )) > user.cfg.tmp
    move /y user.cfg.tmp user.cfg >nul
)

endlocal
del "%~f0"