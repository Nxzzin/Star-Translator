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
        $updatedContent += "g_language = portuguese_(brazil)"
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
    $updatedContent += "g_language = portuguese_(brazil)"
}
if (!$foundLanguageAudio) {
    $updatedContent += "g_languageAudio = english"
}

# Escreve o conteúdo atualizado de volta para o arquivo
[System.IO.File]::WriteAllLines($fileName, $updatedContent)

# Expandir o arquivo "data.zip"
$archivePath = Join-Path -Path $PSScriptRoot -ChildPath "data.zip"
$extractPath = $PSScriptRoot

# Verifica se o arquivo "data.zip" existe
if (Test-Path $archivePath) {
    Expand-Archive -Path $archivePath -DestinationPath $extractPath -Force

    # Exclui o arquivo "data.zip"
    Remove-Item -Path $archivePath -Force
}

# Autoexclui o script
Remove-Item -Path $MyInvocation.MyCommand.Definition
