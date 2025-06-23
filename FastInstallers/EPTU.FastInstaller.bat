@echo off
setlocal

:: Configuração
set "GameVersion=EPTU"
set "Localization=EPTU"
set "Language=portuguese_(brazil)"
:: Feature
set "EnableBoboDaCorte=Yes"

:: Verifica se está na pasta correta
for %%A in ("%cd%") do set "CurrentFolder=%%~nxA"

if /I not "%CurrentFolder%"=="%GameVersion%" (
    echo ERRO: Este arquivo precisa ser executado dentro da pasta "...\StarCitizen\%GameVersion%".
	echo - Em casos de falta de permissao, executar o arquivo em uma pasta de nome %GameVersion% tambem funcionara!
    pause
    exit /b
)

:: Baixa global.ini
if not exist "data\localization\%Language%\" mkdir "data\Localization\%Language%"
curl -s -L "https://raw.githubusercontent.com/Nxzzin/Star-Translator/main/Versions/%Localization%/global.ini" -o "data\localization\%Language%\global.ini"

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

:: Extra
:: BoboDaCorte
if /I not "%EnableBoboDaCorte%"=="Yes" goto SkipBoboDaCorte
echo $errosUrl = "https://raw.githubusercontent.com/Nxzzin/Star-Translator/refs/heads/main/Fun/erros.ini" >> BoboDaCorte.ps1
echo $errosPath = "$env:TEMP\erros.ini" >> BoboDaCorte.ps1
echo $globalIniPath = "data/Localization/portuguese_(brazil)\global.ini" >> BoboDaCorte.ps1
echo Invoke-WebRequest -Uri $errosUrl -OutFile $errosPath >> BoboDaCorte.ps1
echo $errosContent = Get-Content -Path $errosPath >> BoboDaCorte.ps1
echo $randomLine = (Get-Random -InputObject $errosContent) >> BoboDaCorte.ps1
echo $globalIniContent = Get-Content -Path $globalIniPath >> BoboDaCorte.ps1
echo $pattern = "^(net_dialog_server_error,P=.*)$"  >> BoboDaCorte.ps1
echo $globalIniContent = $globalIniContent -replace $pattern, "$randomLine" >> BoboDaCorte.ps1
echo Set-Content -Path $globalIniPath -Value $globalIniContent -Encoding UTF8 >> BoboDaCorte.ps1
echo Remove-Item -Path $errosPath >> BoboDaCorte.ps1
echo Remove-Item -Path $MyInvocation.MyCommand.Path >> BoboDaCorte.ps1

rem Executa o script PowerShell
powershell.exe -ExecutionPolicy Bypass -File BoboDaCorte.ps1
:SkipBoboDaCorte

endlocal
del "%~f0"
