# Getting Navyaa live — step by step

You've already done step 1 (creating the empty `navyaa-site` repo at github.com/XyLyX/navyaa-site and cloning it with GitHub Desktop). The config is already pointed at your repo — no code edits needed. Here's the rest.

## 1. Drop these files into your cloned folder

Copy everything from this folder into the empty `navyaa-site` folder GitHub Desktop created on your computer (the one you cloned in step 1). Then in GitHub Desktop:

1. You'll see a long list of new files under "Changes."
2. Type a commit message, e.g. "Initial site."
3. Click **Commit to main**, then **Push origin**.

## 2. Connect the repo to Netlify

1. Go to [app.netlify.com](https://app.netlify.com) and log in (or sign up — it's free for this).
2. Click **Add new site → Import an existing project**.
3. Choose **GitHub**, authorize it if asked, and select the `navyaa-site` repo.
4. Netlify should auto-detect the build settings from `netlify.toml` (build command `npm run build`, publish folder `_site`). Click **Deploy**.
5. Wait a minute or two for the first build. You'll get a temporary address like `random-name-123.netlify.app` — that's your site, live.

## 3. Add your OpenAI key

1. In Netlify: **Site configuration → Environment variables → Add a variable**.
2. Key: `OPENAI_API_KEY`, Value: your OpenAI API key (starts with `sk-`). Get one at platform.openai.com if you don't have one yet.
3. Optional: add `OPENAI_MODEL` with value `gpt-4o-mini` (this is the default if you skip it — cheap and fast; you can switch to `gpt-4o` later for better suggestions at a higher cost).
4. Trigger a redeploy (**Deploys → Trigger deploy**) so the function picks up the key.

## 4. Turn on your writing tool (the CMS)

This is what makes `yoursite.com/admin` work — the form you'll use to write new posts. It needs to be able to check you in with your GitHub account before it'll let you save anything.

1. In Netlify: **Site configuration → General → OAuth** (older Netlify UIs put this under "Access control").
2. Click **Install provider**, choose **GitHub**.
3. This asks for a GitHub "OAuth App" Client ID and Secret. To get those: go to [github.com/settings/developers](https://github.com/settings/developers) → **OAuth Apps → New OAuth App**. Fill in:
   - Application name: `Navyaa CMS`
   - Homepage URL: your Netlify site URL
   - Authorization callback URL: `https://api.netlify.com/auth/done`
4. GitHub gives you a Client ID and Client Secret — paste both into the Netlify OAuth screen from step 2.
5. Visit `yoursite.com/admin`, log in with GitHub when prompted. You should see "Essays" and "Pages" — try writing a test post.

## 5. Point navyaa.blog at the new site

Once you're happy with everything at the temporary `.netlify.app` address:

1. In Netlify: **Domain settings → Add a domain** → enter `navyaa.blog`.
2. Netlify will show you DNS records to add. In GoDaddy, go to your domain's **DNS Management** and add whatever Netlify shows (usually an A record or a CNAME, and Netlify's instructions will say exactly which).
3. DNS changes can take anywhere from a few minutes to a few hours to fully take effect.
4. Once it's live on `navyaa.blog`, your old WordPress post links will automatically redirect to the right pages on the new site (that's already built into `netlify.toml`).

## Writing a new post from now on

Go to `navyaa.blog/admin`, log in with GitHub, click **New Essay**. Write it, click **Analyze with AI** to get suggestions for the pillar/mood/tags/etc. (it never fills anything in for you — you read the suggestions and set the fields yourself), then **Save** and **Publish** when you're happy. The site rebuilds automatically in about a minute.

## If something breaks

Come back to this conversation and tell me what's going wrong — I can usually diagnose it from a screenshot or the Netlify deploy log.
