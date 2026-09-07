# ============================================================
# Navyaa -- metadata-only update for 12 REWRITE posts
# Updates slug/seo_title/meta_description in frontmatter + adds
# 301 redirects. Does NOT touch body content -- see chat for why.
# Finds each post by searching for its OLD slug value (works even
# if filename != slug, and regardless of quoted/unquoted YAML).
# ============================================================

$repo = "C:\Users\navin\OneDrive\Documents\Navyaa-Blog\navyaa-site"
Set-Location $repo

$posts = Get-ChildItem -Path "src\posts" -Filter *.md
$redirectBlock = ""
$notFound = @()
$updated = @()

# ---- 1/12: its-a-slow-death-isnt-it ----
$oldSlug = "its-a-slow-death-isnt-it"
$newSlug = "why-relationships-slowly-die-the-quiet-signs-someone-is-checking-out"
$newTitle = "Why Relationships Slowly Die: The Quiet Signs Someone Is Checking Out"
$newMeta = "Not every relationship ends dramatically. Sometimes it ends through distance, indifference and repeated disconnection."
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

# ---- 2/12: letting-go-finding-peace-in-absence ----
$oldSlug = "letting-go-finding-peace-in-absence"
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

# ---- 3/12: heal-your-relationships-identify-and-transform-patterns ----
$oldSlug = "heal-your-relationships-identify-and-transform-patterns"
$newSlug = "how-to-recognize-and-change-unhealthy-relationship-patterns"
$newTitle = "How to Recognize and Change Unhealthy Relationship Patterns"
$newMeta = "Learn how recurring cycles form, why they repeat and how boundaries and different responses can interrupt them."
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

# ---- 4/12: when-love-feels-heavy-understanding-emotional-burnout ----
$oldSlug = "when-love-feels-heavy-understanding-emotional-burnout"
$newSlug = "when-love-feels-exhausting-understanding-relationship-burnout"
$newTitle = "When Love Feels Exhausting: Understanding Relationship Burnout"
$newMeta = "Understand relationship burnout, emotional labor and whether exhaustion can be repaired."
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

# ---- 5/12: stop-chasing-closure-heres-what-you-actually-need ----
$oldSlug = "stop-chasing-closure-heres-what-you-actually-need"
$newSlug = "why-you-dont-need-closure-from-the-person-who-hurt-you"
$newTitle = "Why You Don’t Need Closure From the Person Who Hurt You"
$newMeta = "Why another person's explanation may not heal you — and how acceptance can become a form of closure."
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

# ---- 6/12: why-we-stay-in-relationships-long-after-theyve-stopped-working ----
$oldSlug = "why-we-stay-in-relationships-long-after-theyve-stopped-working"
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

# ---- 7/12: the-night-court ----
$oldSlug = "the-night-court"
$newSlug = "why-we-overthink-at-night-when-your-mind-wont-let-you-sleep"
$newTitle = "Why We Overthink at Night: When Your Mind Won’t Let You Sleep"
$newMeta = "Why thoughts can become louder at night, and ways to create distance from the loop."
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

# ---- 8/12: finding-stillness-in-a-chaotic-world ----
$oldSlug = "finding-stillness-in-a-chaotic-world"
$newSlug = "how-to-find-peace-when-life-feels-overwhelming"
$newTitle = "How to Find Peace When Life Feels Overwhelming"
$newMeta = "Practical ways to reduce mental noise, create small spaces of calm and stop carrying every future problem into the present."
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

# ---- 9/12: the-power-of-silence-in-emotional-healing ----
$oldSlug = "the-power-of-silence-in-emotional-healing"
$newSlug = "why-silence-hurts-so-much-when-youre-healing"
$newTitle = "Why Silence Hurts So Much When You’re Healing"
$newMeta = "Why silence after emotional loss can hurt at first — and how it can gradually become space for acceptance."
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

# ---- 10/12: understanding-emotional-exhaustion-a-reflection-on-life-and-death ----
$oldSlug = "understanding-emotional-exhaustion-a-reflection-on-life-and-death"
$newSlug = "what-emotional-exhaustion-really-feels-like"
$newTitle = "What Emotional Exhaustion Really Feels Like"
$newMeta = "Learn common signs of emotional exhaustion and why recovery requires more than simply taking a break."
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

# ---- 11/12: stop-waiting-express-what-matters-today ----
$oldSlug = "stop-waiting-express-what-matters-today"
$newSlug = "stop-waiting-say-what-matters-before-its-too-late"
$newTitle = "Stop Waiting: Say What Matters Before It’s Too Late"
$newMeta = "Why we postpone important conversations, and how to stop waiting for a perfect moment that may never arrive."
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

# ---- 12/12: dare-to-dream-embracing-life-beyond-comfort-zones ----
$oldSlug = "dare-to-dream-embracing-life-beyond-comfort-zones"
$newSlug = "how-to-stop-living-inside-your-comfort-zone"
$newTitle = "How to Stop Living Inside Your Comfort Zone"
$newMeta = "How to distinguish healthy caution from avoidance and take smaller, repeatable steps beyond your comfort zone."
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

# ---- Append all new redirects to netlify.toml in one go ----
if ($redirectBlock -ne "") {
    $tomlContent = Get-Content "netlify.toml" -Raw
    $tomlContent = $tomlContent.TrimEnd() + "`n" + $redirectBlock
    [IO.File]::WriteAllText("netlify.toml", $tomlContent, [System.Text.Encoding]::UTF8)
    Write-Host "Added $($updated.Count) redirect rules to netlify.toml" -ForegroundColor Green
}

Write-Host ""
Write-Host "Updated: $($updated.Count) / 12" -ForegroundColor Cyan
if ($notFound.Count -gt 0) {
    Write-Host "Could not find posts for these slugs -- check manually:" -ForegroundColor Red
    $notFound | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

# ---- Git add, commit, push ----
git add -A
git commit -m "Update slug/seo_title/meta_description for 12 REWRITE posts (v2 audit) + redirects"
git push origin main

Write-Host ""
Write-Host "Done. Content/H2/FAQ/internal-link rewrites still needed separately -- metadata only." -ForegroundColor Cyan