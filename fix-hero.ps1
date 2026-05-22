# Fresh copy of AdobeStock kratom image with new filename to bypass any caching
$ErrorActionPreference = "Continue"

$source = "C:\Users\Hydro\Downloads\AdobeStock_859266042.jpeg"
$dest   = "D:\Natural Ground Organic\images\hero-kratom.jpg"

Write-Host "Source: $source"
if (Test-Path $source) {
    $srcInfo = Get-Item $source
    Write-Host "  Size: $($srcInfo.Length) bytes ($([math]::Round($srcInfo.Length/1024)) KB)"
    Write-Host "  Modified: $($srcInfo.LastWriteTime)"
} else {
    Write-Host "  NOT FOUND" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "Destination: $dest"
if (Test-Path $dest) {
    Write-Host "  (Already exists - will be replaced)"
    Remove-Item $dest -Force
}

Write-Host ""
Write-Host "Copying via [System.IO.File]::Copy ..."
[System.IO.File]::Copy($source, $dest, $true)

Start-Sleep -Milliseconds 500

if (Test-Path $dest) {
    $dstInfo = Get-Item $dest
    Write-Host "Done. Destination size: $($dstInfo.Length) bytes ($([math]::Round($dstInfo.Length/1024)) KB)"
    if ($dstInfo.Length -eq $srcInfo.Length) {
        Write-Host "MATCH - sizes are identical" -ForegroundColor Green
    } else {
        Write-Host "MISMATCH - sizes differ" -ForegroundColor Red
    }
} else {
    Write-Host "FAILED - destination file does not exist after copy" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
