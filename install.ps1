if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Restarting script with administrative privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$owner = "doas-ice"
$repo = "EasiNote-Fix"
$branch = "main"
$apiUrl = "https://api.github.com/repos/$owner/$repo/contents?ref=$branch"
$rawBaseUrl = "https://raw.githubusercontent.com/$owner/$repo/$branch"
$targetPath = "C:\Easinote-Fix\"

if (!(Test-Path $targetPath)) {
    Write-Host "Creating target directory: $targetPath"
    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
}

try {
    $files = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
} catch {
    Write-Host "❌ Failed to fetch file list from GitHub API."
    exit 1
}

$dllFiles = $files | Where-Object { $_.name -like "*.dll" } | Select-Object -ExpandProperty name

if ($dllFiles.Count -eq 0) {
    Write-Host "⚠ No DLL files found in the repository."
    exit
}

foreach ($file in $dllFiles) {
    $fileUrl = "$rawBaseUrl/$file"
    $destFile = Join-Path $targetPath $file
    Write-Host "Downloading $file..."
    Invoke-WebRequest -Uri $fileUrl -OutFile $destFile -UseBasicParsing
}

Write-Host "✅ EasiNote Time Display Setting Fixed. All DLLs have been copied to $targetPath"
