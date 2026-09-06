# ============================================================
# Navyaa SEO batch (base64 edition - avoids here-string parsing issues)
# Edit the two paths below if yours differ, then run this script.
# ============================================================

$repo      = "C:\Users\navin\OneDrive\Documents\Navyaa-Blog\navyaa-site"
$downloads = "$env:USERPROFILE\Downloads"

Set-Location $repo

function Write-Base64File {
    param([string]$Base64, [string]$Path)
    $bytes = [Convert]::FromBase64String($Base64)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Decode-Base64 {
    param([string]$Base64)
    return [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Base64))
}

# ---- Backups ----
Copy-Item ".eleventy.js" ".eleventy.js.bak" -Force
Copy-Item "src\_includes\base.njk" "src\_includes\base.njk.bak" -Force
Copy-Item "src\_includes\article.njk" "src\_includes\article.njk.bak" -Force
Write-Host "Backups created (.bak files)" -ForegroundColor Yellow

# ---- Base64 payloads ----
$ROBOTS  = "VXNlci1hZ2VudDogKgpBbGxvdzogLwpEaXNhbGxvdzogL2FkbWluLwoKU2l0ZW1hcDogaHR0cHM6Ly9uYXZ5YWEuYmxvZy9zaXRlbWFwLnhtbAo="
$SITEMAP = "LS0tCnBlcm1hbGluazogL3NpdGVtYXAueG1sCmVsZXZlbnR5RXhjbHVkZUZyb21Db2xsZWN0aW9uczogdHJ1ZQotLS0KPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHVybHNldCB4bWxucz0iaHR0cDovL3d3dy5zaXRlbWFwcy5vcmcvc2NoZW1hcy9zaXRlbWFwLzAuOSI+CiAgPHVybD48bG9jPmh0dHBzOi8vbmF2eWFhLmJsb2cvPC9sb2M+PC91cmw+CiAgPHVybD48bG9jPmh0dHBzOi8vbmF2eWFhLmJsb2cvYWJvdXQvPC9sb2M+PC91cmw+CiAgPHVybD48bG9jPmh0dHBzOi8vbmF2eWFhLmJsb2cvc3RhcnQtaGVyZS88L2xvYz48L3VybD4KeyUtIGZvciBwaWxsYXIgaW4gcGlsbGFycyAlfQogIDx1cmw+PGxvYz5odHRwczovL25hdnlhYS5ibG9nL3t7IHBpbGxhciB8IGxvd2VyIH19LzwvbG9jPjwvdXJsPgp7JS0gZW5kZm9yICV9CnslLSBmb3IgcG9zdCBpbiBjb2xsZWN0aW9ucy5wb3N0cyAlfQogIDx1cmw+CiAgICA8bG9jPmh0dHBzOi8vbmF2eWFhLmJsb2d7eyBwb3N0LnVybCB9fTwvbG9jPgogICAgPGxhc3Rtb2Q+e3sgcG9zdC5kYXRlLnRvSVNPU3RyaW5nKCkgfX08L2xhc3Rtb2Q+CiAgPC91cmw+CnslLSBlbmRmb3IgJX0KPC91cmxzZXQ+Cg=="
$FEED    = "LS0tCnBlcm1hbGluazogL2ZlZWQueG1sCmVsZXZlbnR5RXhjbHVkZUZyb21Db2xsZWN0aW9uczogdHJ1ZQotLS0KPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHJzcyB2ZXJzaW9uPSIyLjAiIHhtbG5zOmF0b209Imh0dHA6Ly93d3cudzMub3JnLzIwMDUvQXRvbSI+CjxjaGFubmVsPgo8dGl0bGU+TmF2eWFhPC90aXRsZT4KPGxpbms+aHR0cHM6Ly9uYXZ5YWEuYmxvZy88L2xpbms+CjxhdG9tOmxpbmsgaHJlZj0iaHR0cHM6Ly9uYXZ5YWEuYmxvZy9mZWVkLnhtbCIgcmVsPSJzZWxmIiB0eXBlPSJhcHBsaWNhdGlvbi9yc3MreG1sIiAvPgo8ZGVzY3JpcHRpb24+VGhlIGh1bWFuIHNpZGUgb2YgcmVsYXRpb25zaGlwcywgZW1vdGlvbnMgYW5kIGJlY29taW5nIHlvdXJzZWxmLjwvZGVzY3JpcHRpb24+CjxsYW5ndWFnZT5lbjwvbGFuZ3VhZ2U+CnslLSBmb3IgcG9zdCBpbiBjb2xsZWN0aW9ucy5wb3N0cyAlfQo8aXRlbT4KICA8dGl0bGU+e3sgcG9zdC5kYXRhLnRpdGxlIH19PC90aXRsZT4KICA8bGluaz5odHRwczovL25hdnlhYS5ibG9ne3sgcG9zdC51cmwgfX08L2xpbms+CiAgPGd1aWQ+aHR0cHM6Ly9uYXZ5YWEuYmxvZ3t7IHBvc3QudXJsIH19PC9ndWlkPgogIDxkZXNjcmlwdGlvbj48IVtDREFUQVt7eyBwb3N0LmRhdGEuZXhjZXJwdCB9fV1dPjwvZGVzY3JpcHRpb24+CiAgPHB1YkRhdGU+e3sgcG9zdC5kYXRlLnRvVVRDU3RyaW5nKCkgfX08L3B1YkRhdGU+CjwvaXRlbT4KeyUtIGVuZGZvciAlfQo8L2NoYW5uZWw+CjwvcnNzPgo="
$BASE    = "PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KPGhlYWQ+CjxtZXRhIGNoYXJzZXQ9IlVURi04Ij4KPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwgaW5pdGlhbC1zY2FsZT0xIj4KPHRpdGxlPnt7IHNlb190aXRsZSBvciB0aXRsZSBvciAiTmF2eWFhIiB9fXslIGlmIHRpdGxlIGFuZCBub3Qgc2VvX3RpdGxlICV9IOKAlCBOYXZ5YWF7JSBlbmRpZiAlfTwvdGl0bGU+CjxtZXRhIG5hbWU9ImRlc2NyaXB0aW9uIiBjb250ZW50PSJ7eyBtZXRhX2Rlc2NyaXB0aW9uIG9yIGV4Y2VycHQgb3IgJ05hdnlhYSDigJQgZXNzYXlzIG9uIExvdmUsIFNlbGYsIExpZmUsIFNvdWwgYW5kIHRoZSBVbmZpbHRlcmVkIHRydXRoIGluIGJldHdlZW4uJyB9fSI+CjxsaW5rIHJlbD0iY2Fub25pY2FsIiBocmVmPSJodHRwczovL25hdnlhYS5ibG9ne3sgcGFnZS51cmwgfX0iPgo8bWV0YSBwcm9wZXJ0eT0ib2c6dGl0bGUiIGNvbnRlbnQ9Int7IHNlb190aXRsZSBvciB0aXRsZSBvciAnTmF2eWFhJyB9fSI+CjxtZXRhIHByb3BlcnR5PSJvZzpkZXNjcmlwdGlvbiIgY29udGVudD0ie3sgbWV0YV9kZXNjcmlwdGlvbiBvciBleGNlcnB0IG9yICdOYXZ5YWEg4oCUIGVzc2F5cyBvbiBMb3ZlLCBTZWxmLCBMaWZlLCBTb3VsIGFuZCB0aGUgVW5maWx0ZXJlZCB0cnV0aCBpbiBiZXR3ZWVuLicgfX0iPgo8bWV0YSBwcm9wZXJ0eT0ib2c6dHlwZSIgY29udGVudD0ieyUgaWYgcGlsbGFyICV9YXJ0aWNsZXslIGVsc2UgJX13ZWJzaXRleyUgZW5kaWYgJX0iPgo8bWV0YSBwcm9wZXJ0eT0ib2c6aW1hZ2UiIGNvbnRlbnQ9Imh0dHBzOi8vbmF2eWFhLmJsb2d7eyBpbWFnZSBvciAnL2ltYWdlcy9kZWZhdWx0LW9nLWltYWdlLmpwZycgfX0iPgo8bWV0YSBuYW1lPSJ0d2l0dGVyOmNhcmQiIGNvbnRlbnQ9InN1bW1hcnlfbGFyZ2VfaW1hZ2UiPgo8bWV0YSBuYW1lPSJ0d2l0dGVyOnRpdGxlIiBjb250ZW50PSJ7eyBzZW9fdGl0bGUgb3IgdGl0bGUgb3IgJ05hdnlhYScgfX0iPgo8bWV0YSBuYW1lPSJ0d2l0dGVyOmRlc2NyaXB0aW9uIiBjb250ZW50PSJ7eyBtZXRhX2Rlc2NyaXB0aW9uIG9yIGV4Y2VycHQgb3IgJ05hdnlhYSDigJQgZXNzYXlzIG9uIExvdmUsIFNlbGYsIExpZmUsIFNvdWwgYW5kIHRoZSBVbmZpbHRlcmVkIHRydXRoIGluIGJldHdlZW4uJyB9fSI+CjxtZXRhIG5hbWU9InR3aXR0ZXI6aW1hZ2UiIGNvbnRlbnQ9Imh0dHBzOi8vbmF2eWFhLmJsb2d7eyBpbWFnZSBvciAnL2ltYWdlcy9kZWZhdWx0LW9nLWltYWdlLmpwZycgfX0iPgo8c2NyaXB0IHR5cGU9ImFwcGxpY2F0aW9uL2xkK2pzb24iPgp7CiAgIkBjb250ZXh0IjogImh0dHBzOi8vc2NoZW1hLm9yZyIsCiAgIkB0eXBlIjogIk9yZ2FuaXphdGlvbiIsCiAgIm5hbWUiOiAiTmF2eWFhIiwKICAidXJsIjogImh0dHBzOi8vbmF2eWFhLmJsb2ciLAogICJkZXNjcmlwdGlvbiI6ICJIb25lc3QgcGVyc3BlY3RpdmVzIG9uIHJlbGF0aW9uc2hpcHMsIGVtb3Rpb25hbCBwYXR0ZXJucywgaGVhbGluZywgc2VsZi1kaXNjb3ZlcnkgYW5kIHRoZSBjb21wbGljYXRlZCBidXNpbmVzcyBvZiBiZWluZyBodW1hbi4iLAogICJsb2dvIjogImh0dHBzOi8vbmF2eWFhLmJsb2cvaW1hZ2VzL2xvZ28ucG5nIgp9Cjwvc2NyaXB0Pgo8c2NyaXB0IHR5cGU9ImFwcGxpY2F0aW9uL2xkK2pzb24iPgp7CiAgIkBjb250ZXh0IjogImh0dHBzOi8vc2NoZW1hLm9yZyIsCiAgIkB0eXBlIjogIldlYlNpdGUiLAogICJuYW1lIjogIk5hdnlhYSIsCiAgInVybCI6ICJodHRwczovL25hdnlhYS5ibG9nIgp9Cjwvc2NyaXB0Pgo8bGluayByZWw9InByZWNvbm5lY3QiIGhyZWY9Imh0dHBzOi8vZm9udHMuZ29vZ2xlYXBpcy5jb20iPgo8bGluayBocmVmPSJodHRwczovL2ZvbnRzLmdvb2dsZWFwaXMuY29tL2NzczI/ZmFtaWx5PUNvcm1vcmFudCtHYXJhbW9uZDp3Z2h0QDQwMDs1MDA7NjAwOzcwMCZmYW1pbHk9RE0rU2Fuczp3Z2h0QDQwMDs1MDA7NjAwOzcwMCZkaXNwbGF5PXN3YXAiIHJlbD0ic3R5bGVzaGVldCI+CjxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iL2Nzcy9uYXZ5YWEuY3NzIj4KPGxpbmsgcmVsPSJpY29uIiBocmVmPSIvZmF2aWNvbi5pY28iIHNpemVzPSJhbnkiPgo8bGluayByZWw9ImFwcGxlLXRvdWNoLWljb24iIGhyZWY9Ii9hcHBsZS10b3VjaC1pY29uLnBuZyI+CjwvaGVhZD4KPGJvZHk+CjxkaXYgY2xhc3M9Im52eS13cmFwIj4KCiAgPGhlYWRlciBjbGFzcz0ibnZ5LWhlYWRlciI+CiAgICA8YSBocmVmPSIvIiBjbGFzcz0ibnZ5LWxvZ28iPk5BVllBQTwvYT4KICAgIDxuYXYgY2xhc3M9Im52eS1uYXYiPgogICAgICB7JSBmb3IgcCBpbiBwaWxsYXJzICV9PGEgaHJlZj0iL3t7IHAgfCBzbHVnaWZ5IH19LyI+e3sgcCB9fTwvYT57JSBlbmRmb3IgJX0KICAgIDwvbmF2PgogICAgPGRpdiBjbGFzcz0ibnZ5LWhlYWRlci1yaWdodCI+CiAgICAgIDxhIGhyZWY9Ii9hYm91dC8iIHN0eWxlPSJmb250LXNpemU6MTNweDsiPkFib3V0PC9hPgogICAgICA8YSBocmVmPSIjbmV3c2xldHRlciIgY2xhc3M9Im52eS1idG4iIHN0eWxlPSJwYWRkaW5nOjEwcHggMjBweDsgZm9udC1zaXplOjExLjVweDsiPlNVQlNDUklCRTwvYT4KICAgIDwvZGl2PgogIDwvaGVhZGVyPgoKICB7eyBjb250ZW50IHwgc2FmZSB9fQoKICA8Zm9vdGVyIGNsYXNzPSJudnktZm9vdGVyIj4KICAgIDxkaXYgY2xhc3M9Im52eS1mb290ZXItdG9wIj4KICAgICAgPGRpdiBjbGFzcz0ibnZ5LWxvZ28iIHN0eWxlPSJmb250LXNpemU6MjBweDsiPk5BVllBQTwvZGl2PgogICAgICA8bmF2IGNsYXNzPSJudnktZm9vdGVyLW5hdiI+CiAgICAgICAgeyUgZm9yIHAgaW4gcGlsbGFycyAlfTxhIGhyZWY9Ii97eyBwIHwgc2x1Z2lmeSB9fS8iPnt7IHAgfX08L2E+eyUgZW5kZm9yICV9CiAgICAgICAgPGEgaHJlZj0iL2Fib3V0LyI+QWJvdXQ8L2E+CiAgICAgICAgPGEgaHJlZj0iL3N0YXJ0LWhlcmUvIj5TdGFydCBIZXJlPC9hPgogICAgICA8L25hdj4KICAgICAgPGRpdiBjbGFzcz0ibnZ5LWZvb3Rlci1zb2NpYWwtY29sIj4KICAgICAgICA8ZGl2IGNsYXNzPSJudnktZm9vdGVyLXNvY2lhbCI+CiAgICAgICAgICA8YSBocmVmPSIjIiBhcmlhLWxhYmVsPSJJbnN0YWdyYW0iPjxzdmcgd2lkdGg9IjE4IiBoZWlnaHQ9IjE4IiB2aWV3Qm94PSIwIDAgMjQgMjQiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzE1MTUxNSIgc3Ryb2tlLXdpZHRoPSIxLjYiPjxyZWN0IHg9IjMiIHk9IjMiIHdpZHRoPSIxOCIgaGVpZ2h0PSIxOCIgcng9IjUiLz48Y2lyY2xlIGN4PSIxMiIgY3k9IjEyIiByPSI0Ii8+PGNpcmNsZSBjeD0iMTcuNSIgY3k9IjYuNSIgcj0iMSIvPjwvc3ZnPjwvYT4KICAgICAgICAgIDxhIGhyZWY9IiMiIGFyaWEtbGFiZWw9IlgiPjxzdmcgd2lkdGg9IjE4IiBoZWlnaHQ9IjE4IiB2aWV3Qm94PSIwIDAgMjQgMjQiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzE1MTUxNSIgc3Ryb2tlLXdpZHRoPSIxLjYiPjxsaW5lIHgxPSI0IiB5MT0iNCIgeDI9IjIwIiB5Mj0iMjAiLz48bGluZSB4MT0iMjAiIHkxPSI0IiB4Mj0iNCIgeTI9IjIwIi8+PC9zdmc+PC9hPgogICAgICAgICAgPGEgaHJlZj0iIyIgYXJpYS1sYWJlbD0iTGlua2VkSW4iPjxzdmcgd2lkdGg9IjE4IiBoZWlnaHQ9IjE4IiB2aWV3Qm94PSIwIDAgMjQgMjQiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzE1MTUxNSIgc3Ryb2tlLXdpZHRoPSIxLjYiPjxyZWN0IHg9IjMiIHk9IjMiIHdpZHRoPSIxOCIgaGVpZ2h0PSIxOCIgcng9IjIiLz48bGluZSB4MT0iOCIgeTE9IjEwIiB4Mj0iOCIgeTI9IjE2Ii8+PGNpcmNsZSBjeD0iOCIgY3k9IjciIHI9IjAuNiIvPjxwYXRoIGQ9Ik0xMiAxNnYtNGMwLTEuNSAxLTIgMi0yczIgMC41IDIgMnY0Ii8+PC9zdmc+PC9hPgogICAgICAgIDwvZGl2PgogICAgICAgIDxhIGhyZWY9Im1haWx0bzpoZWxsb0BuYXZ5YWEuYmxvZyIgY2xhc3M9Im52eS1mb290ZXItY29udGFjdCI+Q29udGFjdCBOYXZ5YWE8L2E+CiAgICAgIDwvZGl2PgogICAgPC9kaXY+CiAgICA8ZGl2IGNsYXNzPSJudnktZm9vdGVyLWJvdHRvbSI+CiAgICAgIDxzcGFuPiZjb3B5OyB7eyBjdXJyZW50WWVhciB9fSBOYXZ5YWEuIEFsbCByaWdodHMgcmVzZXJ2ZWQuPC9zcGFuPgogICAgICA8c3Bhbj5SZWFsIHRob3VnaHRzLiBObyBmaWx0ZXJzLjwvc3Bhbj4KICAgIDwvZGl2PgogIDwvZm9vdGVyPgoKPC9kaXY+CjwvYm9keT4KPC9odG1sPgo="
$SCHEMA  = "PHNjcmlwdCB0eXBlPSJhcHBsaWNhdGlvbi9sZCtqc29uIj4KewogICJAY29udGV4dCI6ICJodHRwczovL3NjaGVtYS5vcmciLAogICJAdHlwZSI6ICJCbG9nUG9zdGluZyIsCiAgImhlYWRsaW5lIjogInt7IHNlb190aXRsZSBvciB0aXRsZSB9fSIsCiAgImRlc2NyaXB0aW9uIjogInt7IG1ldGFfZGVzY3JpcHRpb24gb3IgZXhjZXJwdCB9fSIsCiAgImltYWdlIjogImh0dHBzOi8vbmF2eWFhLmJsb2d7eyBpbWFnZSB9fSIsCiAgImRhdGVQdWJsaXNoZWQiOiAie3sgZGF0ZS50b0lTT1N0cmluZygpIH19IiwKICAiZGF0ZU1vZGlmaWVkIjogInt7IGRhdGUudG9JU09TdHJpbmcoKSB9fSIsCiAgImFydGljbGVTZWN0aW9uIjogInt7IHBpbGxhciB9fSIsCiAgImF1dGhvciI6IHsgIkB0eXBlIjogIlBlcnNvbiIsICJuYW1lIjogIk5hdnlhYSIsICJ1cmwiOiAiaHR0cHM6Ly9uYXZ5YWEuYmxvZy9hdXRob3IvbmF2eWFhLyIgfSwKICAicHVibGlzaGVyIjogewogICAgIkB0eXBlIjogIk9yZ2FuaXphdGlvbiIsCiAgICAibmFtZSI6ICJOYXZ5YWEiLAogICAgImxvZ28iOiB7ICJAdHlwZSI6ICJJbWFnZU9iamVjdCIsICJ1cmwiOiAiaHR0cHM6Ly9uYXZ5YWEuYmxvZy9pbWFnZXMvbG9nby5wbmciIH0KICB9LAogICJtYWluRW50aXR5T2ZQYWdlIjogeyAiQHR5cGUiOiAiV2ViUGFnZSIsICJAaWQiOiAiaHR0cHM6Ly9uYXZ5YWEuYmxvZ3t7IHBhZ2UudXJsIH19IiB9Cn0KPC9zY3JpcHQ+Cgo="
$ANCHOR_ARTICLE  = "PGRpdiBjbGFzcz0ibnZ5LWFydGljbGUtYm9keSBudnktc2FucyI+"
$ANCHOR_ELEVENTY = "ZWxldmVudHlDb25maWcuYWRkUGFzc3Rocm91Z2hDb3B5KHsgImFkbWluIjogImFkbWluIiB9KTs="
$ELEVENTY_ADDITION = "ZWxldmVudHlDb25maWcuYWRkUGFzc3Rocm91Z2hDb3B5KHsgImFkbWluIjogImFkbWluIiB9KTsNCiAgZWxldmVudHlDb25maWcuYWRkUGFzc3Rocm91Z2hDb3B5KHsgInNyYy9yb2JvdHMudHh0IjogInJvYm90cy50eHQiIH0pOw=="

