# embeddedaustria-website

The website for Embedded Austria, built with [Hugo](https://gohugo.io/) and the [Tailbliss](https://github.com/nusserstudios/tailbliss) theme.

## Prerequisites

- [Hugo](https://gohugo.io/installation/) (extended edition)
- [Node.js](https://nodejs.org/) (LTS recommended)
- [pnpm](https://pnpm.io/installation)

## Getting Started

```bash
git clone --recurse-submodules https://github.com/<org>/embeddedaustria-website.git
cd embeddedaustria-website
pnpm install
hugo server
```

The site will be available at `http://localhost:1313`.

### Production Build

```bash
hugo --minify
```

Output is generated in the `public/` directory.

## Contributing a Blog Post

Guest bloggers are welcome! To submit an article via pull request:

### 1. Fork & Clone

```bash
git fork https://github.com/<org>/embeddedaustria-website.git
git clone --recurse-submodules <your-fork-url>
cd embeddedaustria-website
```

### 2. Create Your Post

Create a new Markdown file under `content/blog/`:

```bash
hugo new blog/my-article-title/index.md
```

This generates a file with front matter. Fill in the metadata:

```yaml
---
title: "Your Article Title"
date: 2026-02-15
description: "A short summary of your article."
author: "Your Name"
tags: ["embedded", "iot"]
draft: false
---

Your article content goes here. Use standard Markdown.
```

### 3. Add Images (Optional)

Place images in the same directory as your post:

```
content/blog/my-article-title/
├── index.md
└── featured.png
```

Reference them in Markdown:

```markdown
![Alt text](featured.png)
```

### 4. Preview Locally

```bash
pnpm install
hugo server -D
```

Verify your post looks correct at `http://localhost:1313/blog/my-article-title/`.

### 5. Submit a Pull Request

```bash
git checkout -b blog/my-article-title
git add content/blog/my-article-title/
git commit -m "Add blog post: Your Article Title"
git push origin blog/my-article-title
```

Then open a pull request on GitHub. Please include only your blog post files — do not modify theme files or site configuration.

## License

Content is © Embedded Austria. See [LICENSE](LICENSE) for details.
