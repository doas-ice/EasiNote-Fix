if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "[INFO] Restarting script as Administrator..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$owner        = "doas-ice"
$repo         = "EasiNote-Fix"
$branch       = "main"
$apiUrl       = "https://api.github.com/repos/$owner/$repo/contents?ref=$branch"
$rawBaseUrl   = "https://raw.githubusercontent.com/$owner/$repo/$branch"
$targetPath   = "C:\Program Files (x86)\Shirui\Easinote\Note\Main"

Write-Host "[DEBUG] GitHub API URL: $apiUrl"
Write-Host "[DEBUG] Raw URL base:   $rawBaseUrl"
Write-Host "[DEBUG] Target path:    $targetPath"

if (!(Test-Path $targetPath)) {
    Write-Host "[INFO] Creating target directory..."
    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
}

try {
    Write-Host "[INFO] Fetching file list from GitHub..."
    $files = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
    Write-Host "[DEBUG] Files returned:"
    $files | ForEach-Object { Write-Host "  - " $_.name }
} catch {
    Write-Host "[ERROR] Failed to fetch file list:"
    Write-Host $_
    exit 1
}

$dllFiles = $files | Where-Object { $_.name -like "*.dll" } | Select-Object -ExpandProperty name
if (-not $dllFiles) {
    Write-Host "[WARN] No DLL files found!"
    exit
}

foreach ($file in $dllFiles) {
    $fileUrl  = "$rawBaseUrl/$file"
    $destFile = Join-Path $targetPath $file
    Write-Host "[INFO] Downloading $file from $fileUrl..."
    try {
        Invoke-WebRequest -Uri $fileUrl -OutFile $destFile -UseBasicParsing
        if (Test-Path $destFile) {
            Write-Host "[OK] Saved to $destFile"
        } else {
            Write-Host "[FAIL] File missing after download: $destFile"
        }
    } catch {
        Write-Host "[ERROR] Download failed for $file"
        Write-Host $_
    }
}

Write-Host "[DONE] Script complete."
Write-Host "Press Enter to exit..."
[void][System.Console]::ReadLine()
