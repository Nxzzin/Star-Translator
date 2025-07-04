@echo off
setlocal enabledelayedexpansion
:: ESSE BATCH PASSARÁ PELO BAT2EXE

:: Verifica se ta na pasta RSI Launcher
for %%A in ("%cd%") do set "CurrentFolder=%%~nxA"
if /I not "%CurrentFolder%"=="RSI Launcher" (
    echo ERRO: Este arquivo precisa estar dentro da pasta "...\RSI Launcher\".
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

:: Carrega Config.ini
set "CONFIG_FILE=Config.ini"

:: Cria o arquivo Config.ini se não existir
if not exist "%CONFIG_FILE%" (
    echo Iniciando processo de configuracao...
    echo -----------------------------------------
    
    set /p "COMMON_PATH=Insira o caminho raiz da pasta LIVE (ex: E:\games\StarCitizen): "
    set /p "PTU_PATH=Insira o caminho raiz da pasta PTU: "
    set /p "EPTU_PATH=Insira o caminho raiz da pasta EPTU: "

    (
        echo [Config]
        echo LIVE=!COMMON_PATH!
        echo HOTFIX=!COMMON_PATH!
        echo PTU=!PTU_PATH!
        echo EPTU=!EPTU_PATH!
    ) > "%CONFIG_FILE%"
    echo Arquivo de configuracao criado com sucesso.
	echo -----------------------------------------
)
:: Lê os caminhos do INI
for %%G in (%FOLDERS%) do (
    for /f "tokens=1,* delims==" %%A in ('findstr /I "%%G=" "%CONFIG_FILE%"') do (
        set "%%A_PATH=%%B"
    )
)

set "GameVersions=0"
set "Trad=0"

:: Para cada pasta, verifica se existe e baixa global.ini
for %%F in (%FOLDERS%) do (
    set "ROOT=!%%F_PATH!"
    if exist "!ROOT!\%%F" (
        set "GameVersions=1"
        
        set "LOCAL_KEY=%%F_LOCAL"
        for %%A in (!LOCAL_KEY!) do set "LOCALIZATION=!%%A!"

        set "TARGET_FOLDER=!ROOT!\%%F\data\Localization\portuguese_(brazil)"

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

:: LIVE
set "LIVE_PATH=!LIVE_PATH!\LIVE\data\Localization\portuguese_(brazil)\global.ini"
if exist "!LIVE_PATH!" (
    echo LIVE esta rolando os dados...
    (
    echo $errosUrl = "https://raw.githubusercontent.com/Nxzzin/Star-Translator/refs/heads/main/Fun/erros.ini"
    echo $errosPath = "$env:TEMP\erros.ini"
    echo $globalIniPath = "!LIVE_PATH!"
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

:: HOTFIX
set "HOTFIX_PATH=!HOTFIX_PATH!\HOTFIX\data\Localization\portuguese_(brazil)\global.ini"
if exist "!HOTFIX_PATH!" (
    echo HOTFIX esta rolando os dados...
    (
    echo $errosUrl = "https://raw.githubusercontent.com/Nxzzin/Star-Translator/refs/heads/main/Fun/erros.ini"
    echo $errosPath = "$env:TEMP\erros.ini"
    echo $globalIniPath = "!HOTFIX_PATH!"
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

echo Abrindo RSI Launcher...
:End
timeout /t 3 /nobreak >nul
start "" "%cd%\RSI Launcher.exe"
exit
