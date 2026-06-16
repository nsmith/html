#!/bin/sh
# Install the `html` Agent Skill (https://github.com/nsmith/html).
#
#   curl -fsSL https://raw.githubusercontent.com/nsmith/html/main/install.sh | sh
#
# By default it installs into the regular user-level skill locations for BOTH
# Claude Code (~/.claude/skills/html) and Codex (~/.agents/skills/html), so the
# skill is available in either agent.
#
# Override the destination(s):
#   # Single parent dir (folder `html` is appended)
#   curl -fsSL .../install.sh | SKILLS_DIR=.claude/skills sh   # project-local Claude
#   curl -fsSL .../install.sh | SKILLS_DIR=.agents/skills sh   # project-local Codex/VS Code
#   # One exact destination folder
#   curl -fsSL .../install.sh | DEST=/path/to/skills/html sh
#
# Other env vars: BRANCH (default main), FORCE=1 (overwrite a non-git dir),
# REPO (override source, e.g. for testing).
set -eu

REPO="${REPO:-https://github.com/nsmith/html}"
BRANCH="${BRANCH:-main}"

# Destinations. Each folder MUST be named `html` (matches the skill `name`).
if [ -n "${DEST:-}" ]; then
  TARGETS="$DEST"
elif [ -n "${SKILLS_DIR:-}" ]; then
  TARGETS="$SKILLS_DIR/html"
else
  TARGETS="$HOME/.claude/skills/html $HOME/.agents/skills/html"
fi

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$1" >&2; exit 1; }

fetch() { # fetch <dest>
  dest="$1"
  if [ -d "$dest/.git" ]; then
    info "Updating existing install at $dest"
    git -C "$dest" pull --ff-only
    return
  fi
  if [ -e "$dest" ]; then
    [ "${FORCE:-0}" = "1" ] || die "$dest exists and is not a git checkout. Re-run with FORCE=1 to overwrite."
    info "Removing existing $dest (FORCE=1)"; rm -rf "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  if command -v git >/dev/null 2>&1; then
    info "Cloning $REPO ($BRANCH) into $dest"
    git clone --depth 1 --branch "$BRANCH" "$REPO" "$dest"
  else
    command -v curl >/dev/null 2>&1 || die "need git or curl to install."
    info "git not found; downloading tarball into $dest"
    tmp="$(mktemp -d)"
    curl -fsSL "${REPO%.git}/archive/refs/heads/$BRANCH.tar.gz" | tar -xzf - -C "$tmp"
    mkdir -p "$dest"
    cp -R "$tmp"/*/. "$dest"/   # tarball extracts to a single html-<branch>/ dir
    rm -rf "$tmp"
  fi
  [ -f "$dest/SKILL.md" ] || die "install looks wrong — no SKILL.md at $dest"
}

for dest in $TARGETS; do
  fetch "$dest"
  ok "Installed the 'html' skill to $dest"
done

cat <<EOF

Next:
  • Restart your agent and run /skills — 'html' should appear.
  • Then try: "publish this HTML and give me a public link".
  • Update later by re-running this installer (or: git -C <dir> pull).
EOF
