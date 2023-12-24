# Verifica se o arquivo "user.cfg" existe
if (Test-Path -Path ".\user.cfg") {
    # Arquivo existe, lê o conteúdo
    $content = Get-Content -Path ".\user.cfg" -Raw
    
    # Verifica se as substrings estão presentes no conteúdo
    $languageSubstring = "g_language ="
    $audioLanguageSubstring = "g_languageAudio ="

    $languageIndex = $content.IndexOf($languageSubstring)
    $audioLanguageIndex = $content.IndexOf($audioLanguageSubstring)

    if ($languageIndex -ge 0 -and $audioLanguageIndex -ge 0) {
        # Substitui as linhas correspondentes
        $content = $content -replace "$languageSubstring.*", "$languageSubstring portuguese_(brazil)"
        $content = $content -replace "$audioLanguageSubstring.*", "$audioLanguageSubstring english"
    }
    else {
        # Adiciona as linhas que faltam
        $content += "`n$languageSubstring portuguese_(brazil)"
        $content += "`n$audioLanguageSubstring english"
    }

    # Escreve o conteúdo modificado de volta no arquivo
    $content | Set-Content -Path ".\user.cfg"
}
else {
    # Cria o arquivo "user.cfg" se não existir
    "g_language = portuguese_(brazil)`ng_languageAudio = english" | Out-File -FilePath ".\user.cfg"
}

# Autoexclui o script
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
