@echo off

rem Defina o caminho completo para a pasta "resources" em %appdata%
set "resourcesFolder=%appdata%\resources"

rem Verifique se a pasta "resources" existe
if exist "%resourcesFolder%" (
    rem Apagar o conteúdo da pasta "resources"
    for /d %%i in ("%resourcesFolder%\*") do rmdir /s /q "%%i"
    del /q "%resourcesFolder%\*.*"
    echo Conteúdo da pasta "resources" removido com sucesso.
) else (
    echo Pasta "resources" não encontrada em %appdata%.
)

setlocal

rem Defina o caminho completo para o arquivo "global.ini"
set "iniFile=%~dp0global.ini"

rem Defina o caminho completo para o diretório "data/Localization/portuguese_(brazil)"
set "targetDir=%~dp0data\Localization\french_(france)"

rem Verifique se o arquivo "global.ini" existe
if exist "%iniFile%" (
    rem Crie o diretório de destino, se necessário
    mkdir "%targetDir%" 2>nul

    rem Move o arquivo "global.ini" para o diretório de destino
    move /y "%iniFile%" "%targetDir%"

    rem Verifique se a movimentação foi bem-sucedida
    if not errorlevel 1 (
        echo Arquivo "global.ini" movido com sucesso para "%targetDir%".

        rem Executar o script PowerShell
        powershell.exe -ExecutionPolicy Bypass -File "%~dp0setup.ps1"

        rem Autoexcluir o arquivo batch
        del /f /q "%~f0"
    ) else (
        echo Falha ao mover o arquivo "global.ini".
        pause
        exit /b 1
    )
) else (
    echo Arquivo "global.ini" não encontrado.
    pause
    exit /b 1
)

endlocal
