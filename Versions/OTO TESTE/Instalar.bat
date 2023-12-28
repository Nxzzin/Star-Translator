@echo off
setlocal

:: Define o caminho do script PowerShell
set "powershellScript=setup.ps1"

:: Executa o script PowerShell
powershell -ExecutionPolicy Bypass -File "%powershellScript%"

:: Exclui o script .bat
del "%~f0"