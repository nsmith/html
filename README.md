# html — an Agent Skill for publishing HTML

A portable [Agent Skill](https://agentskills.io) that lets any compatible AI agent
publish a single-page HTML document to the public web in one request via
[ht-ml.app](https://ht-ml.app) — no accounts, no signup. It covers creating a
site, updating it, uploading referenced assets, optional password protection, and
ships **20 ready-made page templates** (slide decks, status reports, code reviews,
diagrams, dashboards, and more) for when the user has no HTML of their own.

The agent-facing instructions live in [`SKILL.md`](SKILL.md).

## Install

A skill is just a folder containing `SKILL.md`. To install, put this repo into
your agent's skills directory **in a folder named `html`** (the folder name must
match the skill's `name`). Pick your client below.

### Claude Code

```bash
# Personal (available in every project)
git clone https://github.com/nsmith/html.git ~/.claude/skills/html

# …or per-project (committed with one repo)
git clone https://github.com/nsmith/html.git .claude/skills/html
```

Start (or restart) Claude Code and run `/skills` — `html` should appear. Then ask
something like *"publish this HTML and give me a link"* and it will activate.

### VS Code (GitHub Copilot)

```bash
git clone https://github.com/nsmith/html.git .agents/skills/html
```

Open the project, select **Agent** mode in Copilot Chat, and run `/skills` to
confirm `html` is listed.

### OpenAI Codex & other Agent Skills clients

Clone into the skills directory your client scans (consult its docs — common
locations are `.agents/skills/`, `~/.codex/skills/`, or `.claude/skills/`), again
as a folder named `html`:

```bash
git clone https://github.com/nsmith/html.git <skills-dir>/html
```

### Updating

```bash
cd <wherever-you-installed>/html && git pull
```

## What's inside

```
html/
├── SKILL.md              # Agent instructions (create / update / assets / password / templates)
├── references/api.md     # Full ht-ml.app API reference
├── scripts/publish.sh    # Helper: publish an HTML file → returns the public URL + update_key
├── assets/templates/     # 20 self-contained, single-file HTML templates + catalog
└── evals/                # Eval cases for measuring the skill (see Development)
```

The templates are fully self-contained (all CSS/JS/SVG inlined, no external
assets), so each publishes to ht-ml.app in a single request.

## Development

This repo uses [mise](https://mise.jdx.dev) + [uv](https://docs.astral.sh/uv/) for
its toolchain.

```bash
mise install          # provision Python + uv
mise run validate     # validate against the Agent Skills spec (skills-ref)
mise run install-cli  # install the skills-ref CLI onto your PATH
```

See [`evals/README.md`](evals/README.md) for the skill's evaluation setup.

## Links

- [ht-ml.app](https://ht-ml.app) — the hosting platform this skill targets
- [Agent Skills specification](https://agentskills.io/specification)

## License

MIT
