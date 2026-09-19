# SEO Tasklist — embeddedaustria.com

> **Status 2026-09-19:** P0 and P1 are implemented and **deployed live**. Verified on
> www.embeddedaustria.com: gzip + `Cache-Control` active, `/posts/*` and `/prose/` return
> 410, 35 sitemap URLs, 7 `Event` JSON-LD blocks, Webalizer `/stats/` preserved.
>
> Still needs a human:
> 1. **The non-www redirect is still 302.** World4You performs it above the docroot, so
>    the `.htaccess` rewrite never fires. Change it in the control panel.
> 2. Register the www property in Search Console, submit the sitemap, request removal of
>    the old `/posts/*` and `/prose/` URLs.
> 3. Run the live event pages through Google's Rich Results Test.
>
> Also note `deploy.sh` now excludes `stats/` from the `--delete` mirror. Do not remove
> that exclusion: it is the host's Webalizer analytics and is not reproducible.

Audit date: 2026-09-19. Based on a local `hugo` build (v0.165.0) compared against the
live site. Live deploy is stale — `last-modified: Mon, 25 May 2026`.

**Site type:** Hugo static site, TailBliss theme (vendored as a submodule with local
modifications), deployed by FTP mirror (`deploy.sh`) to World4You/Apache.

---

## P0 — Blocking. Do these first.

### 1. Remove the theme's demo content from the production build

`themes/tailbliss/content/` ships 14 lorem-ipsum posts plus `prose.md`, and Hugo merges
theme content into the site. These are **live and returning 200**:

```
https://www.embeddedaustria.com/posts/blog-post-1/   → 200, lorem ipsum
https://www.embeddedaustria.com/prose/               → 200, theme demo page
```

19 of the 55 URLs in `sitemap.xml` are demo junk (`/posts/blog-post-1..7/`,
`/posts/news-post-1..7/`, `/posts/`, `/prose/`, `/categories/blog/`, `/categories/news/`,
`/tags/blog/`, `/tags/news/`). Google is being told a third of the site is placeholder text.

**Fix** — add to `hugo.yaml` (tested, works; drops the sitemap from 55 to 35 real URLs,
leaves `/events/`, `/about/`, `/contact/` and CSS intact):

```yaml
ignoreFiles:
  - "themes/tailbliss/content/"
```

- [x] Add `ignoreFiles` to `hugo.yaml`
- [x] Rebuild, confirm `public/posts/` and `public/prose/` no longer exist
- [x] Old `/posts/*` and `/prose/` URLs now return **410** (verified live)
- [ ] Submit the Search Console removal request for those URLs
      drop out of the index, and submit a removal request in Search Console

### 2. Fix the www / non-www split

`baseURL` is `https://embeddedaustria.com/`, but the server **302-redirects every non-www
request to `https://www.embeddedaustria.com/`**. So every canonical-bearing URL Hugo emits
— `sitemap.xml`, `og:url`, RSS `<link>` — points at a hostname that immediately redirects.
The redirect is also 302 (temporary), which tells Google not to consolidate signals onto www.

- [x] Set `baseURL: 'https://www.embeddedaustria.com/'` in `hugo.yaml`
- [ ] Change the Apache redirect from 302 to **301**. `static/.htaccess` is deployed and
      honoured (gzip + cache headers are live), but the non-www redirect **still returns
      302** because World4You performs it above the docroot, so the rewrite never fires.
      **Must be changed in the World4You control panel.**
- [ ] Pick www as the canonical host in Search Console and register both properties

### 3. Add a canonical tag

There is no `<link rel="canonical">` anywhere on the site. With the host split above, plus
Hugo's paginator emitting `/events/page/1/` as a near-duplicate of `/events/`, this is real
duplicate-content exposure.

- [x] Add to `layouts/partials/meta.html`: `<link rel="canonical" href="{{ .Permalink }}" />`
- [x] Add `<meta name="robots" content="noindex,follow">` on paginated pages
      (`{{ if gt .Paginator.PageNumber 1 }}`) and on `/categories/`, which is now empty

### 4. Add structured data — the biggest single win for this site

There is **no JSON-LD on any page**. For a meetup site this is the largest untapped
opportunity: `Event` markup makes pages eligible for Google's event rich results and event
search surfaces, which is exactly how people look for "embedded meetup Vienna".

Every event already has the data in front matter (`event.date`, `event.location`,
`ticket_url`) — it just isn't emitted anywhere.

- [x] `Event` JSON-LD on each event page: `name`, `startDate`, `endDate`, `location`
      (as `Place` with a real `PostalAddress`), `organizer`, `offers` (the Eventbrite URL),
      `eventAttendanceMode`, `eventStatus`, `description`, `image`
