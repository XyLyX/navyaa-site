import type { Context, Config } from "@netlify/functions";

const PILLARS = ["Love", "Self", "Life", "Soul"];
const MOODS = [
  "Melancholic", "Nostalgic", "Romantic", "Reflective", "Contemplative",
  "Hopeful", "Restless", "Angry", "Playful", "Peaceful",
];

// The site's own live post index -- regenerated every build by
// src/posts-index.njk. Always accurate, so linking against it means a
// typed title can never resolve to the wrong slug the way a freshly
// slugified guess could.
const POSTS_INDEX_URL = "https://navyaa.blog/posts-index.json";

// The four content clusters from the SEO content audit (v2). Static by
// design -- this is editorial strategy, not generated data, so it's kept
// here directly rather than fetched. Update this list by hand when the
// cluster plan changes.
const CLUSTERS = [
  { name: "Pulling Away", pillar: "Love" },
  { name: "Breakups & Healing", pillar: "Love/Self" },
  { name: "Overthinking", pillar: "Self" },
  { name: "Self-worth", pillar: "Love" },
];

// Navyaa's featured-image house style — kept here so every AI-suggested
// image prompt stays on-brand instead of drifting toward generic stock-photo
// or wellness-blog imagery. Four failure modes have shown up in testing:
// (1) recycling the same props regardless of content, (2) an identical
// scene/setting around a swapped-out prop, (3) the generator defaulting to
// an "object beside a window" composition regardless of what the text
// asks for, and (4) the most significant one -- this guide used to hardcode
// "contemplative, quiet, a little melancholic" as the mood for EVERY image,
// which actively misrepresented essays that are witty, playful, or comedic
// in tone (confirmed on a real essay: a funny, self-deprecating piece about
// post-surgery food cravings got rendered as somber and melancholic). The
// mood taxonomy this function already assigns (Playful, Hopeful, Restless,
// Melancholic, etc.) must now drive the image's emotional register too,
// not be overridden by one fixed tone.
const IMAGE_STYLE_GUIDE =
  "Editorial, literary-journal photography or painterly cinematic realism — never stock-photo or wellness-blog looking. " +
  "Muted cream, charcoal, burgundy and olive tones. Soft natural or film-like light, subtle grain. No text, no " +
  "watermarks, no logos, no visible faces, never staged smiling people. " +
  "THE IMAGE TRANSLATES THE ESSAY'S FEELING — IT DOES NOT ILLUSTRATE ITS CONTENT. Never build the image from a " +
  "list of objects or places the essay happens to mention (kitchens, coffee mugs, notebooks, desks, empty rooms, " +
  "windows). A literal inventory of props is a failure. " +
  "METHOD: first identify the essay's inner conflict (what the writer is wrestling with beneath the surface) and " +
  "its emotional turn. Then choose ONE visual metaphor that embodies that conflict through relationship, not " +
  "inventory: scale (a small figure against vast space), distance, a threshold or doorway, direction of travel, " +
  "stillness against motion, light against dark, reflection, weight, or something being left behind or approached. " +
  "The scene needs: a subject (usually a human figure seen from behind, in silhouette, or partially; or one " +
  "single symbolic element), an emotional state expressed through posture, a clear light source that carries " +
  "meaning, the scale of the environment relative to the subject, and ONE contrasting element that creates " +
  "tension (crowd vs. solitude, motion vs. stillness, warm vs. cold). Use at most one or two concrete objects, " +
  "and only when they carry the metaphor. " +
  "EMOTIONAL REGISTER must follow the mood and secondary_mood you assigned elsewhere in your response. A Playful, " +
  "witty or self-deprecating essay gets warmth, wry humor and lightness; reserve somber, heavy imagery for " +
  "essays that are genuinely Melancholic, Nostalgic or similarly weighty. " +
  "FRAMING: vary it between essays and state your choice — a wide shot with a small figure in a vast space; a " +
  "silhouette against light; an over-the-shoulder view; an extreme close-up of a hand or gesture; a top-down " +
  "view; a view through a doorway; an off-center subject with generous negative space; an outdoor or urban " +
  "scene with motion blur. Do NOT default to an interior with a window. " +
  "Composition: 16:9 landscape frame, roughly 1920x1080 or larger, subject centered with breathing room on " +
  "both left and right edges, since the site crops this same image into a wide homepage banner, a narrower " +
  "article header and square-ish cards, always from the center outward.";

