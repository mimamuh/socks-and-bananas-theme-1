#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ -n "$(git status --porcelain)" ]; then
	echo "❌ deploy: working tree is not clean; commit or stash first." >&2
	exit 1
fi

prior=$(git rev-parse --abbrev-ref HEAD)
if [ "$prior" = "HEAD" ]; then
	prior=$(git rev-parse HEAD)
	prior_label="detached at $(git rev-parse --short HEAD)"
else
	prior_label="$prior"
fi

git fetch origin
git checkout deploy
git merge origin/main --no-edit
git push origin deploy
git checkout "$prior"

echo "✅ deploy: pushed deploy (merged origin/main); restored $prior_label."
