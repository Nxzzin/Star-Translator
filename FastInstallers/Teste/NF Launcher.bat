@echo off
setlocal enabledelayedexpansion
:: ESSE BATCH PASSARÁ PELO BAT2EXE
:: Verifica se ta na pasta StarCitizen
set "CURRENT_DIR=%cd%"
for %%A in ("%cd%") do set "CurrentFolder=%%~nxA"

if /I not "%CurrentFolder%"=="StarCitizen" (
    echo ERRO: Este arquivo precisa estar dentro da pasta "...\StarCitizen\".
    pause
    exit /b
)

:: Feature
set "EnableBoboDaCorte=Yes"

:: Pastas verificadas
set FOLDERS=LIVE PTU EPTU HOTFIX

:: Localizations
set "LIVE_LOCAL=NovaFronteira"
set "HOTFIX_LOCAL=NovaFronteira"
set "PTU_LOCAL=PTU"
set "EPTU_LOCAL=EPTU"

set "GameVersions=0"
set "Trad=0"

for %%F in (%FOLDERS%) do (
    if exist "%%F" (
	set "GameVersions=1"

        set "LOCAL_KEY=%%F_LOCAL"
        for %%A in (!LOCAL_KEY!) do set "LOCALIZATION=!%%A!"
        set "TARGET_FOLDER=%%F\data\Localization\portuguese_(brazil)"

        if exist "!TARGET_FOLDER!" (
		set "Trad=1"
            echo Atualizando arquivo do %%F...
            curl -s -o "!TARGET_FOLDER!\global.ini" "https://raw.githubusercontent.com/Nxzzin/Star-Translator/main/Versions/!LOCALIZATION!/global.ini"
            if !errorlevel! == 0 (
                echo %%F atualizado com sucesso.
                echo -------------------------------------------------------
            ) else (
                echo [ERRO] Falha ao baixar para %%F.
            )
        )
    )
)

if "!GameVersions!"=="0" (
    echo Nenhuma das pastas LIVE, PTU ou EPTU foi encontrada.
    goto End
)

if "!Trad!"=="0" (
    echo Nenhuma pasta contem a traducao!
    goto End
)


:: BoboDaCorte - Exclusivo do LIVE e HOTFIX
if /I not "%EnableBoboDaCorte%"=="Yes" goto SkipBoboDaCorte
if exist "LIVE\data\Localization\portuguese_(brazil)\global.ini" (
    echo LIVE esta rolando os dados...
    (
    echo $errosUrl = "https://raw.githubusercontent.com/Nxzzin/Star-Translator/refs/heads/main/Fun/erros.ini"
    echo $errosPath = "$env:TEMP\erros.ini"
    echo $globalIniPath = "LIVE\data\Localization\portuguese_(brazil)\global.ini"
    echo Invoke-WebRequest -Uri $errosUrl -OutFile $errosPath
    echo $errosContent = Get-Content -Path $errosPath
    echo $randomLine = Get-Random -InputObject $errosContent
    echo $globalIniContent = Get-Content -Path $globalIniPath
    echo $pattern = "^(net_dialog_server_error,P=.*)$"
    echo $globalIniContent = $globalIniContent -replace $pattern, $randomLine
    echo Set-Content -Path $globalIniPath -Value $globalIniContent -Encoding UTF8
    echo Remove-Item -Path $errosPath
    echo Remove-Item -Path $MyInvocation.MyCommand.Path
    ) > BoboDaCorte_LIVE.ps1

    powershell.exe -ExecutionPolicy Bypass -File BoboDaCorte_LIVE.ps1
)

if exist "HOTFIX\data\Localization\portuguese_(brazil)\global.ini" (
    echo HOTFIX esta rolando os dados...
    (
    echo $errosUrl = "https://raw.githubusercontent.com/Nxzzin/Star-Translator/refs/heads/main/Fun/erros.ini"
    echo $errosPath = "$env:TEMP\erros.ini"
    echo $globalIniPath = "HOTFIX\data\Localization\portuguese_(brazil)\global.ini"
    echo Invoke-WebRequest -Uri $errosUrl -OutFile $errosPath
    echo $errosContent = Get-Content -Path $errosPath
    echo $randomLine = Get-Random -InputObject $errosContent
    echo $globalIniContent = Get-Content -Path $globalIniPath
    echo $pattern = "^(net_dialog_server_error,P=.*)$"
    echo $globalIniContent = $globalIniContent -replace $pattern, $randomLine
    echo Set-Content -Path $globalIniPath -Value $globalIniContent -Encoding UTF8
    echo Remove-Item -Path $errosPath
    echo Remove-Item -Path $MyInvocation.MyCommand.Path
    ) > BoboDaCorte_HOTFIX.ps1

    powershell.exe -ExecutionPolicy Bypass -File BoboDaCorte_HOTFIX.ps1
)

:SkipBoboDaCorte

echo Sucesso, abrindo RSI Launcher...
:end
timeout /t 3 /nobreak >nul
start "" "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Roberts Space Industries\RSI Launcher.lnk"
exit