- [x] Convert `event.date` from the current free-text string
      (`"Thursday, November 12th 2026, 18:00 to 22:00 CET"`) into machine-readable
      `start`/`end` fields so `startDate` can be ISO-8601
- [x] `Organization` JSON-LD sitewide: name, url, logo, `sameAs` (LinkedIn, GitHub)
- [x] `BreadcrumbList` on event pages
- [ ] Validate everything in Google's Rich Results Test

---

## P1 — High impact

### 5. robots.txt is a single line with no sitemap

Live content is literally `User-agent: *` — no rules, no sitemap reference.

- [x] Create `layouts/robots.txt` with `User-agent: *`, `Allow: /`, and
      `Sitemap: {{ "sitemap.xml" | absURL }}`

### 6. Fix the homepage title and Open Graph tags

`layouts/partials/meta.html` puts the *description* in the `<title>` on the homepage, with
a leading space and an embedded newline:

```html
<title itemprop="name"> Learn about the future of embedded software! | Embedded Austria
</title>
```

And `og:title` on the homepage renders as `Embedded Austria | Embedded Austria`.

- [x] Homepage title: put the brand and the primary keywords in, e.g.
      `Embedded Austria — Embedded Systems Meetup in Vienna`. The current title contains
      neither "Vienna", "meetup", nor "embedded systems".
- [x] Collapse the whitespace/newline inside `<title>` (use `{{-` / `-}}`)
- [x] Guard `og:title` so the homepage doesn't duplicate the site name

### 7. Fix Open Graph / Twitter card metadata

```html
<meta property="og:image" content="/images/hero.webp" />   <!-- relative — invalid -->
```

- [x] `og:image` must be absolute — use `absURL`, not `relURL`
- [x] Add `og:image:width`, `og:image:height`, `og:image:alt`
- [x] Add `<meta name="twitter:card" content="summary_large_image">`. Without it the
      existing `twitter:title` does nothing and no card renders on X or LinkedIn.
- [x] Add `twitter:description` and `twitter:image`
- [x] Add RSS autodiscovery: `<link rel="alternate" type="application/rss+xml" ...>`
      (Hugo already generates `index.xml`, nothing links to it)

### 8. Event pages never display their own date, location, or ticket link

`layouts/_default/single.html` renders only `{{ .Content }}`. The `event.date`,
`event.location` and `ticket_url` front-matter fields are **never printed in the HTML** —
confirmed: `grep "Floragasse\|November 12"` on the built No. 7 page returns 0 matches.

A visitor landing on an event page cannot see when or where it is, and neither can a crawler.

- [x] Render date, venue and a ticket CTA in `single.html` for the events section
- [x] Wrap the date in `<time datetime="...">`

### 9. Header navigation has one link, and it points off-site

`menu.main` contains only **Tickets** → eventbrite.at. There is no header link to
`/events/`, `/about/`, or `/contact/`. Every internal crawl path depends on the footer and
the homepage.

- [~] Header menu: reverted to Tickets only at the owner's request. Internal crawl
      paths come from the footer menu, event breadcrumbs and per-event cross-links.
- [x] Add `rel="noopener"` on the external Eventbrite links
- [x] Cross-link related events from each event page (e.g. by shared tag)

### 10. `/events/` has no landing content

There is no `content/events/_index.md`, so the section index has an auto-generated title,
no intro copy, and no meta description. This is the page most likely to rank for
"embedded meetup Vienna" / "embedded systems events Austria".

- [x] Create `content/events/_index.md` with a real title, description and 150–300 words
      of intro copy
- [ ] Split upcoming vs past events on that page

---

## P2 — Medium

### 11. No images on any event, so no per-page share image

`content/events/` contains no image files at all. The homepage event cards render without
images (`{{ with $image }}` silently skips), and every event page shares the same generic
`hero.webp`.

- [ ] Add a `featured.*` image as a page resource to each event
- [ ] Fall back to a generated OG image per event if hand-made ones aren't practical

### 12. The hero image is 819 KB and Hugo's resize pipeline is dead

`hugo.yaml` sets `hero.image: "images/hero.webp"`, but `assets/` contains only
`css/main.css` — there is no `assets/images/`. So `resources.Get` returns nil, the
`.Resize "576x576 webp q85"` branch never runs, and the fallback ships the raw 819 KB
static file for a 576×576 slot. `head.html` has the same dead path
(`resources.Get "images/pages/hero.png"`) and preloads the 819 KB original with
`fetchpriority="high"`. This is the LCP element.

