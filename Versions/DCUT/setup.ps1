# Verifica se o arquivo "user.cfg" existe
if (Test-Path -Path ".\user.cfg") {
    # Verifica se há linhas com as substrings
    $fileContent = Get-Content -Path ".\user.cfg"
    
    $languageLineIndex = $fileContent | Select-String -Pattern "g_language\s*=" | ForEach-Object { $_.LineNumber - 1 }
    $languageAudioLineIndex = $fileContent | Select-String -Pattern "g_languageAudio\s*=" | ForEach-Object { $_.LineNumber - 1 }

    if ($languageLineIndex -ne $null -and $languageAudioLineIndex -ne $null) {
        # Atualiza as linhas correspondentes
        $fileContent[$languageLineIndex] = "g_language = portuguese_(brazil)"
        $fileContent[$languageAudioLineIndex] = "g_languageAudio = english"

        # Salva as alterações no arquivo
        $fileContent | Set-Content -Path ".\user.cfg"
    }
} else {
    # Cria o arquivo "user.cfg" se não existir
    New-Item -Path ".\user.cfg" -ItemType File
}

# Autoexclui o script .ps1
Remove-Item -Path $MyInvocation.MyCommand.Path
