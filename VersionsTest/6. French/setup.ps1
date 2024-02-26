# Nome do arquivo
$fileName = "user.cfg"

# Verifica se o arquivo existe
if (!(Test-Path $fileName)) {
    New-Item -ItemType File -Path $fileName -Force
}

# Lê o arquivo
$fileContent = Get-Content $fileName

# Verifica e atualiza as linhas
$updatedContent = @()
$foundLanguage = $false
$foundLanguageAudio = $false

foreach ($line in $fileContent) {
    if ($line -like "g_language =*") {
        $updatedContent += "g_language = french_(france)"
        $foundLanguage = $true
    } elseif ($line -like "g_languageAudio =*") {
        $updatedContent += "g_languageAudio = english"
        $foundLanguageAudio = $true
    } else {
        $updatedContent += $line
    }
}

# Adiciona as linhas, se necessário
if (!$foundLanguage) {
    $updatedContent += "g_language = german_(germany)"
}
if (!$foundLanguageAudio) {
    $updatedContent += "g_languageAudio = english"
}

# Escreve o conteúdo atualizado de volta para o arquivo
[System.IO.File]::WriteAllLines($fileName, $updatedContent)

# Autoexclui o script
Remove-Item -Path $MyInvocation.MyCommand.Definition