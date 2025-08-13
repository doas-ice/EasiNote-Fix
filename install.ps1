if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {

    Write-Host "[INFO] Requesting Administrator privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm 'https://raw.githubusercontent.com/doas-ice/EasiNote-Fix/main/install.ps1' | iex`"" -Verb RunAs
    exit
}

$owner       = "doas-ice"
$repo        = "EasiNote-Fix"
$branch      = "main"
$apiUrl      = "https://api.github.com/repos/$owner/$repo/contents?ref=$branch"
$rawBaseUrl  = "https://raw.githubusercontent.com/$owner/$repo/$branch"
$targetPath  = "C:\Program Files (x86)\ShiRui\Note\Main"

Write-Host "[DEBUG] API URL: $apiUrl"
Write-Host "[DEBUG] Raw base URL: $rawBaseUrl"
Write-Host "[DEBUG] Target path: $targetPath"

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
    Write-Host "[ERROR] Failed to fetch file list from GitHub API."
    Write-Host $_
    exit 1
}

$dllFiles = $files | Where-Object { $_.name -like "*.dll" } | Select-Object -ExpandProperty name

if (-not $dllFiles -or $dllFiles.Count -eq 0) {
    Write-Host "[WARN] No DLL files found in repository root."
    Write-Host "      (If they're in subfolders, script needs recursive mode.)"
    Write-Host "Press Enter to exit..."
    [void][System.Console]::ReadLine()
    exit
}

Write-Host "[INFO] Found $($dllFiles.Count) DLL files:"
$dllFiles | ForEach-Object { Write-Host "  - $_" }

foreach ($file in $dllFiles) {
    $fileUrl  = "$rawBaseUrl/$file"
    $destFile = Join-Path $targetPath $file

    if (Test-Path $destFile) {
        Write-Host "[INFO] Overwriting existing file: $destFile"
        Remove-Item $destFile -Force
    }

    Write-Host "[INFO] Downloading $file from $fileUrl..."
    try {
        Invoke-WebRequest -Uri $fileUrl -OutFile $destFile -UseBasicParsing -ErrorAction Stop
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
Write-Host "Press Enter to exit..."
[void][System.Console]::ReadLine()
