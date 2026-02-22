#!/usr/bin/env bash

FILE="${1:-credential.json}"

if [[ ! -f "$FILE" ]]; then
  echo "Missing credentials file: $FILE" >&2
  return 1 2>/dev/null || exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required. Install it, then run: source ./load_credentials.sh" >&2
  return 1 2>/dev/null || exit 1
fi

for key in ANTHROPIC_API_KEY OPENAI_API_KEY; do
  value="$(jq -r --arg k "$key" '.[$k] // empty' "$FILE")"
  if [[ -n "$value" ]]; then
    export "$key=$value"
    echo "Exported $key"
  fi
done
