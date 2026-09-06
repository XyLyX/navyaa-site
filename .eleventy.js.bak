const { DateTime } = (() => {
  // Tiny built-in date formatter (avoid adding luxon as a dependency)
  return {
    DateTime: {
      fromJSDate: (d) => ({
        toFormat: (fmt) => {
          const months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
          const day = d.getDate();
          const month = months[d.getMonth()];
          const year = d.getFullYear();
          if (fmt === "LLLL d, yyyy") return `${month} ${day}, ${year}`;
          if (fmt === "LLL d, yyyy") return `${month.slice(0,3)} ${day}, ${year}`;
          return d.toISOString();
        }
      })
    }
  };
})();

const PILLARS = ["Love", "Self", "Life", "Soul", "Unfiltered"];
const PILLAR_SUBS = {
  Love: "Relationships, Attachment, Heartbreak",
  Self: "Identity, Loneliness, Overthinking",
  Life: "Freedom, Ambition, Reinvention",
  Soul: "Meaning, Mortality, Spirituality",
  Unfiltered: "Opinions, Society, The real stuff",
};

function slugify(str) {
  return String(str)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
}

function readingTime(content) {
  if (!content) return 1;
  const text = String(content).replace(/<[^>]+>/g, " ");
  const words = text.trim().split(/\s+/).filter(Boolean).length;
  return Math.max(1, Math.round(words / 200));
}

function trimWords(content, n) {
  if (!content) return "";
  const text = String(content).replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
  const words = text.split(" ");
  if (words.length <= n) return text;
  return words.slice(0, n).join(" ") + "…";
}

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy({ "src/css": "css" });
  eleventyConfig.addPassthroughCopy({ "src/images": "images" });
  eleventyConfig.addPassthroughCopy({ "admin": "admin" });

  eleventyConfig.addFilter("slugify", slugify);
  eleventyConfig.addFilter("readingTime", readingTime);
  eleventyConfig.addFilter("trimWords", trimWords);
  eleventyConfig.addFilter("dateFmt", (dateObj, fmt) => {
    const d = dateObj instanceof Date ? dateObj : new Date(dateObj);
    return DateTime.fromJSDate(d).toFormat(fmt || "LLLL d, yyyy");
  });
  eleventyConfig.addFilter("upper", (s) => String(s || "").toUpperCase());
  eleventyConfig.addFilter("pad2", (n) => String(n).padStart(2, "0"));
  // Used to build share links (WhatsApp/X/Facebook/LinkedIn/email) directly
  // in templates, so they work even before the page's JS has loaded.
  eleventyConfig.addFilter("urlencode", (s) => encodeURIComponent(s || ""));
  eleventyConfig.addFilter("where", (arr, key, val) =>
    (arr || []).filter((item) => item.data[key] === val)
  );

  // Nunjucks' built-in `slice` filter CHUNKS an array into N groups
  // (like a "split into pieces" operation) rather than doing a
  // Python/JS-style range slice — override it here so `arr | slice(1, 4)`
  // means "elements 1 through 4", matching how every template in this
  // site uses it.
  eleventyConfig.addFilter("slice", (arr, start, end) => (arr || []).slice(start, end));

  eleventyConfig.addCollection("posts", (api) =>
    api.getFilteredByGlob("src/posts/*.md")
      .filter((p) => !p.data.draft)
      .sort((a, b) => b.date - a.date)
  );

  // Same as "posts" but with any featured:true post moved to the front —
  // mirrors WordPress's native "Sticky Post" homepage-feature behavior.
  eleventyConfig.addCollection("postsFeaturedFirst", (api) => {
    const posts = api.getFilteredByGlob("src/posts/*.md")
      .filter((p) => !p.data.draft)
      .sort((a, b) => b.date - a.date);
    const featured = posts.filter((p) => p.data.featured);
    const rest = posts.filter((p) => !p.data.featured);
    return featured.concat(rest);
  });

  eleventyConfig.addCollection("postsByPillar", (api) => {
    const posts = api.getFilteredByGlob("src/posts/*.md")
      .filter((p) => !p.data.draft)
      .sort((a, b) => b.date - a.date);
    const map = {};
    PILLARS.forEach((p) => (map[p] = []));
    posts.forEach((p) => {
      if (map[p.data.pillar]) map[p.data.pillar].push(p);
    });
    return map;
  });

  eleventyConfig.addGlobalData("pillars", PILLARS);
  eleventyConfig.addGlobalData("pillarSubs", PILLAR_SUBS);
  eleventyConfig.addGlobalData("currentYear", new Date().getFullYear());

  return {
    dir: {
      input: "src",
      includes: "_includes",
      data: "_data",
      output: "_site",
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
  };
};
