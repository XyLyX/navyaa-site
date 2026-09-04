import type { Context, Config } from "@netlify/functions";
import { getStore } from "@netlify/blobs";

// Guard against a garbage/absurd slug being used to write arbitrary blob keys.
function isValidSlug(slug: unknown): slug is string {
  return typeof slug === "string" && /^[a-z0-9-]{1,120}$/.test(slug);
}

export default async (req: Request, context: Context) => {
  const store = getStore("likes");

  if (req.method === "GET") {
    const slug = new URL(req.url).searchParams.get("slug") || "";
    if (!isValidSlug(slug)) {
      return new Response(JSON.stringify({ error: "Missing or invalid slug" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }
    const count = Number((await store.get(slug)) || 0);
    return new Response(JSON.stringify({ count: Number.isFinite(count) ? count : 0 }), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  }

  if (req.method === "POST") {
    let body: { slug?: string };
    try {
      body = await req.json();
    } catch {
      return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }

    const slug = body.slug || "";
    if (!isValidSlug(slug)) {
      return new Response(JSON.stringify({ error: "Missing or invalid slug" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }

    // Netlify Blobs has no built-in atomic increment, so read-then-write.
    // Under simultaneous likes this can occasionally undercount by one or
    // two — acceptable for a personal-essay like counter, not a ledger.
    const current = Number((await store.get(slug)) || 0);
    const next = (Number.isFinite(current) ? current : 0) + 1;
    await store.set(slug, String(next));

    return new Response(JSON.stringify({ count: next }), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  }

  return new Response(JSON.stringify({ error: "Use GET or POST" }), {
    status: 405,
    headers: { "content-type": "application/json" },
  });
};

export const config: Config = {
  path: "/api/like",
};
