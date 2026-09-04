module.exports = {
  layout: "page.njk",
  eleventyComputed: {
    permalink: (data) => `/${data.slug || data.page.fileSlug}/`,
  },
};
