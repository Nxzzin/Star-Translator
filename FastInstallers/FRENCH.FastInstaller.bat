@echo off
setlocal

:: Configuração
set "GameVersion=LIVE"
set "Language=french_(france)"
:: Feature

:: Verifica se está na pasta correta
for %%A in ("%cd%") do set "CurrentFolder=%%~nxA"

if /I not "%CurrentFolder%"=="%GameVersion%" (
    echo ERRO: Este arquivo precisa ser executado dentro da pasta "...\StarCitizen\%GameVersion%".
	echo - Em casos de falta de permissao, executar o arquivo em uma pasta de nome %GameVersion% tambem funcionara!
    pause
    exit /b
)

echo Downloading and Installing localization...
echo ---------------------------------------------------------------------
:: Baixa global.ini
if not exist "data\localization\%Language%\" mkdir "data\Localization\%Language%"
curl -L "https://raw.githubusercontent.com/Dymerz/StarCitizen-Localization/main/data/Localization/%Language%/global.ini" -o "data\localization\%Language%\global.ini"

:: Configura User.cfg
if not exist "user.cfg" (
    echo g_language = %Language%> user.cfg
    echo g_languageAudio = english>> user.cfg
) else (
    findstr /v /b /c:"g_language = " /c:"g_languageAudio = " user.cfg > user.tmp
    echo g_language = %Language%>> user.tmp
    echo g_languageAudio = english>> user.tmp
    move /y user.tmp user.cfg >nul
)
echo ---------------------------------------------------------------------
echo Success, see you space cowboy...
timeout /t 2 >nul
endlocal
del "%~f0"
