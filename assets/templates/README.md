# Template catalog

Self-contained, single-file HTML templates for common use cases. Every template
inlines all CSS, JS, and SVG — no external resources — so it publishes to
ht-ml.app in a single request with **no asset upload step**.

**How to use one:** read the template file, replace the `<!-- REPLACE: ... -->`
placeholders with the user's real content, then publish the result (see the main
`SKILL.md`). Each renders nicely out-of-the-box, so it doubles as a live preview.

| Template (`assets/templates/…`) | Use case | When to offer it |
| :------------------------------ | :------- | :--------------- |
| `code-approaches.html` | Three Code Approaches | Compare three technical implementation options with trade-offs before picking one. |
| `visual-designs.html` | Visual Design Directions | Present multiple live-rendered layout/palette options side by side to choose from. |
| `implementation-plan.html` | Implementation Plan | Propose how to build something: phased timeline, data-flow diagram, risk table. |
| `annotated-pr.html` | Annotated Pull Request | Publish a code review: a diff with severity-tagged margin notes and a risk map. |
| `pr-writeup.html` | PR Writeup for Reviewers | Summarize a PR: motivation, before/after, file-by-file walkthrough. |
| `module-map.html` | Module Map | Visualize a codebase's modules, dependencies, and a highlighted hot path. |
| `design-system.html` | Living Design System | Document brand colors, type scale, spacing/radius tokens, and component samples. |
| `component-variants.html` | Component Variants | Show a component's sizes, states, and intents on one reference sheet. |
| `animation-sandbox.html` | Animation Sandbox | Prototype and tune a CSS transition with live duration/easing controls. |
| `clickable-flow.html` | Clickable Flow | Demo an interaction as a clickable prototype: linked screens, hotspots. |
| `svg-figure-sheet.html` | SVG Figure Sheet | Publish editable, extractable inline-SVG diagrams/figures for a post or docs. |
| `flowchart.html` | Annotated Flowchart | An interactive pipeline/process diagram; clicking a step reveals its details. |
| `slide-deck.html` | Arrow-Key Slide Deck | A build-free HTML presentation navigable by arrow keys in any browser. |
| `feature-explainer.html` | Feature Explainer | Document a feature: overview, collapsible detail sections, FAQ. |
| `concept-explainer.html` | Concept Explainer | Teach one idea with a live interactive diagram, steps, and a comparison table. |
| `status-report.html` | Weekly Status | A scannable shipping update: metrics, highlights, shipped/in-progress/blocked. |
| `incident-report.html` | Incident Timeline | A post-mortem: summary box, minute-by-minute timeline, follow-up checklist. |
| `triage-board.html` | Ticket Triage Board | A drag-and-drop kanban board with tag filters and Markdown export. |
| `feature-flags.html` | Feature Flag Editor | Grouped flag toggles with dependency warnings and a JSON diff export. |
| `prompt-tuner.html` | Prompt Tuner | Author and live-test a prompt template with editable `{{variable}}` placeholders. |

All templates are original work created for this skill, inspired by the use cases
catalogued at <https://thariqs.github.io/html-effectiveness/>.
