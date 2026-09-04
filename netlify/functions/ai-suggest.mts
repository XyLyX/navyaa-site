import type { Context, Config } from "@netlify/functions";

const PILLARS = ["Love", "Self", "Life", "Soul", "Unfiltered"];
const MOODS = [
  "Melancholic", "Nostalgic", "Romantic", "Reflective", "Contemplative",
  "Hopeful", "Restless", "Angry", "Playful", "Peaceful",
];

// Strip basic HTML down to plain text before sending to the model —
// keeps the prompt compact and avoids leaking markup into suggestions.
function stripHtml(html: string): string {
  return html
    .replace(/<!--[\s\S]*?-->/g, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/\s+/g, " ")
    .trim();
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

  let body: { title?: string; content?: string };
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

  if (!title && !content) {
    return new Response(JSON.stringify({ error: "Write a title or some content first." }), {
      status: 400,
      headers: { "content-type": "application/json" },
    });
  }

  const model = Netlify.env.get("OPENAI_MODEL") || "gpt-4o-mini";

  const systemPrompt =
    "You are the editorial assistant for Navyaa, a personal essay blog about Love, Self, Life, Soul and Unfiltered truths. " +
    "You suggest metadata for a new post. You NEVER invent facts about the author. You respond with strict JSON only, no prose, no markdown fences.";

  const userPrompt =
    `Title: ${title}\n\nBody:\n${content}\n\n` +
    "Return a JSON object with exactly these keys: " +
    `{"category":"one of: ${PILLARS.join(", ")}",` +
    `"mood":"one of: ${MOODS.join(", ")}",` +
    `"secondary_mood":"one of: ${MOODS.join(", ")} or empty string",` +
    `"intensity": <integer 1-10>,` +
    `"excerpt":"1-2 sentence excerpt in Navyaa's voice, under 200 characters",` +
    `"seo_title":"a search-friendly title distinct from the literary title, under 60 characters",` +
    `"meta_description":"under 155 characters",` +
    `"tags":["3-5 lowercase tags"],` +
    `"featured_quote":"the single strongest sentence pulled verbatim from the body, or empty string if too short"}`;

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
        temperature: 0.6,
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
