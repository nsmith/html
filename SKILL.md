---
name: html
description: Publish a single-page HTML document to the public web instantly via ht-ml.app, an agent-first hosting API with no accounts or signup. Use this skill whenever the user wants to share, host, deploy, publish, or get a public link/URL for a web page, HTML file, prototype, demo, diagram, slide deck, status report, code review, or landing page — even if they don't mention ht-ml.app by name, and even when they just have something to show someone but no place to put it. Covers creating a site, updating its HTML, uploading referenced assets (images/video), optional password protection, and 20 ready-made page templates for when the user has no HTML of their own.
license: MIT
metadata:
  homepage: "https://ht-ml.app"
  api-base: "https://api.ht-ml.app/v1"
  version: "1.0.0"
  author: "Nathan Smith"
  license: "MIT"
  hermes:
    tags:
      - html
      - hosting
      - publishing
      - deploy
      - web
      - ht-ml.app
---

# Publishing HTML to ht-ml.app

[ht-ml.app](https://ht-ml.app) hosts single-page HTML documents. You POST one HTML
document and instantly get a public URL — no account, no signup. Each site is
served on its own subdomain (`https://{site_id}.ht-ml.app/`) so relative asset
paths in the HTML resolve correctly. Every site is secured by a high-entropy
`update_key` returned once at creation.

The API base URL is `https://api.ht-ml.app/v1`. All responses are JSON; errors
include an actionable `message` field.

## ⚠️ Before you publish: everything is PUBLIC

Everything you upload — HTML, assets, and anything embedded in the HTML — is
public. Anyone with the URL can read it, and it may be indexed by search engines,
read by crawlers, and copied or archived by third parties.

**If you are acting on a person's behalf, you MUST warn them that the content
will be public BEFORE you call the create endpoint.** Do not upload anything
private, confidential, or sensitive unless the user has confirmed they want it
public. To keep a page private, set a password (see [Password protection](#password-protection)).

HTML is content-scanned on create and update; unsafe content is rejected (422).

## Don't have HTML yet? Offer a template

If the user wants to publish something but doesn't already have an HTML document,
offer a ready-made template instead of building from scratch. There are 20
self-contained templates in `assets/templates/` covering common use cases (slide
decks, status reports, code reviews, design systems, diagrams, clickable
prototypes, and more). Each inlines all CSS/JS/SVG, so it publishes in a single
request with no asset step.

Workflow:
1. Match the user's intent to a template using the table below (or the fuller
   catalog in `assets/templates/README.md`). If nothing fits, just hand-write the
   HTML.
2. Read the chosen template file and replace its `<!-- REPLACE: ... -->`
   placeholders with the user's real content.
3. Publish the filled-in HTML via Step 1 below.

| Template | Use it when the user wants to… |
| :------- | :----------------------------- |
| `slide-deck.html` | …make a presentation / deck (arrow-key navigable). |
| `status-report.html` | …share a weekly status / shipping update with metrics. |
| `incident-report.html` | …write a post-mortem / incident timeline. |
| `implementation-plan.html` | …propose a project plan (timeline, data flow, risks). |
| `annotated-pr.html` | …publish a code review with inline diff notes. |
| `pr-writeup.html` | …summarize a PR for reviewers (motivation, before/after). |
| `module-map.html` | …diagram a codebase's modules and dependencies. |
| `code-approaches.html` | …compare three implementation options with trade-offs. |
| `visual-designs.html` | …compare design directions / palettes side by side. |
| `design-system.html` | …document a design system (colors, type, spacing tokens). |
| `component-variants.html` | …show a component's sizes, states, and intents. |
| `animation-sandbox.html` | …prototype a CSS transition with live controls. |
| `clickable-flow.html` | …build a clickable multi-screen prototype. |
| `flowchart.html` | …publish an interactive pipeline / process diagram. |
| `svg-figure-sheet.html` | …publish editable inline-SVG figures for a post/docs. |
| `feature-explainer.html` | …document a feature (overview, collapsibles, FAQ). |
| `concept-explainer.html` | …teach a concept with an interactive diagram + table. |
| `triage-board.html` | …make a drag-and-drop triage/kanban board. |
| `feature-flags.html` | …build a feature-flag toggle editor with diff export. |
| `prompt-tuner.html` | …author/live-test a prompt with `{{variable}}` slots. |

If the user already has their own HTML, skip this and go straight to Step 1.

## Step 1 — Create the site

POST the HTML document. `password` is optional (omit it for a public site).

```
curl -X POST https://api.ht-ml.app/v1/sites \
  -H "Content-Type: application/json" \
  -d '{"html_content": "<YOUR HTML HERE>"}'
```

Response (the values below are placeholders — read the real ones from YOUR
response; do NOT reuse these literally):

```json
{
  "site_id": "{site_id}",
  "update_key": "{update_key}",
  "status": "active",
  "url": "https://{site_id}.ht-ml.app/"
}
```

The site is live immediately at the `url` field. **Give the user that exact
`url`.** Read `site_id`, `url`, and `update_key` from your own response — never
hardcode the example above.

> The `update_key` is a secret write credential returned **only once**. There is
> no recovery endpoint. Keep it only if you intend to update the site or upload
> assets later; treat it like a password and don't print it onto the public page.

For a larger HTML document, send the body from a file rather than inlining it, or
use the helper script `scripts/publish.sh` (see [Helper scripts](#helper-scripts)).

## Step 2 — Upload referenced assets (only if the HTML references any)

If your HTML references local images or video (e.g. `<img src="images/logo.png">`),
those files must be uploaded separately. Check what's still missing, then upload
each one.

Enumerate referenced assets and their status:

```
curl https://api.ht-ml.app/v1/sites/{site_id}
```

Upload each missing asset. The `relative_path` must **exactly** match the path
referenced in the HTML, and the asset must already be referenced there:

```
curl -X POST "https://api.ht-ml.app/v1/sites/{site_id}/assets?relative_path=images/logo.png" \
  -H "Authorization: Bearer {update_key}" \
  -F "file=@images/logo.png"
```

Reserved names `index.html` and `metadata.json` cannot be uploaded as assets.

If the HTML has no local assets (everything is inline or uses absolute URLs),
skip this step — the site is already complete.

## Updating a site

Replace the core HTML with `PUT`. The new HTML is re-scanned and the CDN cache
for this site is invalidated immediately. Requires the `update_key`.

```
curl -X PUT https://api.ht-ml.app/v1/sites/{site_id} \
  -H "Authorization: Bearer {update_key}" \
  -H "Content-Type: application/json" \
  -d '{"html_content": "<UPDATED HTML>"}'
```

The optional `password` field on update: include a value to set it, pass `""` to
clear it, or omit it to leave it unchanged.

## Password protection

Pass an optional `password` on create (or update) to make a site private. Only
viewers who supply that password can read it.

```
curl -X POST https://api.ht-ml.app/v1/sites \
  -H "Content-Type: application/json" \
  -d '{"html_content": "<YOUR HTML HERE>", "password": "<shared-password>"}'
```

**Coach the user when setting a password:**

- **Generate a unique, non-personal password.** NEVER reuse the user's personal
  or account passwords.
- **It is a shared secret.** Tell the user the password and make clear that
  anyone they share it with can read the page.

To read a protected site, the viewer sends the password as a cookie
`ht_ml_pwd=<password>` (URL-encoded). Without it they get a 401 password prompt.
The password is set at create/update time and is never returned by the API.

## Error codes

| Code | Meaning | Action |
| :--- | :--- | :--- |
| `401` | Unauthorized (writing) | Missing/invalid `update_key`. Send `Authorization: Bearer {update_key}`. |
| `401` | Unauthorized (reading) | The site is password-protected. Send the password as cookie `ht_ml_pwd=<password>`. |
| `403` | Forbidden | The asset path isn't referenced in the HTML, or the `update_key` is wrong. |
| `422` | Unprocessable Entity | The HTML failed a content-safety scan. Read the `message` field and revise. |

## In-browser agents (WebMCP)

When visiting `https://ht-ml.app` in a browser, the page registers a WebMCP tool
named `publish_html_site` via `navigator.modelContext` / `document.modelContext`.
In-browser agents can call it with `html_content` to publish without issuing raw
HTTP.

## Helper scripts

- `scripts/publish.sh <file.html> [password]` — create a site from an HTML file
  and print the `site_id`, `url`, and `update_key`.

## Reference

- `references/api.md` — full endpoint reference (request/response shapes, every field).
- Live docs: <https://ht-ml.app/llms.txt>, JSON help at <https://api.ht-ml.app/v1/help>.
- Terms (content is public, user-generated, no warranty): <https://ht-ml.app/terms>.