// Strip basic HTML down to plain text before sending to the model —
// keeps the prompt compact and avoids leaking markup into suggestions.
function stripHtml(html: string): string {
  return html
    .replace(/<!--[\s\S]*?-->/g, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

// Guarantee a clean, usable URL slug no matter what the model returns —
// lowercase, hyphen-separated, no punctuation, capped to a sane length.
function slugify(str: string): string {
  return String(str || "")
    .toLowerCase()
    .replace(/['’]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-+|-+$)/g, "")
    .slice(0, 60)
    .replace(/-+$/, "");
}

function normalizeForMatch(str: string): string {
  return String(str || "").toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();
}

type IndexedPost = { title: string; seo_title?: string; url: string; pillar?: string };

// Resolve a writer-typed title against the live posts index. Checks BOTH
// the original literary title and the SEO title -- a post's on-page H1
// stays the original poetic title even after an SEO rewrite changes
// seo_title/slug (see the v2 audit's "metadata only" scope decision), so
// a writer typing whichever version they happen to remember should still
// resolve correctly. Exact (case/punctuation-insensitive) match only --
// no fuzzy guessing, so a resolved link is always a real, confirmed URL.
function resolveLinkedTitles(
  typedTitles: string[],
  index: IndexedPost[]
): { verified: { title: string; url: string }[]; unresolved: string[] } {
  const verified: { title: string; url: string }[] = [];
  const unresolved: string[] = [];

  for (const typed of typedTitles) {
    const target = normalizeForMatch(typed);
    const match = index.find(
      (p) => normalizeForMatch(p.title) === target || normalizeForMatch(p.seo_title || "") === target
    );
    if (match) {
      verified.push({ title: match.title, url: match.url });
    } else {
      unresolved.push(typed);
    }
  }

  return { verified, unresolved };
}

export default async (req: Request, context: Context) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Use POST" }), {
      status: 405,
      headers: { "content-type": "application/json" },
    });
  }

  const apiKey = Netlify.env.get("OPENAI_API_KEY");
  if (!apiKey) {
    return new Response(
      JSON.stringify({
        error: "OPENAI_API_KEY is not set. Add it in Site settings > Environment variables.",
      }),
      { status: 500, headers: { "content-type": "application/json" } }
    );
  }

  let body: { title?: string; content?: string; linked_titles?: string[] };
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
      status: 400,
      headers: { "content-type": "application/json" },
    });
  }

  const title = (body.title || "").slice(0, 300);
  const content = stripHtml(body.content || "").slice(0, 6000);
  const typedLinkTitles = (Array.isArray(body.linked_titles) ? body.linked_titles : [])
    .filter((t): t is string => typeof t === "string" && t.trim().length > 0)
    .slice(0, 6);

  if (!title && !content) {
    return new Response(JSON.stringify({ error: "Write a title or some content first." }), {
      status: 400,
      headers: { "content-type": "application/json" },
    });
  }

  // Fetch the live posts index so linked titles resolve to real URLs.
  // If the index can't be reached, we still return every other
  // suggestion -- link resolution just comes back empty with a note.
  let postsIndex: IndexedPost[] = [];
  let indexFetchError = "";
  try {
    const idxResp = await fetch(POSTS_INDEX_URL);
    if (idxResp.ok) {
      postsIndex = await idxResp.json();
    } else {
      indexFetchError = `Could not load posts index (status ${idxResp.status}).`;
    }
  } catch (e) {
    indexFetchError = `Could not load posts index: ${(e as Error).message}`;
  }

  const { verified: verifiedLinks, unresolved: unresolvedLinks } = resolveLinkedTitles(
    typedLinkTitles,
    postsIndex
  );

  const model = Netlify.env.get("OPENAI_MODEL") || "gpt-4o-mini";

  const clusterList = CLUSTERS.map((c) => `${c.name} (${c.pillar})`).join(", ");

  const linkContext = verifiedLinks.length
    ? "These existing Navyaa posts should be linked naturally in the body:\n" +
      verifiedLinks.map((l) => `- "${l.title}" -> ${l.url}`).join("\n")
    : "No existing posts were provided to link to.";

  const systemPrompt =
    "You are the editorial assistant for Navyaa, a personal essay blog about Love, Self, Life and Soul. " +
    "You suggest metadata AND structure for a new post. You NEVER invent facts about the author. " +
    "The writer's literary voice must be preserved -- your suggestions are proposals the writer reviews and " +
    "manually applies, never auto-published text. " +
    "When you write image_prompt, follow this house style exactly: " + IMAGE_STYLE_GUIDE + " " +
    "You respond with strict JSON only, no prose, no markdown fences.";

  const userPrompt =
    `Title: ${title}\n\nBody:\n${content}\n\n` +
    `${linkContext}\n\n` +
    `Available content clusters (pick the closest fit, or "None" if this essay doesn't fit any): ${clusterList}\n\n` +
    "Return a JSON object with exactly these keys: " +
    `{"category":"one of: ${PILLARS.join(", ")}",` +
    `"mood":"one of: ${MOODS.join(", ")}",` +
    `"secondary_mood":"one of: ${MOODS.join(", ")} or empty string",` +
    `"intensity": <integer 1-10>,` +
    `"excerpt":"1-2 sentence excerpt in Navyaa's voice, under 200 characters",` +
    `"seo_title":"a search-friendly title distinct from the literary title, under 60 characters",` +
    `"meta_description":"under 155 characters",` +
    `"tags":["3-5 lowercase tags"],` +
    `"featured_quote":"the single strongest sentence pulled verbatim from the body, or empty string if too short",` +
    `"slug":"a kebab-case URL slug derived from the title — lowercase, hyphen-separated, no punctuation, 3-7 words, under 60 characters",` +
    `"emotional_core":"one sentence naming the essay's inner conflict and emotional turn -- NOT its topic or setting",` +
    `"visual_metaphor":"one sentence describing a single metaphorical image (relationship of figure, space, light, motion) that embodies the emotional core, with no inventory of props from the text",` +
    `"image_prompt":"one ready-to-use AI image-generation prompt built from the visual_metaphor above (never a list of objects from the text), following the house style. Describe subject and posture, light source, environment scale and the contrasting element. End it with the literal text ` +
    `'16:9 landscape, centered composition, 1920x1080' so the ratio travels with the prompt wherever it's pasted. 4-6 sentences.",` +
    `"cluster":"the best-fit cluster name from the list above, or \\"None\\"",` +
    `"cluster_role":"\\"supporting\\" if a cluster was chosen, otherwise empty string",` +
    `"h2_outline":["5-7 section headings for this essay, following a searchable-but-literary structure: a quick-answer opener, the deep analysis in the writer's own words, a practical/what-to-do section, and a closing reflection -- adapt the exact headings to what this specific essay is actually about"],` +
    `"key_takeaway":"a 1-2 sentence direct answer to the essay's core question, suitable for a highlighted callout box near the top",` +
    `"faq":[{"question":"...", "answer":"1-2 sentence answer"}] ` +
    `(2-4 items ONLY if the topic genuinely has question-shaped search intent, otherwise an empty array),` +
    `"link_placements":[{"title":"exact title as given above", "suggested_sentence":"a natural sentence from THIS essay's body or a close paraphrase of one, showing where and how to weave in a link to that post"}] ` +
    `(one entry per linked post provided above; omit this key entirely if none were provided)}`;

  try {
    const resp = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model,
        response_format: { type: "json_object" },
        temperature: 0.75,
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
      }),
    });

    if (!resp.ok) {
      const errText = await resp.text();
      return new Response(
        JSON.stringify({ error: `OpenAI request failed (${resp.status}): ${errText.slice(0, 300)}` }),
        { status: 502, headers: { "content-type": "application/json" } }
      );
    }

    const data = await resp.json();
    const raw = data?.choices?.[0]?.message?.content || "{}";
    let parsed: Record<string, unknown>;
    try {
      parsed = JSON.parse(raw);
    } catch {
      return new Response(JSON.stringify({ error: "The model returned invalid JSON." }), {
        status: 502,
        headers: { "content-type": "application/json" },
      });
    }

    // Light validation / clamping so a bad response from the model can't
    // write garbage into the CMS fields — AI recommends, the writer still
    // reviews before publishing anything.
    if (typeof parsed.category === "string" && !PILLARS.includes(parsed.category)) {
      parsed.category = "";
    }
    if (typeof parsed.mood === "string" && !MOODS.includes(parsed.mood)) {
      parsed.mood = "";
    }
    if (typeof parsed.secondary_mood === "string" && !MOODS.includes(parsed.secondary_mood)) {
      parsed.secondary_mood = "";
    }
    if (typeof parsed.intensity !== "number") {
      parsed.intensity = 5;
    }
    parsed.intensity = Math.max(1, Math.min(10, Math.round(parsed.intensity as number)));

    // Slug always comes back well-formed, even if the model ignores the
    // instructions — fall back to slugifying the title itself.
    parsed.slug = slugify((typeof parsed.slug === "string" && parsed.slug.trim()) || title);

    if (typeof parsed.image_prompt !== "string") {
      parsed.image_prompt = "";
    }
    parsed.image_prompt = parsed.image_prompt.slice(0, 1100);
    // Reasoning-only fields: they make the model think before writing the prompt; not needed by the CMS.
    delete parsed.emotional_core;
    delete parsed.visual_metaphor;

    // Cluster must be a real cluster name or "None" -- never trust the
    // model's own string verbatim.
    const clusterNames = CLUSTERS.map((c) => c.name);
    if (typeof parsed.cluster !== "string" || !clusterNames.includes(parsed.cluster)) {
      parsed.cluster = "None";
    }
    parsed.cluster_role = parsed.cluster === "None" ? "" : "supporting";

    if (!Array.isArray(parsed.h2_outline)) {
      parsed.h2_outline = [];
    }
    if (typeof parsed.key_takeaway !== "string") {
      parsed.key_takeaway = "";
    }
    if (!Array.isArray(parsed.faq)) {
      parsed.faq = [];
    }

    // Overwrite the model's link_placements titles/urls with our own
    // verified data -- the model only supplies the suggested sentence,
    // never the URL itself, so a hallucinated or mismatched link is
    // structurally impossible.
    const modelPlacements = Array.isArray(parsed.link_placements) ? parsed.link_placements : [];
    parsed.link_placements = verifiedLinks.map((link) => {
      const modelEntry = modelPlacements.find(
        (p: any) => typeof p?.title === "string" && normalizeForMatch(p.title) === normalizeForMatch(link.title)
      );
      return {
        title: link.title,
        url: link.url,
        verified: true,
        suggested_sentence:
          typeof modelEntry?.suggested_sentence === "string" ? modelEntry.suggested_sentence : "",
      };
    });

    if (unresolvedLinks.length) {
      parsed.unresolved_link_titles = unresolvedLinks;
      parsed.unresolved_link_note =
        "These titles didn't exactly match any existing post -- check spelling against the real post title, or leave them out.";
    }
    if (indexFetchError) {
      parsed.link_index_error = indexFetchError;
    }

    return new Response(JSON.stringify(parsed), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: `Unexpected error: ${(err as Error).message}` }), {
      status: 500,
      headers: { "content-type": "application/json" },
    });
  }
};

export const config: Config = {
  path: "/api/ai-suggest",
};
