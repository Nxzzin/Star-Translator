# Caminho do arquivo user.cfg
$arquivoUserCfg = ".\user.cfg"
# Caminho do script atual
$caminhoScript = $MyInvocation.MyCommand.Path

# Verifica se o arquivo user.cfg existe
if (Test-Path $arquivoUserCfg) {
    # Verifica se o arquivo user.cfg possui as linhas específicas
    $linhasExistentes = Get-Content $arquivoUserCfg | Where-Object { $_ -match "g_language" -or $_ -match "g_languageAudio" }

    if ($linhasExistentes.Count -gt 0) {
        # Remove as linhas com as substrings
        $novasLinhas = Get-Content $arquivoUserCfg | Where-Object { $_ -notmatch "g_language" -and $_ -notmatch "g_languageAudio" }
        # Escreve o conteúdo atualizado de volta para o arquivo
        [System.IO.File]::WriteAllLines($arquivoUserCfg, $novasLinhas)

        # Autoexclui o script
        Remove-Item $caminhoScript -Force
    } else {
        # Autoexclui o script, pois não há linhas com as substrings
        Remove-Item $caminhoScript -Force
    }
} else {
    # Autoexclui o script, pois o arquivo user.cfg não existe
    Remove-Item $caminhoScript -Force
}