# ---- 1. robots.txt ----
Write-Base64File -Base64 $ROBOTS -Path "src\robots.txt"
Write-Host "Created src\robots.txt" -ForegroundColor Green

# ---- 2. sitemap.njk ----
Write-Base64File -Base64 $SITEMAP -Path "src\sitemap.njk"
Write-Host "Created src\sitemap.njk" -ForegroundColor Green

# ---- 3. feed.njk ----
Write-Base64File -Base64 $FEED -Path "src\feed.njk"
Write-Host "Created src\feed.njk" -ForegroundColor Green

# ---- 4. base.njk (full replacement) ----
Write-Base64File -Base64 $BASE -Path "src\_includes\base.njk"
Write-Host "Replaced src\_includes\base.njk" -ForegroundColor Green

# ---- 5. .eleventy.js - insert one line after existing admin passthrough ----
$eleventyPath = ".eleventy.js"
$eleventyContent = Get-Content $eleventyPath -Raw
$anchorText = Decode-Base64 $ANCHOR_ELEVENTY
$additionText = Decode-Base64 $ELEVENTY_ADDITION
if ($eleventyContent.Contains($anchorText)) {
    if (-not $eleventyContent.Contains("src/robots.txt")) {
        $eleventyContent = $eleventyContent.Replace($anchorText, $additionText)
        [IO.File]::WriteAllText($eleventyPath, $eleventyContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated .eleventy.js (added robots.txt passthrough)" -ForegroundColor Green
    } else {
        Write-Host ".eleventy.js already has the robots.txt passthrough -- skipped" -ForegroundColor Yellow
    }
} else {
    Write-Host "WARNING: anchor line not found in .eleventy.js -- edit it manually (see .bak)" -ForegroundColor Red
}

# ---- 6. article.njk - insert schema block before the article body div ----
$articlePath = "src\_includes\article.njk"
$articleContent = Get-Content $articlePath -Raw
$anchorText2 = Decode-Base64 $ANCHOR_ARTICLE
$schemaText = Decode-Base64 $SCHEMA
if ($articleContent.Contains($anchorText2)) {
    if (-not $articleContent.Contains("application/ld+json")) {
        $articleContent = $articleContent.Replace($anchorText2, ($schemaText + $anchorText2))
        [IO.File]::WriteAllText($articlePath, $articleContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated article.njk (added BlogPosting schema)" -ForegroundColor Green
    } else {
        Write-Host "article.njk already has JSON-LD schema -- skipped" -ForegroundColor Yellow
    }
} else {
    Write-Host "WARNING: anchor line not found in article.njk -- edit it manually (see .bak)" -ForegroundColor Red
}

# ---- 7. Copy image/icon assets from Downloads ----
$assets = @{
    "favicon.ico"           = "src\favicon.ico"
    "apple-touch-icon.png"  = "src\apple-touch-icon.png"
    "logo.png"              = "src\images\logo.png"
    "default-og-image.jpg"  = "src\images\default-og-image.jpg"
}
New-Item -ItemType Directory -Force -Path "src\images" | Out-Null
foreach ($file in $assets.Keys) {
    $srcFile = Join-Path $downloads $file
    if (Test-Path $srcFile) {
        Copy-Item $srcFile $assets[$file] -Force
        Write-Host "Copied $file" -ForegroundColor Green
    } else {
        Write-Host "SKIPPED: $file not found in $downloads -- copy it manually to $($assets[$file])" -ForegroundColor Red
    }
}

# ---- 8. Git add, commit, push ----
git add -A
git commit -m "Add sitemap, robots.txt, RSS feed, schema markup, favicon, og:image fix"
git push origin main

Write-Host ""
Write-Host "Done. Check Netlify's Deploys tab to confirm the build succeeded." -ForegroundColor Cyan
