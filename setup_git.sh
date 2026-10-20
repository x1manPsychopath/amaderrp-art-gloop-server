#!/usr/bin/env sh
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_name="${1:-amaderrp-art-gloop-server}"
visibility="${2:-public}"

case "$visibility" in
  public|private) ;;
  *) echo "Visibility must be public or private." >&2; exit 2 ;;
esac

git init
git add .

forbidden="$(git diff --cached --name-only | grep -E '(^|/)(world|logs|backups|libraries|versions)/|key\.pem$|\.jar$|^(ops|whitelist|banned-|usercache)' || true)"
if [ -n "$forbidden" ]; then
  echo "Refusing to commit sensitive/runtime files:" >&2
  echo "$forbidden" >&2
  exit 1
fi

if ! git diff --cached --quiet; then
  git commit -m "Initial commit: Minecraft 26.2 Geyser NPC server setup"
fi

gh auth status
if git remote get-url origin >/dev/null 2>&1; then
  git push -u origin HEAD
else
  gh repo create "$repo_name" "--$visibility" --source=. --remote=origin --push
fi

