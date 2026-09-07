# ============================================================
# Navyaa — cleanup leftover files from the Pull Away slug fix
# Safe to run even if some/all files are already gone.
# ============================================================

$repo = "C:\Users\navin\OneDrive\Documents\Navyaa-Blog\navyaa-site"
Set-Location $repo

$filesToRemove = @(
    "fix-pullaway-slug.ps1",
    "netlify.toml.bak",
    "src\posts\understanding-why-people-pull-away-in-relationships.md.bak"
)

$removedAny = $false
foreach ($f in $filesToRemove) {
    if (Test-Path $f) {
        Remove-Item $f -Force
        Write-Host "Removed $f" -ForegroundColor Green
        $removedAny = $true
    } else {
        Write-Host "$f not found (already removed) -- skipped" -ForegroundColor Yellow
    }
}

if ($removedAny) {
    git add -A
    git commit -m "Clean up leftover files from Pull Away slug fix"
    git push origin main
    Write-Host "`nDone. Check Netlify's Deploys tab to confirm the build succeeded." -ForegroundColor Cyan
} else {
    Write-Host "`nNothing to remove -- all three files were already gone. No commit made." -ForegroundColor Cyan
}
