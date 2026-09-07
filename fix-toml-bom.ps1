# ============================================================
# Navyaa -- strip UTF-8 BOM from netlify.toml (and touched posts)
# Fixes: "Invalid TOML document: only letters, numbers, dashes
# and underscores are allowed in keys" caused by a BOM at the
# start of the file from earlier scripts using Encoding.UTF8.
# ============================================================

$repo = "C:\Users\navin\OneDrive\Documents\Navyaa-Blog\navyaa-site"
Set-Location $repo

# UTF8Encoding with $false = no BOM emitted
$noBomUtf8 = New-Object System.Text.UTF8Encoding $false

function Remove-Bom {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $false }
    $bytes = [IO.File]::ReadAllBytes($Path)
    $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    if ($hasBom) {
        $content = [System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3)
        [IO.File]::WriteAllText($Path, $content, $noBomUtf8)
        Write-Host "Stripped BOM from $Path" -ForegroundColor Green
        return $true
    } else {
        Write-Host "$Path had no BOM -- skipped" -ForegroundColor Yellow
        return $false
    }
}

$fixedAny = $false

# ---- Primary fix: netlify.toml ----
if (Remove-Bom "netlify.toml") { $fixedAny = $true }

# ---- Preventive: check the posts touched by tonight's scripts ----
$touchedPosts = @(
    "src\posts\understanding-why-people-pull-away-in-relationships.md",
    "src\posts\its-a-slow-death-isnt-it.md",
    "src\posts\heal-your-relationships-identify-and-transform-patterns.md",
    "src\posts\when-love-feels-heavy-understanding-emotional-burnout.md",
    "src\posts\stop-chasing-closure-heres-what-you-actually-need.md",
    "src\posts\the-night-court.md",
    "src\posts\finding-stillness-in-a-chaotic-world.md",
    "src\posts\the-power-of-silence-in-emotional-healing.md",
    "src\posts\understanding-emotional-exhaustion-a-reflection-on-life-and-death.md",
    "src\posts\stop-waiting-express-what-matters-today.md",
    "src\posts\dare-to-dream-embracing-life-beyond-comfort-zones.md",
    "src\posts\finding-freedom-in-letting-go.md",
    "src\posts\why-we-stay-in-relationships-long.md"
)
foreach ($p in $touchedPosts) {
    if (Remove-Bom $p) { $fixedAny = $true }
}

if ($fixedAny) {
    git add -A
    git commit -m "Strip UTF-8 BOM from netlify.toml and touched posts (fixes TOML parse error)"
    git push origin main
    Write-Host "`nDone. Check Netlify's Deploys tab to confirm the build succeeded." -ForegroundColor Cyan
} else {
    Write-Host "`nNo BOM found anywhere -- nothing to fix. The build error may have another cause." -ForegroundColor Red
}
