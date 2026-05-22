# Fix script: copy real Adobe Stock hero image + create transparent logo

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== STEP 1: Copy AdobeStock kratom image to hero-botanical.jpg ===" -ForegroundColor Cyan

$source = "C:\Users\Hydro\Downloads\AdobeStock_859266042.jpeg"
$dest   = "D:\Natural Ground Organic\images\hero-botanical.jpg"

if (-not (Test-Path $source)) {
    Write-Host "ERROR: Source file not found at $source" -ForegroundColor Red
    Write-Host "Files in Downloads matching AdobeStock*:"
    Get-ChildItem "C:\Users\Hydro\Downloads\AdobeStock*" | Format-Table Name, Length, LastWriteTime
    pause
    exit 1
}

$srcSize = (Get-Item $source).Length
Write-Host "Source file: $source ($srcSize bytes)"

Copy-Item -Path $source -Destination $dest -Force
$dstSize = (Get-Item $dest).Length
Write-Host "Destination file: $dest ($dstSize bytes)"

if ($srcSize -ne $dstSize) {
    Write-Host "ERROR: Sizes differ after copy" -ForegroundColor Red
    exit 1
}
Write-Host "Hero image copied successfully." -ForegroundColor Green

Write-Host ""
Write-Host "=== STEP 2: Create transparent-background logo ===" -ForegroundColor Cyan

# Load System.Drawing
Add-Type -AssemblyName System.Drawing

$logoSrc = "D:\Natural Ground Organic\images\logo.png"
$logoDst = "D:\Natural Ground Organic\images\logo-transparent.png"

$bitmap = New-Object System.Drawing.Bitmap $logoSrc
$result = New-Object System.Drawing.Bitmap $bitmap.Width, $bitmap.Height

# Iterate every pixel and make near-black transparent
for ($y = 0; $y -lt $bitmap.Height; $y++) {
    for ($x = 0; $x -lt $bitmap.Width; $x++) {
        $px = $bitmap.GetPixel($x, $y)
        # If pixel is very dark (below threshold), make it transparent
        $luminance = (0.299 * $px.R) + (0.587 * $px.G) + (0.114 * $px.B)
        if ($luminance -lt 25) {
            $result.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
        } else {
            # Gradual alpha for the darkest edges to feather the cutout
            $alpha = 255
            if ($luminance -lt 50) {
                $alpha = [int]( ($luminance - 25) / 25 * 255 )
                if ($alpha -lt 0) { $alpha = 0 }
                if ($alpha -gt 255) { $alpha = 255 }
            }
            $newColor = [System.Drawing.Color]::FromArgb($alpha, $px.R, $px.G, $px.B)
            $result.SetPixel($x, $y, $newColor)
        }
    }
}

$result.Save($logoDst, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
$result.Dispose()

$logoDstSize = (Get-Item $logoDst).Length
Write-Host "Transparent logo saved: $logoDst ($logoDstSize bytes)" -ForegroundColor Green

Write-Host ""
Write-Host "=== Done! ===" -ForegroundColor Green
Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
