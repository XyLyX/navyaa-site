# ============================================================
# Navyaa — Pull Away slug change + redirect (single commit)
# Edit $repo below if yours differs, then run this script.
# ============================================================

$repo = "C:\Users\navin\OneDrive\Documents\Navyaa-Blog\navyaa-site"
Set-Location $repo

# ---- Backups ----
Copy-Item "src\posts\understanding-why-people-pull-away-in-relationships.md" "src\posts\understanding-why-people-pull-away-in-relationships.md.bak" -Force
Copy-Item "netlify.toml" "netlify.toml.bak" -Force
Write-Host "Backups created (.bak files)" -ForegroundColor Yellow

# ---- 1. Change the slug in the post's frontmatter ----
$postPath = "src\posts\understanding-why-people-pull-away-in-relationships.md"
$postContent = Get-Content $postPath -Raw
$oldSlugLine = "slug: understanding-why-people-pull-away-in-relationships"
$newSlugLine = "slug: why-people-pull-away-in-relationships-7-reasons-and-what-to-do"

if ($postContent.Contains($oldSlugLine)) {
    $postContent = $postContent.Replace($oldSlugLine, $newSlugLine)
    [IO.File]::WriteAllText($postPath, $postContent, [System.Text.Encoding]::UTF8)
    Write-Host "Updated slug in $postPath" -ForegroundColor Green
} else {
    Write-Host "WARNING: old slug line not found exactly as expected in $postPath -- check manually (see .bak)" -ForegroundColor Red
}

# ---- 2. Add the new redirect rule to netlify.toml ----
$tomlPath = "netlify.toml"
$tomlContent = Get-Content $tomlPath -Raw
$newRule = "`n[[redirects]]`n  from = `"/understanding-why-people-pull-away-in-relationships/`"`n  to = `"/why-people-pull-away-in-relationships-7-reasons-and-what-to-do/`"`n  status = 301`n"

if ($tomlContent.Contains("why-people-pull-away-in-relationships-7-reasons-and-what-to-do")) {
    Write-Host "netlify.toml already has this redirect -- skipped" -ForegroundColor Yellow
} else {
    $tomlContent = $tomlContent.TrimEnd() + "`n" + $newRule
    [IO.File]::WriteAllText($tomlPath, $tomlContent, [System.Text.Encoding]::UTF8)
    Write-Host "Added new redirect rule to netlify.toml" -ForegroundColor Green
}

# ---- 3. Git add, commit, push ----
git add -A
git commit -m "Change Pull Away post slug and add 301 redirect (v2 audit)"
git push origin main

Write-Host "`nDone. Check Netlify's Deploys tab to confirm the build succeeded." -ForegroundColor Cyan
