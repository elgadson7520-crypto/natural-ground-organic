# Natural Ground Organics — Pexels Image Downloader
# Fetches top-ranked, keyword-matched photos from the Pexels API.
# Run from the project root: .\download-images.ps1
#
# NOTE: API key below is yours — don't commit this file to a public git repo.
# If you ever rotate the key, paste the new one into the $apiKey line below.

$ErrorActionPreference = 'Stop'
$apiKey = 'MGL1hC7MqOttYA9ucaIG7024swXD3K1d9NiVM56wzaiK21xWYCFdJAjl'

$projectRoot = $PSScriptRoot
$imagesDir = Join-Path $projectRoot 'images'

if (-not (Test-Path $imagesDir)) {
    New-Item -ItemType Directory -Path $imagesDir | Out-Null
    Write-Host "Created folder: $imagesDir"
}

# Each entry: filename, search query, orientation (landscape/portrait/square),
# and which result index to pick (lets us get distinct photos for similar searches).
$photos = @(
    # Hero & tiles  — avoiding the words "kratom"/"kava" which return off-topic matches on Pexels
    @{ name = 'hero-botanical.jpg';   q = 'tropical green leaves';      o = 'landscape'; i = 0 },
    @{ name = 'tile-kratom.jpg';      q = 'green powder mortar';        o = 'landscape'; i = 0 },
    @{ name = 'tile-kava.jpg';        q = 'coconut drink tropical';     o = 'portrait';  i = 0 },
    @{ name = 'tile-tea.jpg';         q = 'herbal tea cup';             o = 'portrait';  i = 0 },

    # WHITE strains — pulling per_page=5, rotating result index for variety
    @{ name = 'white-1.jpg';          q = 'herbal powder bowl';         o = 'square';    i = 1 },
    @{ name = 'white-2.jpg';          q = 'mortar pestle herb';         o = 'square';    i = 0 },
    @{ name = 'white-3.jpg';          q = 'white spice powder';         o = 'square';    i = 0 },
    @{ name = 'white-4.jpg';          q = 'green tea leaves powder';    o = 'square';    i = 0 },
    @{ name = 'white-5.jpg';          q = 'wooden scoop spice';         o = 'square';    i = 0 },

    # RED strains
    @{ name = 'red-1.jpg';            q = 'red spice powder';           o = 'square';    i = 0 },
    @{ name = 'red-2.jpg';            q = 'rooibos red tea';            o = 'square';    i = 0 },
    @{ name = 'red-3.jpg';            q = 'cinnamon powder bowl';       o = 'square';    i = 0 },
    @{ name = 'red-4.jpg';            q = 'red sumac spice';            o = 'square';    i = 0 },

    # GREEN strains
    @{ name = 'green-1.jpg';          q = 'matcha green powder';        o = 'square';    i = 0 },
    @{ name = 'green-2.jpg';          q = 'matcha bowl whisk';          o = 'square';    i = 0 },
    @{ name = 'green-3.jpg';          q = 'green tea powder';           o = 'square';    i = 0 },
    @{ name = 'green-4.jpg';          q = 'green herb leaves';          o = 'square';    i = 0 },

    # Kava + tea — broader queries that get better matches
    @{ name = 'kava-product.jpg';     q = 'coconut bowl ceremony';      o = 'square';    i = 0 },
    @{ name = 'kava-lifestyle.jpg';   q = 'tropical beach palm trees';  o = 'landscape'; i = 0 },
    @{ name = 'tea-banner.jpg';       q = 'teapot herbal tea';          o = 'landscape'; i = 0 }
)

$total = $photos.Count
$success = 0
$failed = @()

foreach ($p in $photos) {
    $outFile = Join-Path $imagesDir $p.name
    $searchUrl = "https://api.pexels.com/v1/search?query=$([uri]::EscapeDataString($p.q))&per_page=5&orientation=$($p.o)"
    Write-Host -NoNewline "  $($p.name)  [$($p.q)]... "
    try {
        $resp = Invoke-RestMethod -Uri $searchUrl -Headers @{ Authorization = $apiKey } -TimeoutSec 30
        if (-not $resp.photos -or $resp.photos.Count -eq 0) {
            throw "No photos found for query '$($p.q)'"
        }
        $pick = $resp.photos[ [Math]::Min($p.i, $resp.photos.Count - 1) ]
        # Pick the right resolution: 'large' is ~940px wide, good for web cards
        $imgUrl = $pick.src.large
        Invoke-WebRequest -Uri $imgUrl -OutFile $outFile -UseBasicParsing -TimeoutSec 30
        $size = (Get-Item $outFile).Length
        if ($size -lt 2000) { throw "File too small ($size bytes)" }
        $photog = if ($pick.photographer) { " by $($pick.photographer)" } else { '' }
        Write-Host "OK ($([math]::Round($size/1024)) KB)$photog" -ForegroundColor Green
        $success++
    }
    catch {
        Write-Host "FAILED: $_" -ForegroundColor Red
        $failed += $p.name
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "Downloaded: $success of $total photos"
if ($failed.Count -gt 0) {
    Write-Host "Failed:" -ForegroundColor Yellow
    $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}
Write-Host "=========================================="
Write-Host ""
Write-Host "Next: vercel --prod" -ForegroundColor Cyan
