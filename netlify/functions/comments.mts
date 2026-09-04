import type { Context, Config } from "@netlify/functions";
import { getStore } from "@netlify/blobs";

type Comment = { id: string; name: string; text: string; date: string };

function isValidSlug(slug: unknown): slug is string {
  return typeof slug === "string" && /^[a-z0-9-]{1,120}$/.test(slug);
}

function isAdmin(req: Request): boolean {
  const key = Netlify.env.get("COMMENTS_ADMIN_KEY");
  if (!key) return false; // moderation is disabled until the key is set
  return req.headers.get("x-admin-key") === key;
}

function makeId(): string {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
}

async function readComments(store: ReturnType<typeof getStore>, slug: string): Promise<Comment[]> {
  const data = await store.get(slug, { type: "json" });
  return Array.isArray(data) ? (data as Comment[]) : [];
}

export default async (req: Request, context: Context) => {
  const store = getStore("comments");
  const url = new URL(req.url);

  if (req.method === "GET") {
    // Admin moderation view: every comment across every essay.
    if (url.searchParams.get("admin") === "1") {
      if (!isAdmin(req)) {
        return new Response(JSON.stringify({ error: "Unauthorized" }), {
          status: 401,
          headers: { "content-type": "application/json" },
        });
      }
      const all: (Comment & { slug: string })[] = [];
      for await (const { blobs } of store.list()) {
        for (const b of blobs) {
          const comments = await readComments(store, b.key);
          for (const c of comments) all.push({ ...c, slug: b.key });
        }
      }
      all.sort((a, b) => (a.date < b.date ? 1 : -1)); // newest first
      return new Response(JSON.stringify({ comments: all }), {
        status: 200,
        headers: { "content-type": "application/json" },
      });
    }

    const slug = url.searchParams.get("slug") || "";
    if (!isValidSlug(slug)) {
      return new Response(JSON.stringify({ error: "Missing or invalid slug" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }
    const comments = await readComments(store, slug);
    comments.sort((a, b) => (a.date > b.date ? 1 : -1)); // oldest first, like a conversation
    return new Response(JSON.stringify({ comments }), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  }

  if (req.method === "POST") {
    let body: { slug?: string; name?: string; text?: string; hp?: string };
    try {
      body = await req.json();
    } catch {
      return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }

    // Honeypot: a real visitor never fills this hidden field. If it's
    // filled, pretend success so bots don't learn to look elsewhere.
    if (body.hp) {
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { "content-type": "application/json" },
      });
    }

    const slug = body.slug || "";
    const name = (body.name || "").trim().slice(0, 60);
    const text = (body.text || "").trim().slice(0, 2000);

    if (!isValidSlug(slug)) {
      return new Response(JSON.stringify({ error: "Missing or invalid slug" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }
    if (!name || !text) {
      return new Response(JSON.stringify({ error: "Name and comment can't be empty." }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }

    const comment: Comment = { id: makeId(), name, text, date: new Date().toISOString() };
    const comments = await readComments(store, slug);
    comments.push(comment);
    await store.setJSON(slug, comments);

    return new Response(JSON.stringify({ comment }), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  }

  if (req.method === "DELETE") {
    if (!isAdmin(req)) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { "content-type": "application/json" },
      });
    }
    let body: { slug?: string; id?: string };
    try {
      body = await req.json();
    } catch {
      return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }
    const slug = body.slug || "";
    if (!isValidSlug(slug) || !body.id) {
      return new Response(JSON.stringify({ error: "Missing slug or id" }), {
        status: 400,
        headers: { "content-type": "application/json" },
      });
    }
    const comments = await readComments(store, slug);
    const next = comments.filter((c) => c.id !== body.id);
    await store.setJSON(slug, next);
    return new Response(JSON.stringify({ ok: true, removed: comments.length - next.length }), {
      status: 200,
      headers: { "content-type": "application/json" },
    });
  }

  return new Response(JSON.stringify({ error: "Use GET, POST or DELETE" }), {
    status: 405,
    headers: { "content-type": "application/json" },
  });
};

export const config: Config = {
  path: "/api/comments",
};
