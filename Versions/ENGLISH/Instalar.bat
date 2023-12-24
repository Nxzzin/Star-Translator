@echo off
setlocal

:: Caminho do script PowerShell
set "scriptPath=%~dp0setup.ps1"

:: Executa o script PowerShell
powershell.exe -ExecutionPolicy Bypass -File "%scriptPath%"

:: Aguarda por 2 segundos
timeout /t 2 /nobreak > nul

:: Autoexclui o arquivo de lote
del "%~f0"
