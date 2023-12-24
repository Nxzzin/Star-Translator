# Caminho do arquivo de configuração
$arquivoConfig = ".\user.cfg"

# Verifica se o arquivo USER.cfg existe
if (Test-Path $arquivoConfig) {
    # Lê o conteúdo do arquivo
    $conteudo = Get-Content $arquivoConfig

    # Verifica se as strings estão presentes no conteúdo
    if ($conteudo -contains 'g_language = portuguese_(brazil)' -and $conteudo -contains 'g_languageAudio = english') {
        # Se as strings estiverem presentes, exclui o script
        Remove-Item -Path $MyInvocation.MyCommand.Path -Force
    }
    else {
        # Se alguma string estiver faltando, adiciona as strings em uma linha livre
        Add-Content -Path $arquivoConfig -Value "`ng_language = portuguese_(brazil)`ng_languageAudio = english"

        # Exclui o script
        Remove-Item -Path $MyInvocation.MyCommand.Path -Force
    }
}
else {
    # Se o arquivo não existir, cria o arquivo com as strings
    Set-Content -Path $arquivoConfig -Value "g_language = portuguese_(brazil)`ng_languageAudio = english"

    # Exclui o script
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force
}
