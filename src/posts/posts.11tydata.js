module.exports = {
  tags: ["post"],
  layout: "article.njk",
  eleventyComputed: {
    permalink: (data) => `/${data.slug || data.page.fileSlug}/`,
  },
};