- [ ] Move `hero.webp` into `assets/images/` so the resize pipeline actually runs
- [ ] Fix or delete the `images/pages/hero.png` preload branch in `head.html`
- [ ] Re-encode the source; 819 KB for a 576 px render is ~20× larger than needed
- [ ] Delete the unused 991 KB `static/images/hero.jpg`

### 13. No compression and no cache headers on the server

Live response to `Accept-Encoding: gzip, br` returns **no `content-encoding`**, and there
is no `Cache-Control` or `Expires` on HTML or images.

- [ ] Enable mod_deflate/brotli for HTML, CSS, JS, SVG via `.htaccess`
- [ ] Add `Cache-Control` — long max-age for fingerprinted `/css/*` and images, short for HTML
- [ ] Add `.htaccess` to the FTP mirror so these ship with `deploy.sh`
- [ ] Re-run PageSpeed Insights afterwards and record the Core Web Vitals baseline

### 14. `/about/` is actually the imprint, and it's tagged as German

`content/about.md` has `title: "Imprint"`, `description: Imprint`, and `language: de`,
while `<html lang="en">`. The footer's "Imprint" link points at `/about/`. There is no
actual About page — so the site has nothing that explains what Embedded Austria is, which
is a page that would rank.

- [ ] Move the imprint to `content/imprint.md` → `/imprint/`, update the footer menu
- [ ] Write a real `/about/`: what the meetup is, who runs it, where it meets, history
- [ ] Remove the stray `language: de` or serve it properly as a German page

### 15. The contact form posts to the theme's placeholder address

```html
<form action="https://formsubmit.co/your@email.com" method="POST">
```

Not an SEO issue directly, but it silently discards every conversion the SEO work is meant
to produce.

- [ ] Point the form at a real endpoint
- [ ] Also add `id="subject"` / `id="email"` — the `<label for=...>` attributes don't
      currently match any element

### 16. Thin and duplicated meta descriptions

`emb-aut-no6` → `"Embedded Austria No. 6: Functional Safety"` and `emb-aut-no7` →
`"Embedded Austria No. 7: Embedded AI"` just restate the title. No. 7's body is 108 words
(the others are 400–760).

- [ ] Rewrite both descriptions as 140–160 char summaries that earn the click
- [ ] Expand No. 7 with speaker names and talk abstracts once confirmed
- [ ] Backfill speaker names into No. 5 and No. 6 — speaker names are high-value search terms

### 17. Taxonomy sprawl

26 tag pages, most holding a single event. The `categories` taxonomy is declared in
`hugo.yaml` but only the demo posts ever used it, so after task 1 `/categories/` becomes an
indexable empty page.

- [ ] Consolidate tags to ~8–10 that describe recurring themes
- [ ] Fix the typo'd slug: **`artificial-inteligence`** → `artificial-intelligence`
      (currently a live indexed URL) and merge it into the `ai` tag
- [ ] Drop the `categories` taxonomy, or noindex `/categories/`

### 18. No analytics, no Search Console

The only tracking on the live site is Cloudflare Insights. There is no way to measure any
of the above.

- [ ] Verify the site in Google Search Console (www property), submit `sitemap.xml`
- [ ] Add a privacy-friendly analytics tool (Plausible / Umami / GA4)
- [ ] Record a baseline before shipping the P0 items so the impact is measurable

---

## P3 — Housekeeping

- [ ] `.DS_Store` files are being deployed — 3 land in the build output. Add `.DS_Store`
      to `.gitignore` and exclude them from the `lftp mirror` in `deploy.sh`.
- [ ] `deploy.sh` runs a `curl` upload that is expected to fail (`|| true`) before the real
      `lftp mirror`. Delete the dead curl block.
- [ ] The theme submodule has uncommitted local modifications (`m themes/tailbliss`) —
      pin or fork it so builds are reproducible.
- [ ] Add a CI check that fails the build if `public/posts/` or `public/prose/` reappear.
- [ ] Add `lastmod` handling — `sitemap.xml` currently uses content dates, so the homepage
      shows a `lastmod` of 2026-11-12 (a future event date) rather than a real edit date.

---

## Off-site

- [ ] List the meetup on meetup.com, Eventbrite's discovery surfaces, and Austrian tech
      calendars — these drive both links and direct discovery
- [ ] Get links from the host companies' sites (SBA Research, TTTech, Beckhoff, ÖBB) and
      from speakers' company pages (sigma star, sequality, Bitcrush)
- [ ] Post each event to LinkedIn with the canonical www URL so the shares accrue to one host
