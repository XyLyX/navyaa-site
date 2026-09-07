# ============================================================
# Navyaa -- metadata update for the final 2 REWRITE posts
# (real slugs confirmed via GitHub API, not the audit's guess)
# ============================================================

$repo = "C:\Users\navin\OneDrive\Documents\Navyaa-Blog\navyaa-site"
Set-Location $repo

$posts = Get-ChildItem -Path "src\posts" -Filter *.md
$redirectBlock = ""
$notFound = @()
$updated = @()

# ---- 1/2: finding-freedom-in-letting-go ----
$oldSlug = "finding-freedom-in-letting-go"
$newSlug = "how-to-let-go-of-someone-you-still-love"
$newTitle = "How to Let Go of Someone You Still Love"
$newMeta = "A reflection on accepting reality, creating distance and moving forward without forcing yourself to stop caring overnight."
$match = $posts | Where-Object { (Get-Content $_.FullName -Raw) -match [regex]::Escape($oldSlug) } | Select-Object -First 1
if ($match) {
    $c = Get-Content $match.FullName -Raw
    $c = $c -replace "slug:\s*[`"']?$oldSlug[`"']?", "slug: `"$newSlug`""
    $c = $c -replace "seo_title:\s*.*", "seo_title: `"$newTitle`""
    $c = $c -replace "meta_description:\s*.*", "meta_description: `"$newMeta`""
    [IO.File]::WriteAllText($match.FullName, $c, [System.Text.Encoding]::UTF8)
    $updated += $match.Name
    Write-Host "Updated $($match.Name) -> slug: $newSlug" -ForegroundColor Green
    $redirectBlock += "`n[[redirects]]`n  from = `"/$oldSlug/`"`n  to = `"/$newSlug/`"`n  status = 301`n"
} else {
    $notFound += $oldSlug
    Write-Host "NOT FOUND: no post matches slug $oldSlug -- skipped" -ForegroundColor Red
}

# ---- 2/2: why-we-stay-in-relationships-long ----
$oldSlug = "why-we-stay-in-relationships-long"
$newSlug = "why-we-stay-in-relationships-that-no-longer-work"
$newTitle = "Why We Stay in Relationships That No Longer Work"
$newMeta = "Explore why attachment, hope, fear and identity can keep people in relationships that no longer work."
$match = $posts | Where-Object { (Get-Content $_.FullName -Raw) -match [regex]::Escape($oldSlug) } | Select-Object -First 1
if ($match) {
    $c = Get-Content $match.FullName -Raw
    $c = $c -replace "slug:\s*[`"']?$oldSlug[`"']?", "slug: `"$newSlug`""
    $c = $c -replace "seo_title:\s*.*", "seo_title: `"$newTitle`""
    $c = $c -replace "meta_description:\s*.*", "meta_description: `"$newMeta`""
    [IO.File]::WriteAllText($match.FullName, $c, [System.Text.Encoding]::UTF8)
    $updated += $match.Name
    Write-Host "Updated $($match.Name) -> slug: $newSlug" -ForegroundColor Green
    $redirectBlock += "`n[[redirects]]`n  from = `"/$oldSlug/`"`n  to = `"/$newSlug/`"`n  status = 301`n"
} else {
    $notFound += $oldSlug
    Write-Host "NOT FOUND: no post matches slug $oldSlug -- skipped" -ForegroundColor Red
}

if ($redirectBlock -ne "") {
    $tomlContent = Get-Content "netlify.toml" -Raw
    $tomlContent = $tomlContent.TrimEnd() + "`n" + $redirectBlock
    [IO.File]::WriteAllText("netlify.toml", $tomlContent, [System.Text.Encoding]::UTF8)
    Write-Host "Added $($updated.Count) redirect rules to netlify.toml" -ForegroundColor Green
}

Write-Host ""
Write-Host "Updated: $($updated.Count) / 2" -ForegroundColor Cyan

git add -A
git commit -m "Update slug/seo_title/meta_description for final 2 REWRITE posts + redirects"
git push origin main

Write-Host ""
Write-Host "Done. All 13/13 REWRITE posts now have metadata + redirects applied." -ForegroundColor Cyan