#!/usr/bin/env bash
# Publish an HTML file to ht-ml.app and print the resulting site_id, url, and
# update_key.
#
# Usage:
#   scripts/publish.sh <file.html> [password]
#
# Reminder: everything published is PUBLIC. If you are acting on someone's
# behalf, confirm they want this public before running. Pass a password as the
# second argument to make the site private (a shared, non-personal secret).
#
# Requires: curl, and either jq (preferred) or python3 for JSON encoding.
set -euo pipefail

API="${HT_ML_API:-https://api.ht-ml.app/v1}"

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <file.html> [password]" >&2
  exit 64
fi

html_file="$1"
password="${2:-}"

if [[ ! -f "$html_file" ]]; then
  echo "Error: file not found: $html_file" >&2
  exit 66
fi

# Build the JSON request body safely (the HTML must be JSON-string-escaped).
build_body() {
  if command -v jq >/dev/null 2>&1; then
    if [[ -n "$password" ]]; then
      jq -n --rawfile html "$html_file" --arg pw "$password" \
        '{html_content: $html, password: $pw}'
    else
      jq -n --rawfile html "$html_file" '{html_content: $html}'
    fi
  elif command -v python3 >/dev/null 2>&1; then
    HT_ML_HTML_FILE="$html_file" HT_ML_PASSWORD="$password" python3 - <<'PY'
import json, os
html = open(os.environ["HT_ML_HTML_FILE"], encoding="utf-8").read()
body = {"html_content": html}
pw = os.environ.get("HT_ML_PASSWORD") or ""
if pw:
    body["password"] = pw
print(json.dumps(body))
PY
  else
    echo "Error: need jq or python3 to encode the request body." >&2
    exit 69
  fi
}

response="$(build_body | curl -sS -X POST "$API/sites" \
  -H "Content-Type: application/json" \
  --data-binary @-)"

# Pretty-print if jq is available; otherwise emit the raw JSON.
if command -v jq >/dev/null 2>&1; then
  echo "$response" | jq .
  status="$(echo "$response" | jq -r '.status // empty')"
  if [[ "$status" != "active" ]]; then
    echo "Publish did not succeed (status: ${status:-unknown}). See message above." >&2
    exit 1
  fi
  echo
  echo "Live at: $(echo "$response" | jq -r '.url')"
  echo "Save this update_key (shown only once): $(echo "$response" | jq -r '.update_key')"
else
  echo "$response"
fi
