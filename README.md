# Navyaa — the new site

This folder is the whole website: code, design, your 48 migrated essays, and the writing tool you'll use going forward. It replaces WordPress entirely.

## What's in here

- **`src/`** — the site itself. Templates in `src/_includes/`, your essays in `src/posts/` (one markdown file each), and your pages (About, Start Here, Contact, etc.) in `src/pages/`.
- **`admin/`** — this is your writing tool. Once the site is live, you'll go to `yoursite.com/admin` to write and publish new posts — no code, no GitHub, just a form.
- **`netlify/functions/ai-suggest.mts`** — the "Analyze with AI" backend. When you click that button in the admin tool, this is what calls OpenAI and hands back suggestions for the pillar, mood, excerpt, tags, etc. It never publishes anything by itself — you always review and set the fields yourself.
- **`netlify.toml`** — tells Netlify how to build the site, plus 48 redirects so your old WordPress post links keep working after the move.

## What happens to your images

Your 100 or so images are still referenced from your old WordPress.com address behind the scenes (`navyauae-hloqy.wordpress.com`) — not your custom domain, so they'll keep working even after `navyaa.blog`'s DNS points somewhere else, as long as you don't delete or downgrade that WordPress.com site. I wasn't able to bulk-download all of them into this folder automatically (WordPress.com's media library doesn't offer a real bulk-export, and the automation kept timing out), so this is a known trade-off — the site works today, and fully self-hosting the images is a clean follow-up task whenever you want it done. Any brand-new photos you add through the admin tool from now on ARE stored with the new site from day one.

## Setup — see HANDOFF.md

Everything you need to do, in order, is in `HANDOFF.md`.
