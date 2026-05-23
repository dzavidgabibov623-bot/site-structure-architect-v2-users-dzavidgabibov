#!/bin/zsh

set -euo pipefail

label="${1:-update}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this script from inside a git repository." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash current changes first." >&2
  exit 1
fi

current_branch="$(git branch --show-current)"
if [[ "$current_branch" != "main" ]]; then
  echo "Current branch: $current_branch" >&2
  echo "Switch to main before starting a new change." >&2
  exit 1
fi

timestamp="$(date +%Y%m%d-%H%M)"
slug="$(printf '%s' "$label" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

if [[ -z "$slug" ]]; then
  slug="update"
fi

branch_name="work/${timestamp}-${slug}"
tag_name="snapshot/${timestamp}-${slug}"

git tag -a "$tag_name" -m "Snapshot before ${label}"
git switch -c "$branch_name"

if git remote get-url origin >/dev/null 2>&1; then
  git push -u origin "$branch_name" >/dev/null
fi

echo "Created branch: $branch_name"
echo "Created snapshot tag: $tag_name"
echo "You can now make changes safely outside main."
