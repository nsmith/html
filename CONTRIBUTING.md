# Contributing to `html`

Thanks for your interest in improving the `html` Agent Skill! This is a small,
focused project, so contributions of any size are welcome — a new template, a
docs fix, a sharper eval, or a bug report.

By contributing, you agree that your contributions are licensed under the
project's [MIT License](README.md#license).

## Ways to contribute

- **Add a page template** — the most useful contribution (see below).
- **Improve the docs** — `README.md`, `SKILL.md`, or `references/api.md`.
- **Strengthen the evals** — add discriminating cases in `evals/`.
- **Report a bug or request a template** — open an issue.

For anything larger than a small fix, please **open an issue first** so we can
agree on the approach before you invest time. There's no `CONTRIBUTING` police —
when in doubt, ask in an issue.

## Development setup

This repo uses [mise](https://mise.jdx.dev) + [uv](https://docs.astral.sh/uv/)
for its toolchain.

```bash
mise install          # provision Python + uv
mise run validate     # validate the skill against the Agent Skills spec
```

`mise run validate` runs the [`skills-ref`](https://agentskills.io) validator
against the repo. Please make sure it passes before opening a PR.

## Adding a template

Templates live in `assets/templates/` and are the catalog the skill offers when a
user wants to publish something but has no HTML of their own. The bar is: a
template should render nicely out of the box and publish to ht-ml.app in a single
request.

**Conventions (please follow all of these):**

1. **Fully self-contained.** Inline all CSS, JS, and SVG. No external resources —
   no CDN links, no remote fonts, no `<img src="https://…">`. This is what lets a
   template publish in one request with no asset-upload step. (A quick check:
   the file should contain no `http://` or `https://` resource references.)
2. **Mark editable regions** with `<!-- REPLACE: short description -->` comments
   so an agent knows exactly what to swap for the user's real content.
3. **Renders standalone.** Opening the raw file in a browser should look good as a
   live preview, with sensible placeholder content already in place.
4. **Register it in *both* catalogs**, keeping the existing column format:
   - the table in [`assets/templates/README.md`](assets/templates/README.md)
     (use case + when to offer it), and
   - the shorter table in [`SKILL.md`](SKILL.md) (the `…make a presentation`
     phrasing).
5. **Keep it original.** Templates are original work created for this skill.

After adding a template, run `mise run validate` and open the file in a browser to
confirm it renders.

## Evals

The skill's behavior is measured by the cases in [`evals/`](evals/). If your
change affects how the skill behaves (not just docs), consider adding or updating
a case in `evals/evals.json`. See [`evals/README.md`](evals/README.md) for the
setup and how cases are graded.

## Pull requests

- Keep PRs **focused** — one logical change per PR is easier to review and merge.
- Use a clear title and describe **what** changed and **why**.
- For template or behavior changes, confirm `mise run validate` passes and note it
  in the PR.
- Link the issue your PR addresses (e.g. `Closes #12`).

## Reporting bugs

Open an issue with: what you did, what you expected, and what actually happened.
For publishing problems, include the request you made and the API response (but
**never paste an `update_key`** — it's a secret write credential).

Thanks again for helping make `html` better!
