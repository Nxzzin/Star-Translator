@echo off
setlocal

rem Cria o arquivo Instalando.ps1 com o conteúdo fornecido
echo # Define URLs e caminhos > Instalando.ps1
echo $remoteUrl = "https://raw.githubusercontent.com/Nxzzin/Star-Translator/main/Versions/EPTU/global.ini" >> Instalando.ps1
echo $localDir = "data/Localization/portuguese_(brazil)" >> Instalando.ps1
echo $localFile = "$localDir/global.ini" >> Instalando.ps1
echo $userCfg = "user.cfg" >> Instalando.ps1
echo. >> Instalando.ps1
echo # Cria a pasta, se necessário >> Instalando.ps1
echo if (!(Test-Path $localDir)) { >> Instalando.ps1
echo     New-Item -ItemType Directory -Path $localDir >> Instalando.ps1
echo } >> Instalando.ps1
echo. >> Instalando.ps1
echo # Mensagem personalizada para o download >> Instalando.ps1
echo Write-Host "Baixando versao atualizada, por favor aguarde..." >> Instalando.ps1
echo. >> Instalando.ps1
echo # Baixa o arquivo do GitHub >> Instalando.ps1
echo Invoke-WebRequest -Uri $remoteUrl -OutFile $localFile -UseBasicParsing >> Instalando.ps1
echo. >> Instalando.ps1
echo # Verifica se o arquivo user.cfg existe >> Instalando.ps1
echo if (!(Test-Path $userCfg)) { >> Instalando.ps1
echo     New-Item -ItemType File -Path $userCfg >> Instalando.ps1
echo } >> Instalando.ps1
echo. >> Instalando.ps1
echo # Lê o arquivo user.cfg >> Instalando.ps1
echo $fileContent = Get-Content $userCfg >> Instalando.ps1
echo. >> Instalando.ps1
echo # Verifica e atualiza as linhas >> Instalando.ps1
echo $updatedContent = @() >> Instalando.ps1
echo $foundLanguage = $false >> Instalando.ps1
echo $foundLanguageAudio = $false >> Instalando.ps1
echo. >> Instalando.ps1
echo foreach ($line in $fileContent) { >> Instalando.ps1
echo     if ($line -like "g_language =*") { >> Instalando.ps1
echo         $updatedContent += "g_language = portuguese_(brazil)" >> Instalando.ps1
echo         $foundLanguage = $true >> Instalando.ps1
echo     } elseif ($line -like "g_languageAudio =*") { >> Instalando.ps1
echo         $updatedContent += "g_languageAudio = english" >> Instalando.ps1
echo         $foundLanguageAudio = $true >> Instalando.ps1
echo     } else { >> Instalando.ps1
echo         $updatedContent += $line >> Instalando.ps1
echo     } >> Instalando.ps1
echo } >> Instalando.ps1
echo. >> Instalando.ps1
echo # Adiciona as linhas, se necessário >> Instalando.ps1
echo if (!$foundLanguage) { >> Instalando.ps1
echo     $updatedContent += "g_language = portuguese_(brazil)" >> Instalando.ps1
echo } >> Instalando.ps1
echo if (!$foundLanguageAudio) { >> Instalando.ps1
echo     $updatedContent += "g_languageAudio = english" >> Instalando.ps1
echo } >> Instalando.ps1
echo. >> Instalando.ps1
echo # Escreve o conteúdo atualizado de volta para o arquivo user.cfg >> Instalando.ps1
echo [System.IO.File]::WriteAllLines($userCfg, $updatedContent) >> Instalando.ps1
echo. >> Instalando.ps1
echo # Obtém o caminho completo do script >> Instalando.ps1
echo $thisScript = $MyInvocation.MyCommand.Path >> Instalando.ps1
echo. >> Instalando.ps1
echo # Auto-exclui o script após a execução >> Instalando.ps1
echo Start-Sleep -Seconds 1 # Espera 1 segundo antes de excluir o script >> Instalando.ps1
echo Remove-Item $thisScript -Force >> Instalando.ps1

rem Executa o script PowerShell
powershell.exe -ExecutionPolicy Bypass -File Instalando.ps1

endlocal

rem Exclui o próprio arquivo .bat
del "%~f0"
