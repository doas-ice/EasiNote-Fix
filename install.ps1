if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "[INFO] Restarting script with administrative privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$owner = "doas-ice"
$repo = "EasiNote-Fix"
$branch = "main"
$apiUrl = "https://api.github.com/repos/$owner/$repo/contents?ref=$branch"
$rawBaseUrl = "https://raw.githubusercontent.com/$owner/$repo/$branch"
$targetPath = "C:\Easinote-fix\Main"

Write-Host "[DEBUG] GitHub API URL: $apiUrl"
Write-Host "[DEBUG] Raw file base URL: $rawBaseUrl"
Write-Host "[DEBUG] Target path: $targetPath"

if (!(Test-Path $targetPath)) {
    Write-Host "[INFO] Creating target directory: $targetPath"
    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
}

try {
    Write-Host "[INFO] Fetching file list from GitHub..."
    $files = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
    Write-Host "[DEBUG] Raw API response:"
    $files | ForEach-Object { Write-Host " - " $_.name }
} catch {
    Write-Host "[ERROR] Failed to fetch file list from GitHub API."
    Write-Host $_
    exit 1
}

$dllFiles = $files | Where-Object { $_.name -like "*.dll" } | Select-Object -ExpandProperty name

if (-not $dllFiles -or $dllFiles.Count -eq 0) {
    Write-Host "[WARN] No DLL files found in the repository."
    exit
}

Write-Host "[INFO] Found $($dllFiles.Count) DLL files:"
$dllFiles | ForEach-Object { Write-Host " - $_" }

foreach ($file in $dllFiles) {
    $fileUrl = "$rawBaseUrl/$file"
    $destFile = Join-Path $targetPath $file
    Write-Host "[INFO] Downloading $file from $fileUrl..."
    try {
        Invoke-WebRequest -Uri $fileUrl -OutFile $destFile -UseBasicParsing
        if (Test-Path $destFile) {
            Write-Host "[SUCCESS] Saved to $destFile"
        } else {
            Write-Host "[FAIL] Download failed for $file"
        }
    } catch {
        Write-Host "[ERROR] Failed to download $file"
        Write-Host $_
    }
}

Write-Host "[DONE] All DLLs processed."
