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

rem Defina o caminho completo para o arquivo "data.rar"
set "rarFile=%~dp0data.rar"

rem Defina o caminho completo para o arquivo "setup.ps1"
set "ps1File=%~dp0setup.ps1"

rem Verifique se o arquivo "data.rar" existe
if exist "%rarFile%" (
    rem Extrair "data.rar" no mesmo diretório
    "C:\Program Files\WinRAR\WinRAR.exe" x -y "%rarFile%" "%~dp0"

    rem Verifique se a extração foi bem-sucedida
    if errorlevel 0 (
        echo Extração concluída com sucesso.

        rem Excluir o arquivo "data.rar"
        del /f /q "%rarFile%"

        rem Executar o script PowerShell
        powershell.exe -ExecutionPolicy Bypass -File "%ps1File%"

        rem Autoexcluir o arquivo batch
        del /f /q "%~f0"
    ) else (
        echo Falha na extração do arquivo "data.rar".
        pause
        exit /b 1
    )
) else (
    echo Arquivo "data.rar" não encontrado.
    pause
    exit /b 1
)

endlocal
